import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:outfitters/Database/DatabaseHelper.dart';
import 'package:outfitters/Models/WishlistModel.dart';
import 'package:outfitters/UI/Notifiers/CartNotifier.dart';
import 'package:outfitters/UI/Notifiers/WishNotifer.dart';
import 'package:outfitters/UI/Screens/ProductDetailCart.dart';
import 'package:outfitters/UI/Screens/ShareWhatsapp.dart';
import 'package:outfitters/UI/Screens/ShareWishlist.dart';
import 'package:outfitters/UI/Screens/ShoppingBag.dart';
import 'package:outfitters/UI/Widgets/WishWidget.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Wishlist extends StatefulWidget {
  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  double screenWidth, screenHeight;
  Size size;
  final database = DatabaseHelper.instance;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  List<WishListModel> wishlist = [];
  StreamController<List<WishListModel>> wishstream =
      StreamController<List<WishListModel>>.broadcast();
  SharedPreferences sharedPreferences;
  dynamic labels;

  loadValues() async {
    sharedPreferences = await SharedPreferences.getInstance();
    labels = json.decode(sharedPreferences.getString("labels"));

    setState(() {});
  }

  @override
  void initState() {
    wishstream.sink.add(wishlist);
    super.initState();
    loadValues();

  }

  @override
  Widget build(BuildContext context) {
    Provider.of<WishNotifier>(context, listen: true);


    size = MediaQuery.of(context).size;
    screenHeight = size.height - kBottomNavigationBarHeight;
    screenWidth = size.width;
    return sharedPreferences == null
        ? Container()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 2,
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: InkWell(
                onTap: () {
                  database.deleteAllWish();
                },
                child: Text(
                  labels["wishlist"],
                  style: AppTheme.TextTheme.titlebold,
                ),
              ),
              actions: <Widget>[
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: InkWell(
                        onTap: () => Navigator.of(context)
                            .push(PageTransition(
                                child: ShoppingBag(),
                                type: PageTransitionType.bottomToTop))
                            .then((value) => value ? setState(() {}) : null),
                        child: Center(
                          child: Container(
                              height: 22,
                              width: 22,
                              child: Stack(
                                children: <Widget>[
                                  SvgPicture.asset('assets/images/bag.svg',
                                      width: 20,
                                      color:
                                          Theme.of(context).primaryColorLight),
                                  Center(
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 4, right: 1.2),
                                          child: Consumer(builder:
                                              (BuildContext context,
                                                  CartNotifier cartNotifier,
                                                  _) {
                                            return Text(
                                                '${cartNotifier.totalItems}',
                                                style: TextStyle(fontSize: 10));
                                          })))
                                ],
                              )),
                        )))
              ],
            ),
            body: Container(
                width: screenWidth,
                height: MediaQuery.of(context).size.height,
                child: FutureBuilder<List<WishListModel>>(
                    future: database.wishqueryAllRows(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.data.length > 0) {
                          wishlist = snapshot.data;

                          return Stack(
                            // verticalDirection: VerticalDirection.down,
                            children: <Widget>[
                              SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height - 200,
                                  margin: EdgeInsets.only(top: 10, bottom: 200),
                                  child: AnimatedList(
                                      initialItemCount: snapshot.data.length,
                                      shrinkWrap: true,
                                      key: _listKey,
                                      itemBuilder: (BuildContext context,
                                          int index, Animation animation) {
                                        wishstream.sink.add(snapshot.data);
                                        return InkWell(
                                          onTap: () {
                                            setState(() {});

                                            Navigator.of(context)
                                                .push(PageTransition(
                                                    child: ProductDetailsCart(
                                                      productId: snapshot
                                                          .data[index]
                                                          .productGraphid,
                                                      cValue: snapshot
                                                          .data[index].value,
                                                    ),
                                                    type: PageTransitionType
                                                        .fade))
                                                .then((value) => value
                                                    ? setState(() {})
                                                    : null);
                                          },
                                          child: WishWidget(
                                            wishListModel: snapshot.data[index],
                                            animation: animation,
                                            onRemove: removeSingleItems,
                                          ),
                                        );
                                      }),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 20),
                                  child: Column(
                                    children: <Widget>[
                                      Divider(
                                        color: Colors.grey,
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 4),
                                        child:
                                            StreamBuilder<List<WishListModel>>(
                                                stream: wishstream.stream,
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    return Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                              '${snapshot.data.length} Item'),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                              '${totalPrice(snapshot.data)} PKR'),
                                                        ),
                                                      ],
                                                    );
                                                  } else {
                                                    return SizedBox();
                                                  }
                                                }),
                                      ),
                                      InkWell(
                                        onTap: () => shareOptionDisplay(),
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: 3, bottom: 4),
                                          padding:
                                              EdgeInsets.symmetric(vertical: 6),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .primaryColorLight,
                                                  width: 2.3)),
                                          child: Center(
                                              child: Text(
                                                  labels["share_wishlist"])),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          );
                        } else {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(bottom: 15),
                                  child: SvgPicture.asset(
                                    'assets/images/wishlist_unactive.svg',
                                    color: Colors.grey[500],
                                    height: 23,
                                    width: 23,
                                  ),
                                ),
                                Text(
                                  labels["wishlist_empty"],
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      letterSpacing: 1),
                                ),
                              ],
                            ),
                          );
                        }
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    })),
          );
  }

  removeSingleItems(WishListModel wishmodel) {
    int removeIndex = wishlist.indexOf(wishmodel);
    WishListModel wishListModel = wishlist.removeAt(removeIndex);
    wishstream.sink.add(wishlist);

    Provider.of<WishNotifier>(context, listen: false).getWishlistCount();

    AnimatedListRemovedItemBuilder builder = (context, animation) {
      return WishWidget(
        wishListModel: wishListModel,
        animation: animation,
        onRemove: removeSingleItems,
      );
    };
    _listKey.currentState.removeItem(removeIndex, builder,
        duration: const Duration(milliseconds: 500));
    if (wishlist.isEmpty) setState(() {});
  }

  int totalPrice(List<WishListModel> w) {
    int total = 0;
    w.forEach((data) {
      total = total + data.productPrice;
    });
    return total;
  }

  void shareOptionDisplay() {
    showModalBottomSheet(
        context: context,
        elevation: 5,
        builder: (BuildContext context) {
          return Container(
            height: 130,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    'Share With',
                    style: AppTheme.TextTheme.titlebold,
                  ),
                ),
                Container(
                  // padding: EdgeInsets.symmetric(horizontal: 40, vertical: ),
                  margin: EdgeInsets.only(top: 10, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  PageTransition(
                                      child: ShareWhatsapp(),
                                      type: PageTransitionType.bottomToTop,
                                      settings: RouteSettings(
                                          name: 'Share Whatsapp')));
                            },
                            child: SvgPicture.asset(
                              'assets/images/whatsapp.svg',
                              height: 45,
                              width: 45,
                            )),
                      ),
                      Expanded(
                        child: InkWell(
                            onTap: () => Navigator.of(context).pushReplacement(
                                PageTransition(
                                    child: ShareWishList(),
                                    type: PageTransitionType.bottomToTop)),
                            child: SvgPicture.asset(
                              'assets/images/email.svg',
                              height: 45,
                              width: 45,
                            )),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
