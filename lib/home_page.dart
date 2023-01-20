import 'package:flutter/material.dart';
import 'package:quotes_app/quotesPage.dart';
import 'package:quotes_app/utils.dart';

import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> Categories = ["love","inspirational","life","humor"];

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
    String url= "https://quotes.toscrape.com/";
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
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 40),
              child: Text('Quotes App',
              style: textstyl(25,Colors.black,FontWeight.bold),
              ),
            ),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: Categories.map((Category)  {
                return InkWell(
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>QuotesPage(Category)));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Center(
                      child: Text(
                        Category.toUpperCase(),
                        style: textstyl(20,Colors.black,FontWeight.bold),
                      ),
                    ),

                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 40,),
            isDataThere== false? Center(child: CircularProgressIndicator(),):
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
