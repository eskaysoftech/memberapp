import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle cmlogo(double size, Color color) {
  return GoogleFonts.poiretOne(
    textStyle: TextStyle(
        fontSize: (size),
        color: color,
        letterSpacing: 2,
        fontWeight: FontWeight.bold),
  );
}

TextStyle fontFile(double size, Color color, double ls, FontWeight wi) {
  return GoogleFonts.quicksand(
    textStyle: TextStyle(
        fontSize: (size), color: color, letterSpacing: ls, fontWeight: wi),
  );
}

TextStyle fontFileOW(double size, Color color, double ls, FontWeight wi) {
  return GoogleFonts.oswald(
    textStyle: TextStyle(
        fontSize: (size), color: color, letterSpacing: ls, fontWeight: wi),
  );
}

TextStyle fontWithheight(double size, Color color, double ls, FontWeight wi) {
  return GoogleFonts.quicksand(
    textStyle: TextStyle(
        fontSize: (size),
        color: color,
        letterSpacing: ls,
        fontWeight: wi,
        height: 1),
  );
}

final Shader linearGradient = LinearGradient(
  colors: <Color>[Color(0xFF2868C8), Color(0xFFB2C9FF)],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

TextStyle fontFileWithGr(double size, Color color, double ls, FontWeight wi) {
  return GoogleFonts.quicksand(
    textStyle: TextStyle(
        fontSize: (size),
        color: color,
        letterSpacing: ls,
        fontWeight: wi,
        foreground: Paint()..shader = linearGradient),
  );
}
