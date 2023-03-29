import 'dart:convert';

// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:outfitters/Database/DatabaseHelper.dart';
import 'package:outfitters/Models/WishlistModel.dart';
import 'package:outfitters/UI/Widgets/PhotoItem.dart';
import 'package:outfitters/UI/Widgets/WishAddToCart.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;
import 'package:shared_preferences/shared_preferences.dart';

class WishWidget extends StatefulWidget {
  final WishListModel wishListModel;
  final Animation animation;
  final Function onRemove;

  final database = DatabaseHelper.instance;

  WishWidget({@required this.wishListModel, this.animation, this.onRemove})
      : assert(wishListModel != null);
  @override
  _WishWidgetState createState() => _WishWidgetState();
}

class _WishWidgetState extends State<WishWidget> {
  SharedPreferences sharedPreferences;
  dynamic labels;
  loadValues() async {
    sharedPreferences = await SharedPreferences.getInstance();
    labels = json.decode(sharedPreferences.getString("labels"));

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadValues();
  }

  @override
  Widget build(BuildContext context) {
    return sharedPreferences == null
        ? Container()
        : SizeTransition(
            sizeFactor: widget.animation,
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          height: 90,
                          width: 70,
                          child: PhotoItem(
                              imageUrl: widget.wishListModel.productImage)),
                      Expanded(
                        child: Container(
                          height: 90,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 7),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.wishListModel.productName,
                                    style: AppTheme.TextTheme.smalltext,
                                  ),
                                ],
                              ),
                              Container(
                                alignment: FractionalOffset.bottomRight,
                                child: Text(
                                  'PKR. ${widget.wishListModel.productPrice.toString()}',
                                  style: AppTheme.TextTheme.regulartext16Simple,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            widget.database
                                .deletewish(widget.wishListModel.productGraphid)
                                .then((onValue) =>
                                    widget.onRemove(widget.wishListModel));
                          },
                          child: Row(
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  margin: EdgeInsets.only(right: 6),
                                  child: Icon(
                                    Icons.clear,
                                    size: 16,
                                  )),
                              Text(
                                labels["delete"],
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: AppTheme.Colors.grey,
                  )
                ],
              ),
            ),
          );
  }

  // _sendAnalyticsEvent(pId, pName, pPrice) async {
  //   FirebaseAnalytics analytics = FirebaseAnalytics();

  //   await analytics.logAddToCart(
  //     itemId: pId,
  //     itemName: pName,
  //     itemCategory: pName,
  //     quantity: 1,
  //     price: pPrice,
  //   );
  // }
}
