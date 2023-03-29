// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:outfitters/Database/DatabaseHelper.dart';
import 'package:outfitters/UI/Notifiers/WishNotifer.dart';
import 'package:provider/provider.dart';

class WishHeart extends StatefulWidget {
  final graphid;
  final image;
  final name;
  final price;
  final value;
  final onlinestoreUrl;
  WishHeart({
    @required this.graphid,
    @required this.image,
    @required this.name,
    @required this.value,
    @required this.price,
    @required this.onlinestoreUrl,
    // @required this.available
  })  : assert(graphid != null),
        assert(image != null),
        assert(price != null),
        assert(value != null),
        assert(name != null);

  @override
  _WishHeartState createState() => _WishHeartState();
}

class _WishHeartState extends State<WishHeart> {
  int isfv = 0;
  final databaseHelper = DatabaseHelper.instance;

  @override
  void initState() {
    databaseHelper.checkwishexist(widget.graphid).then((onValue) {
      if (onValue) {
        if (mounted) {
          setState(() {
            isfv = 1;
          });
        }
      }
    });
    super.initState();
  }

  // FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: isfv,
      children: <Widget>[
        Container(
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
                splashColor: Colors.grey.withOpacity(0.7),
                onTap: () async {
                  Map<String, dynamic> row = {
                    "graphid": widget.graphid,
                    "wishproduct_name": widget.name,
                    "wishproduct_image": widget.image,
                    "wishproduct_price": widget.price,
                    "p_value": widget.value,
                    "isFav": 'true',
                    "onlineStoreUrl": widget.onlinestoreUrl,
                    // "available": widget.available.toString(),
                  };
                  setState(() => isfv = 1);
                  databaseHelper.insertWishlist(row).then((val) {
                    if (val != -1) {
                      setState(() {
                        isfv = 1;
                        Provider.of<WishNotifier>(context, listen: false)
                            .getWishlistCount();
                      });
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(3),
                  child: Icon(
                    Feather.heart,
                    size: 18,
                  ),
                )),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.grey.withOpacity(0.7),
            onTap: () {
              setState(() => isfv = 0);
              databaseHelper.deletewish(widget.graphid).then((val) {
                if (val == 1) {
                  setState(() {
                    isfv = 0;
                    Provider.of<WishNotifier>(context,listen: false).getWishlistCount();
                  });
                }
              });
            },
            child: Container(
                padding: EdgeInsets.all(3),
                child: Icon(
                  Icons.favorite,
                  size: 20,
                  color: Colors.red,
                )),
          ),
        ),
      ],
    );
  }

  // wishHeartsendAnalyticsEvent() async {
  //   FirebaseAnalytics analytics = FirebaseAnalytics();
  //   await analytics.logAddToWishlist(
  //     itemName: widget.name,
  //     itemId: widget.graphid,
  //     itemCategory: widget.name,
  //     price: widget.price,
  //   );
  // }
}
