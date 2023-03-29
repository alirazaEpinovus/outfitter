import 'package:flutter/material.dart';
import 'package:outfitters/UI/Widgets/LoadingAnimation.dart';

class LoadingDialouge {
  void showLoadingDialog(BuildContext context, String message) {
    // flutter defined function

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 3)).then((_) {
          Navigator.of(context, rootNavigator: true).pop();
        });
        return Container(
          color: Colors.transparent,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(width: 30, height: 30, child: LoadingAnimation()),
                Text(
                  message,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontStyle: FontStyle.italic),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
