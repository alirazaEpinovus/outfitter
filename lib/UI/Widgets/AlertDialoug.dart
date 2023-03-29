import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertDialoug extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    showalertDialog(context, 'messagestr');
  }

  showalertDialog(BuildContext context, String messagestr) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "Info";
        String message = messagestr;
        String btnLabelCancel = "Cancel";
        return Platform.isIOS
            ? new CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  TextButton(
                    child: Text(btnLabelCancel),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              )
            : new AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  TextButton(
                    child: Text(btnLabelCancel),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              );
      },
    );
  }
}
