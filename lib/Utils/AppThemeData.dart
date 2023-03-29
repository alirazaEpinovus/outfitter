import 'package:flutter/material.dart';

class Colors {
  const Colors();

  static const Color black = const Color(0xFFD01118);
  static const Color grey = const Color(0xFFC7C4C4);
  static const Color blue = const Color(0xFF1508D1);
}

class TextTheme {
  const TextTheme();

  static TextStyle titleText = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18,
  );

  static TextStyle titlebold = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 18,
  );

  static TextStyle boldText =
      TextStyle(fontWeight: FontWeight.w800, fontSize: 18);

  static TextStyle regularTextBig = TextStyle(fontSize: 18);
  static TextStyle smallgreyText = TextStyle(
    color: Colors.grey,
    fontSize: 12,
  );

  static TextStyle smallboldText =
      TextStyle(fontSize: 12, fontWeight: FontWeight.bold);

  static TextStyle smalltext = TextStyle(
    fontSize: 12,
  );

  static TextStyle greyBoldText =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey);

  static TextStyle regulartext16 = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  static TextStyle regulartext16Simple = TextStyle(
    fontSize: 16,
  );
}
