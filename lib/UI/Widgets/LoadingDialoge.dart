import 'package:flutter/material.dart';
import 'package:outfitters/UI/Widgets/LoadingAnimation.dart';


class LoadingDialouge {
  void showLoadingDialog(BuildContext context, String message) {
    // flutter defined function

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: SimpleDialog(
            backgroundColor: Colors.transparent,
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Container(
                     width: 30, height: 30, child: LoadingAnimation()),
                      Text(
                        message,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontStyle: FontStyle.italic),
                      )
                    ],
                  ))
            ],
          ),
        );
      },
    );
  }
}
