import 'package:flutter/material.dart';

class S {
  /// Custom method for Divider
  static sDivider({Color color = Colors.transparent, double thickness = 0.0, double height = 16.0}) {
    return Divider(color: color, thickness: thickness, height: height);
  }

  /// Custom method for Vertical Divider
  static sVerticalDivider({Color color = Colors.transparent, double thickness = 16.0, double width = 16.0}) {
    return VerticalDivider(color: color, thickness: thickness, width: width);
  }
}