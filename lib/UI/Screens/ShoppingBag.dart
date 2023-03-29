import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:outfitters/Database/DatabaseHelper.dart';
import 'package:outfitters/Models/CartModel.dart';
import 'package:outfitters/UI/GraphQL/Mutation/mutationQueries.dart';
import 'package:outfitters/UI/Notifiers/CartNotifier.dart';
import 'package:outfitters/UI/Screens/Signin.dart';
import 'package:outfitters/UI/Screens/WebViewCheckouts.dart';
import 'package:outfitters/UI/Widgets/AlertDialoug.dart';
import 'package:outfitters/UI/Widgets/CartWidget.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingBag extends StatefulWidget {
  @override
  _ShoppingBagState createState() => _ShoppingBagState();
}

class _ShoppingBagState extends State<ShoppingBag>
    with SingleTickerProviderStateMixin {
  double screenheight, screenwidth;
  Size size;
  final GlobalKey<AnimatedListState> _list = GlobalKey();
  List<CartModel> cartmodelList = [];
  final database = DatabaseHelper.instance;
  StreamController<List<CartModel>> cartstream =
      StreamController<List<CartModel>>.broadcast();
  StreamController<bool> isedit = StreamController<bool>.broadcast();
  bool edit = false;
  SharedPreferences sharedPreferences;
  StreamController<bool> _isempty = new StreamController<bool>.broadcast();
  AnimationController controller;
  Animation<Offset> offset;

  @override
  void initState() {
    isedit.add(false);
    _isempty.add(false);
    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);

    offset = Tween<Offset>(begin: Offset(0, 0.5), end: Offset(0.0, 0.0))
        .animate(controller);
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    screenheight = size.height;
    screenwidth = size.width;
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          leading: InkWell(
              onTap: () => Navigator.pop(context, true),
              child: Icon(Icons.close)),
          centerTitle: true,
          elevation: 1,
          title: Text(
            'Shopping Bag',
            style: AppTheme.TextTheme.titlebold,
          ),
          actions: <Widget>[
            StreamBuilder<bool>(
                stream: _isempty.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && !snapshot.data) {
                    return Consumer(builder:
                        (BuildContext context, CartNotifier cartnotifier, _) {
                      return InkWell(
                        onTap: () {
                          setState(() {});
                          edit = !edit;
                          Provider.of<CartNotifier>(context, listen: false)
                              .isclickEdit(edit);
                        },
                        child: Center(
                            child: Padding(
                                padding: EdgeInsets.only(right: 13, left: 15),
                                child: InkWell(
                                    child: Provider.of<CartNotifier>(context,
                                                listen: false)
                                            .iseditcart
                                        ? Text('OK')
                                        : Text('Edit')))),
                      );
                    });
                  } else {
                    return Container();
                  }
                })
          ],
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            // height: screenheight,
            child: FutureBuilder<List<CartModel>>(
                future: database.queryAllRows(),
                builder: (context, snapshot) {
                  if (ConnectionState.done == snapshot.connectionState) {
                    if (snapshot.data.length > 0) {
                      _isempty.sink.add(false);
                      cartmodelList.clear();
                      cartmodelList.addAll(snapshot.data);

                      controller.forward();

                      return Stack(
                        // verticalDirection: VerticalDirection.down,
                        children: <Widget>[
                          SingleChildScrollView(
                            // height: screenheight * 0.735,
                            physics: BouncingScrollPhysics(),
                            child: Container(
                              height: MediaQuery.of(context).size.height - 210,
                              margin: EdgeInsets.only(top: 10, bottom: 210),
                              child: AnimatedList(
                                  initialItemCount: snapshot.data.length,
                                  shrinkWrap: true,
                                  key: _list,
                                  itemBuilder: (BuildContext context, int index,
                                      Animation<double> anim) {
                                    cartstream.add(snapshot.data);
                                    return CartWidget(
                                      cartModel: snapshot.data[index],
                                      animation: anim,
                                      removeCartItem: removeSingleItem,
                                      minusItem: minusitem,
                                      addItem: additem,
                                    );
                                  }),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              height: 120,
                              width: MediaQuery.of(context).size.width,
                              // padding: EdgeInsets.symmetric(
                              //     vertical: 2, horizontal: 20),
                              child: Column(
                                children: [
                                  Divider(
                                    color: Colors.grey.shade900,
                                    height: 0,
                                  ),
                                  Expanded(
                                    child: Container(
                                      color: Colors.grey[200],
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            StreamBuilder<List<CartModel>>(
                                                stream: cartstream.stream,
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    return Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                              '${totalQuantity(snapshot.data)} Item'),
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
                                            Container(
                                              padding: EdgeInsets.only(top: 5),
                                              child: Text('(Before Taxes)',
                                                  style: TextStyle(
                                                      color: Colors.grey)),
                                            ),
                                            Mutation(
                                                options: MutationOptions(
                                                    document: gql(
                                                        checkoutmutationwithemail),
                                                    onError: (OperationException
                                                        error) {
                                                      Navigator.of(context)
                                                          .pop();
                                                      AlertDialoug();
                                                    },
                                                    // or do something with the result.data on completion
                                                    onCompleted:
                                                        (dynamic resultData) {
                                                      Navigator.of(context)
                                                          .pop();
                                                      if (resultData['checkoutCreate']
                                                                  ['checkout']
                                                              ['webUrl'] !=
                                                          null) {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .push(
                                                                MaterialPageRoute(
                                                                    builder: (BuildContext
                                                                            context) =>
                                                                        WebViewCheckouts(
                                                                          weburl:
                                                                              resultData['checkoutCreate']['checkout']['webUrl'],
                                                                        )));
                                                      }
                                                    }),
                                                builder:
                                                    (RunMutation runMutation,
                                                        QueryResult result) {
                                                  return InkWell(
                                                    onTap: () async {
                                                      sharedPreferences =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      bool isLogin =
                                                          sharedPreferences.getBool(
                                                                      'isLogin') ==
                                                                  null
                                                              ? false
                                                              : sharedPreferences
                                                                  .getBool(
                                                                      'isLogin');
                                                      if (isLogin) {
                                                        runMutation(<String,
                                                            dynamic>{
                                                          "Checkoutitems":
                                                              _checkout(
                                                                  cartmodelList),
                                                          "email":
                                                              sharedPreferences
                                                                  .getString(
                                                                      'email')
                                                        });
                                                      } else {
                                                        runMutation(<String,
                                                            dynamic>{
                                                          "Checkoutitems":
                                                              _checkout(
                                                                  cartmodelList),
                                                        });
                                                        // Navigator.of(context).push(
                                                        //     PageTransition(
                                                        //         child: SignIn(
                                                        //           checkoutitems:
                                                        //               _checkout(
                                                        //                   cartmodelList),
                                                        //           ischeckout:
                                                        //               true,
                                                        //         ),
                                                        //         type: PageTransitionType
                                                        //             .bottomToTop));
                                                      }
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 12),
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10),
                                                      decoration: BoxDecoration(
                                                        color: Colors.black,
                                                      ),
                                                      child: Center(
                                                          child: Text('Next',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ))),
                                                    ),
                                                  );
                                                })
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      _isempty.sink.add(true);
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: SvgPicture.asset(
                                'assets/images/emptybag.svg',
                                height: 30,
                                width: 30,
                              )),
                          Text('Shopping bag is empty'),
                        ],
                      );
                    }
                  } else {
                    return Container(
                        height: screenheight * 0.68,
                        child: Center(child: CircularProgressIndicator()));
                  }
                })),
      ),
    );
  }

  removeSingleItem(CartModel cartModel) {
    int removeIndex = cartmodelList.indexOf(cartModel);

    cartstream.sink.add(cartmodelList);
    CartModel item = cartmodelList.removeAt(removeIndex);

    _list.currentState.removeItem(
        removeIndex,
        (_, animation) => CartWidget(
              cartModel: item,
              animation: animation,
              removeCartItem: removeSingleItem,
              minusItem: minusitem,
              addItem: additem,
            ),
        duration: const Duration(milliseconds: 500));

    if (cartmodelList.isEmpty) {
      setState(() {
        _isempty.add(false);
      });
    } else {
      setState(() {});
    }
  }

  int totalPrice(List<CartModel> w) {
    int total = 0;
    w.forEach((data) {
      total += data.quantity * data.price;
    });
    return total;
  }

  int totalQuantity(List<CartModel> w) {
    int total = 0;
    w.forEach((data) {
      total += data.quantity;
    });
    return total;
  }

  minusitem(CartModel cartModel) {
    int indexis = cartmodelList.indexOf(cartModel);
    cartmodelList[indexis].quantity = cartmodelList[indexis].quantity - 1;
    cartstream.add(cartmodelList);
  }

  additem(CartModel cartModel) {
    int indexis = cartmodelList.indexOf(cartModel);
    cartmodelList[indexis].quantity = cartmodelList[indexis].quantity + 1;
    cartstream.add(cartmodelList);
  }

  List<Map<String, dynamic>> _checkout(List<CartModel> checkItemlist) {
    var listOfMaps = List<Map<String, dynamic>>();
    checkItemlist.forEach((data) {
      listOfMaps.add({'variantId': data.varientId, 'quantity': data.quantity});
    });
    return listOfMaps;
  }
}
