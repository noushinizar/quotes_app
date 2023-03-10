
import 'package:flutter/material.dart';
import 'package:quotes_app/utils.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class QuotesPage extends StatefulWidget {
  final String categoryname;

  QuotesPage(this.categoryname);

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  List quotes=[];
  List authors=[];
  bool isDataThere = false;
  @override
  void initState() {

    super.initState();
    setState(() {
      getquotes();
    });
  }
  getquotes() async {
    String url= "https://quotes.toscrape.com/tag/${widget.categoryname}/";
    Uri uri=Uri.parse(url);
    http.Response response= await http.get(uri);
    dom.Document document = parser.parse(response.body);
    final quotesclass= document.getElementsByClassName("quote");
     /* for(int i=0;i< quotesclass.length;i++){
        quotes.add(quotesclass[i].getElementsByClassName('text')[0].innerHtml);
      }*/

   // print(quotesclass[0].getElementsByClassName('text')[0].innerHtml);
  // print(quotes);
    quotes=
        quotesclass.map((element) => element.getElementsByClassName('text')[0].innerHtml).toList();
    authors=
        quotesclass.map((element) => element.getElementsByClassName('author')[0].innerHtml).toList();
    //print(authors);
    setState(() {
      isDataThere = true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent,
      body:isDataThere== false? Center(child: CircularProgressIndicator(),): SingleChildScrollView(
        physics: ScrollPhysics(),
        child:  Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 40),
              child: Text(
                "${widget.categoryname} quotes",
                style: textstyl(30,Colors.black,FontWeight.w700),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: quotes.length,
                itemBuilder: (context ,index){
              return Container(
                padding: EdgeInsets.all(10),
                child: Card(
                  color: Colors.white.withOpacity(0.8),
                  elevation: 10,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20,left: 20,bottom: 20),
                        child: Text(quotes[index],
                        style: textstyl(18,Colors.black,FontWeight.w700),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(authors[index],
                          style: textstyl(15,Colors.black,FontWeight.w700),),
                      )
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
