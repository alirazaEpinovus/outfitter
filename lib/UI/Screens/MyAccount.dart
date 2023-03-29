import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:outfitters/UI/GraphQL/Query/GraphQlQueries.dart';
import 'package:outfitters/UI/Screens/BottamNavigation.dart';
import 'package:outfitters/UI/Screens/ContactUs.dart';
import 'package:outfitters/UI/Screens/MyInformation.dart';
import 'package:outfitters/UI/Screens/Signin.dart';
import 'package:outfitters/UI/Widgets/CartIconWidget.dart';
import 'package:outfitters/UI/Widgets/LoadingAnimation.dart';
import 'package:outfitters/UI/Widgets/LoadingDialog.dart';
import 'package:outfitters/UI/Widgets/ToastClass.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/share.dart';
import 'dart:convert';
import 'MyOrders.dart';

class MyAccount extends StatefulWidget {
  final profileInformation;
  MyAccount({Key key, this.profileInformation}) : super(key: key);

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  SharedPreferences sharedPreferences;
  dynamic labels;

  loadValues() async {
    sharedPreferences = await SharedPreferences.getInstance();
    labels = json.decode(sharedPreferences.getString("labels"));

    setState(() {});
  }

  @override
  void initState() {
    loadValues();
    super.initState();
  }

