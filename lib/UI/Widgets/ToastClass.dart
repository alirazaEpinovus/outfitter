import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toast {
  static void showToast(BuildContext context, String message) {
    Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.CENTER,
        textColor: Colors.white,
        fontSize: 16.0);
      }
      }
