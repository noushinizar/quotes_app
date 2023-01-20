import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle textstyl(double size,[Color? color,FontWeight? fw]){
  return GoogleFonts.montserrat(
    color: color,
    fontSize: size,
    fontWeight: fw,
  );
}