  Future<String> accesTokenGet() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getString('accessToken').toString();
  }

  String accessToken;
  @override
  Widget build(BuildContext context) {
    return sharedPreferences == null
        ? Container()
        : Scaffold(
            body: Container(
                child: FutureBuilder<String>(
                    future: accesTokenGet(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Query(
                            options: QueryOptions(
                              document: gql(readProfileData),
                              // this is the query string you just created

                              variables: {
                                'customerAccessToken': snapshot.data,
                              },
                            ),
                            builder: (QueryResult result,
                                {VoidCallback refetch, FetchMore fetchMore}) {
                              if (result.hasException) {
                                return Text(result.exception.toString());
                              }

                              if (result.isLoading) {
                                return Container(
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                      child: LoadingAnimation(),
                                    ));
                              }

                              // if (result.data['customer'] == null) {
                              //   return Container(
                              //     height: MediaQuery.of(context).size.height,
                              //     child: Column(
                              //       children: <Widget>[
                              //         Image.asset(
                              //           "assets/account.png",
                              //           height: 70,
                              //           width: 70,
                              //         ),
                              //         Text('Empty Customer'),
                              //       ],
                              //     ),
                              //   );
                              // }

                              return Scaffold(
                                appBar: AppBar(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  centerTitle: true,
                                  automaticallyImplyLeading: false,
                                  elevation: 2,
                                  title: Column(
                                    children: <Widget>[
                                      Text(
                                        labels["my_account"],
                                        style: AppTheme.TextTheme.titlebold,
                                      ),
                                      Text(
                                        result.data['customer']['email'] == null
                                            ? ""
                                            : result.data['customer']['email'],
                                        style: AppTheme.TextTheme.smalltext,
                                      )
                                    ],
                                  ),
                                  actions: [CartIconWidget()],
                                ),
                                body: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(top: 20),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 14,
                                                  bottom: 14,
                                                  left: 10),
                                              child: InkWell(
                                                onTap: () async {
                                                  var sharedPreferences =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  String accessTokens =
                                                      sharedPreferences
                                                          .getString(
                                                              'accessToken')
                                                          .toString();
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              MyOrders(
                                                                idd:
                                                                    accessTokens,
                                                              ),
                                                          settings: RouteSettings(
                                                              name:
                                                                  'My Orders')));
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.08,
                                                        child: SvgPicture.asset(
                                                            'assets/images/orderplace.svg',
                                                            width: 18,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorLight)),
                                                    Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.89,
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5),
                                                        child: Column(
                                                          children: <Widget>[
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                InkWell(
                                                                    child: Text(
                                                                        labels[
                                                                            "orders_placed"],
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w700))),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              3),
                                                                  child: Icon(
                                                                    Icons
                                                                        .arrow_forward_ios,
                                                                    color: Colors
                                                                        .black45,
                                                                    size: 16,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 15),
                                                              child: Divider(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColorLight,
                                                                thickness: 0.3,
                                                                height: 10,
                                                              ),
                                                            )
                                                          ],
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            // InkWell(
                                            //   onTap: () => Navigator.of(context)
                                            //       .push(PageTransition(
                                            //           child: MyInformation(),
                                            //           type: PageTransitionType
                                            //               .leftToRight)),
                                            //   child: Container(
                                            //     padding: EdgeInsets.only(
                                            //         bottom: 10, left: 10),
                                            //     child: Row(
                                            //       mainAxisAlignment:
                                            //           MainAxisAlignment.start,
                                            //       crossAxisAlignment:
                                            //           CrossAxisAlignment.start,
                                            //       children: <Widget>[
                                            //         Container(
                                            //             width: MediaQuery.of(
                                            //                         context)
                                            //                     .size
                                            //                     .width *
                                            //                 0.08,
                                            //             child: SvgPicture.asset(
                                            //                 'assets/images/info.svg',
                                            //                 width: 18,
                                            //                 color: Theme.of(
                                            //                         context)
                                            //                     .primaryColorLight)),
                                            //         Container(
                                            //             width: MediaQuery.of(
                                            //                         context)
                                            //                     .size
                                            //                     .width *
                                            //                 0.89,
                                            //             padding:
                                            //                 EdgeInsets.only(
                                            //                     left: 5),
                                            //             child: Column(
                                            //               children: <Widget>[
                                            //                 Row(
                                            //                   mainAxisAlignment:
                                            //                       MainAxisAlignment
                                            //                           .spaceBetween,
                                            //                   crossAxisAlignment:
                                            //                       CrossAxisAlignment
                                            //                           .start,
                                            //                   children: <
                                            //                       Widget>[
                                            //                     Text(
                                            //                         labels[
                                            //                             "my_info"],
                                            //                         style: TextStyle(
                                            //                             fontSize:
                                            //                                 16,
                                            //                             fontWeight:
                                            //                                 FontWeight.w700)),
                                            //                     Padding(
                                            //                       padding: EdgeInsets.only(right: 3),
                                            //                                                                                       child: Icon(
                                            //                         Icons
                                            //                             .arrow_forward_ios,
                                            //                         color: Colors
                                            //                             .black45,
                                            //                         size: 16,
                                            //                       ),
                                            //                     ),
                                            //                   ],
                                            //                 ),
                                            //                 Padding(
                                            //                   padding: EdgeInsets
                                            //                       .only(
                                            //                           top: 15),
                                            //                   child: Divider(
                                            //                     color: Theme.of(
                                            //                             context)
                                            //                         .primaryColorLight,
                                            //                     height: 10,
                                            //                     thickness: 0.3,
                                            //                   ),
                                            //                 )
                                            //               ],
                                            //             ))
                                            //       ],
                                            //     ),
                                            //   ),
                                            // ),
                                            InkWell(
                                              onTap: () => Navigator.of(context)
                                                  .push(PageTransition(
                                                      child: ContactUs(),
                                                      type: PageTransitionType
                                                          .leftToRight)),
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 20, left: 10),
                                                child: InkWell(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                          child: SvgPicture.asset(
                                                              'assets/images/contact.svg',
                                                              width: 18,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColorLight)),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.89,
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Text(
                                                                labels[
                                                                    "contact"],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700)),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right: 3),
                                                              child: Icon(
                                                                Icons
                                                                    .arrow_forward_ios,
                                                                color: Colors
                                                                    .black45,
                                                                size: 16,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 20),
                                        width: double.infinity,
                                        height: 100,
                                        decoration: BoxDecoration(
                                            border: Border(
                                                top: BorderSide(width: 0.3),
                                                bottom:
                                                    BorderSide(width: 0.3))),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[100],
                                                  border: Border(
                                                      right: BorderSide(
                                                          width: 0.3))),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 4),
                                                      child: Text(
                                                          labels["rate_app"],
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500))),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      1),
                                                          child: Icon(
                                                            Icons.star,
                                                            color: Colors.grey,
                                                            size: 16,
                                                          )),
                                                      Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      1),
                                                          child: Icon(
                                                            Icons.star,
                                                            color: Colors.grey,
                                                            size: 16,
                                                          )),
                                                      Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      1),
                                                          child: Icon(
                                                            Icons.star,
                                                            color: Colors.grey,
                                                            size: 16,
                                                          )),
                                                      Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      1),
                                                          child: Icon(
                                                            Icons.star,
                                                            color: Colors.grey,
                                                            size: 16,
                                                          )),
                                                      Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      1),
                                                          child: Icon(
                                                            Icons.star,
                                                            color: Colors.grey,
                                                            size: 16,
                                                          )),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              color: Colors.grey[100],
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      final RenderBox box =
                                                          context
                                                              .findRenderObject();
                                                      Share.share(
                                                          "https://alchemativeecomapp.page.link/appinvite",
                                                          sharePositionOrigin:
                                                              box.localToGlobal(
                                                                      Offset
                                                                          .zero) &
                                                                  box.size);
                                                    },
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 4),
                                                        child: Text(
                                                            labels[
                                                                "recommend_app"],
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500))),
                                                  ),
                                                  Icon(
                                                    Feather.upload,
                                                    size: 16,
                                                    color: Colors.grey,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          _logout();
                                        },
                                        // Navigator.of(context).push(PageTransition(child: SignIn(), type: PageTransitionType.bottomToTop)),
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 15),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              border: Border(
                                                  top: BorderSide(
                                                      width: 0.5,
                                                      color: Colors.grey),
                                                  bottom: BorderSide(
                                                      width: 0.5,
                                                      color: Colors.grey))),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16),
                                          child: Center(
                                              child: Text(labels["logout"],
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      } else {
                        return Container();
                      }
                    })));
  }

  _logout() async {
    setState(() {});
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isLogin", false);
    sharedPreferences.setString("accesToken", '');
    sharedPreferences.setString("expireAt", '');
    Toast.showToast(context, 'Logging out...');
    LoadingDialouge().showLoadingDialog(context, 'Logged out... Wait');

    Navigator.of(context).pushReplacement(PageTransition(
      child: SignIn(
        checkoutitems: [],
        ischeckout: false,
      ),
      type: PageTransitionType.leftToRight,
    ));
  }
}
