import 'package:flutter/material.dart';
import 'package:outfitters/UI/Notifiers/WishNotifer.dart';
import 'package:provider/provider.dart';

class WishCountItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, WishNotifier wishNotifier, _) {
      return Visibility(
        visible: wishNotifier.wishlistcount == 0 ? false : true,
        child: Container(
          transform: Matrix4.translationValues(0.0, -7.0, 0.0),
          margin: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 0.6)),
          child: Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                '${wishNotifier.wishlistcount}',
                style: TextStyle(fontSize: 11),
              )),
        ),
      );
    });
  }
}
