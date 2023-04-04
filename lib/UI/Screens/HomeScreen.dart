import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_widget/res/expandable_widget.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:outfitters/UI/Notifiers/ConnectionNotifier.dart';
import 'package:outfitters/UI/Notifiers/HomeScreenNotifier.dart';
import 'package:outfitters/UI/Screens/BuyingGuide.dart';
import 'package:outfitters/UI/Screens/Collections.dart';
import 'package:outfitters/UI/Screens/ContactUs.dart';
import 'package:outfitters/UI/Screens/NewsLetter.dart';
import 'package:outfitters/UI/Screens/AboutOutfitters.dart';
import 'package:outfitters/UI/Screens/SearchProduct.dart';
import 'package:outfitters/UI/Widgets/CartIconWidget.dart';
import 'package:outfitters/UI/Widgets/ToastClass.dart';
import 'package:outfitters/UI/Widgets/VideoPlayer.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:translator/translator.dart';
import 'package:package_info/package_info.dart';
import 'dart:async';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  // final FirebaseAnalytics analytics;
  // final FirebaseAnalyticsObserver observer;

  // HomeScreen({this.analytics, this.observer});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.shopify,
    this.len,
    this.isExpanded = false,
  });

  var expandedValue;
  String headerValue;
  int len;
  String shopify;
  bool isExpanded;
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  ScrollController con;
  final translator = new GoogleTranslator();
  var scroll = new ScrollController();
  int activIndex = 0;
  bool show = false;
  String out;
  String versionCode;
  SharedPreferences sharedPreferences;
  dynamic labels;
  int _activeMeterIndex;
  int selectedValue = -1;
  int lastVer;
  int selectedValue2 = -1;
  bool selectedV = false;
  List sliders = [];
  List collections = [];
  final dataKey1 = new GlobalKey();
  final dataKey2 = new GlobalKey();
  final dataKey3 = new GlobalKey();

  // Future<Null> _currentScreen() async {
  //   await widget.analytics.setCurrentScreen(
  //       screenName: 'Home Screen', screenClassOverride: 'HomeScreen');
  // }

  // Future<Null> _collectionListAnalytics() async {
  //   await widget.analytics
  //       .logEvent(name: 'slider_tapped', parameters: <String, dynamic>{});
  // }

  // Future<Null> _sliderAnalytics() async {
  //   await widget.analytics.logEvent(
  //       name: 'Collection_list_tapped', parameters: <String, dynamic>{});
  // }

  bool expandx = false;
  bool expand = false;
  var connectionStatus;

  @override
  void initState() {
    // _currentScreen();
    con = ScrollController();
    con.addListener(() {
      if (con.offset >= con.position.maxScrollExtent &&
          !con.position.outOfRange) {
        setState(() {});
      } else if (con.offset <= con.position.minScrollExtent &&
          !con.position.outOfRange) {
        setState(() {});
      } else {
        setState(() {});
      }
    });
    loadValues();
    versionCheck();

    super.initState();
  }

  void versionCheck() async {
    FirebaseFirestore.instance
        .collection("build_number")
        .doc("build")
        .snapshots()
        .listen((value) async {
      debugPrint('value: ${value}');
      lastVer =
          Platform.isIOS ? int.parse(value['ios']) : value['build_number'];

      if (mounted) {
        setState(() {});
      }

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      // int versionName = int.parse(packageInfo.version.toString());
      versionCode = packageInfo.buildNumber;
      log(lastVer.toString() +
          "------------------vvvvvvvvvvvvvv-------" +
          versionCode.toString());
      if (lastVer < int.parse(versionCode)) {
        _launchURL();
        // FirebaseFirestore.instance
        //     .collection("build_number")
        //     .doc("build")
        //     .update(Platform.isIOS
        //         ? {
        //             'ios': int.parse(versionCode),
        //           }
        //         : {
        //             'build_number': int.parse(versionCode),
        //           });
        // showDialog(
        //     barrierDismissible: false,
        //     context: context,
        //     builder: (_) => new AlertDialog(
        //           title: Text(
        //             "New Update Available",
        //             style: TextStyle(
        //               fontFamily: 'Lato',
        //             ),
        //           ),
        //           content: Text(
        //             "There is a newer version of app available please update it now.",
        //             style: TextStyle(
        //               fontFamily: 'Lato',
        //             ),
        //           ),
        //           actions: <Widget>[
        //             TextButton(
        //               child: Text(
        //                 "Update Now",
        //                 style: TextStyle(
        //                   fontFamily: 'Lato',
        //                 ),
        //               ),
        //               onPressed: () {
        //                 _launchURL();
        //               },
        //             ),
        //           ],
        //         ));
      }
    });
  }

  // check1stTime() async {
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   if (sharedPreferences.getBool("is1stTime") == null) {
  //     PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //     String versionCode = packageInfo.buildNumber;
  //     print("1sttime");
  //     sharedPreferences.setBool("is1stTime", true);
  //     sharedPreferences.setInt("version", int.parse(versionCode));
  //   } else {
  //     lastVer = sharedPreferences.getInt("version");
  //     print(lastVer);
  //     versionCheck();
  //   }
  // }

  // void versionCheck() async {
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   String versionName = packageInfo.version;
  //   versionCode = packageInfo.buildNumber;
  //   print(versionName + "            " + versionCode);
  //   if (lastVer < int.parse(versionCode) && !Platform.isIOS) {
  //     showDialog(
  //         context: context,
  //         builder: (_) => new AlertDialog(
  //               title: Text("New Update Available"),
  //               content: Text(
  //                   "There is a newer version of app available please update it now."),
  //               actions: <Widget>[
  //                 TextButton(
  //                   child: Text("Update Now"),
  //                   onPressed: () {
  //                     _launchURL();
  //                     sharedPreferences.setInt(
  //                         "version", int.parse(versionCode));
  //                   },
  //                 ),
  //               ],
  //             ));
  //   }
  // }

  _launchURL() async {
    String url = Platform.isIOS
        ? "https://apps.apple.com/us/app/outfitters-pakistan/id1523461712"
        : "https://play.google.com/store/apps/details?id=com.alchemative.outfitters.pk";

    if (await canLaunch(url)) {
      await launch(url);
      Navigator.of(context, rootNavigator: false).pop('dialog');
    } else {
      throw 'Could not launch $url';
    }
  }

  loadValues() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("volume", true);
    labels = json.decode(sharedPreferences.getString("labels"));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    connectionStatus = Provider.of<ConnectivityStatus>(context);
    return sharedPreferences == null
        ? Container()
        : StatefulBuilder(
            builder: (BuildContext context, setState) => Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  centerTitle: true,
                  title: InkWell(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //         FirebaseMessagingData()));
                    },
                    child: SvgPicture.asset(
                      'assets/images/logo.svg',
                      height: 35,
                      width: 130,
                    ),
                  ),
                  leading: InkWell(
                      onTap: () => Navigator.of(context).push(PageTransition(
                          child: SearchProducts(),
                          type: PageTransitionType.fade,
                          settings: RouteSettings(name: 'Search Products'))),
                      child: Icon(
                        Feather.search,
                        size: 20,
                      )),
                  actions: <Widget>[Container(child: CartIconWidget())],
                ),
                body: Consumer(builder: (BuildContext context,
                    HomeScreenNotifier homeScreenNotifier, _) {
                  if (homeScreenNotifier.dataSnapshot == null &&
                      connectionStatus != ConnectivityStatus.Offline) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (connectionStatus == ConnectivityStatus.Offline &&
                      homeScreenNotifier.dataSnapshot == null) {
                    return internetError(homeScreenNotifier);
                  }
                  sliders.clear();
                  for (var i = 0;
                      i < homeScreenNotifier.slidersData.length;
                      i++) {
                    sliders.add({
                      "data": homeScreenNotifier.slidersData[i],
                      "sid":
                          int.parse(homeScreenNotifier.slidersData[i].sortOrder)
                    });

                    sliders.sort((a, b) => a['sid'].compareTo(b['sid']));
                  }
                  collections.clear();
                  for (var i = 0;
                      i < homeScreenNotifier.collections.length;
                      i++) {
                    collections.add({
                      "data": homeScreenNotifier.collections[i],
                      "sid":
                          int.parse(homeScreenNotifier.collections[i].sortOrder)
                    });

                    collections.sort((a, b) => a['sid'].compareTo(b['sid']));
                  }

                  return Stack(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    top: homeScreenNotifier.ann.isAnnounce
                                        ? 40
                                        : 2),
                                height: 500,
                                child: Stack(
                                  children: [
                                    Swiper(
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () {
                                            if (sliders[index]['data']
                                                        .qraphQl !=
                                                    "" ||
                                                sliders[index]['data']
                                                        .qraphQl !=
                                                    null) {
                                              // _sliderAnalytics();
                                              Navigator.of(context,
                                                      rootNavigator: false)
                                                  .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          Collections(
                                                            sorting: sliders[
                                                                        index]
                                                                    ['data']
                                                                .sortingValue,
                                                            selected: "MEN",
                                                            subColList:
                                                                homeScreenNotifier
                                                                    .collections,
                                                            shopifyId:
                                                                sliders[index]
                                                                        ['data']
                                                                    .qraphQl,
                                                            name: sliders[index]
                                                                    ['data']
                                                                .name,
                                                            filterx:
                                                                homeScreenNotifier
                                                                    .filtersModel,
                                                            isFilters: true,
                                                            imgx: sliders[index]
                                                                    ['data']
                                                                .customTags,
                                                          )));
                                            }
                                          },
                                          child: sliders[index]['data'].isVideo
                                              ? VideoPlayerScreen(
                                                  videoUrl: sliders[index]
                                                          ['data']
                                                      .bannerVideo,
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl: sliders[index]
                                                          ['data']
                                                      .bannerImage,
                                                  fit: BoxFit.cover,
                                                ),
                                        );
                                      },
                                      autoplay: true,
                                      autoplayDelay: 10000,
                                      itemCount: sliders.length,
                                      onIndexChanged: (val) {
                                        activIndex = val;
                                        this.setState(() {});
                                      },
                                    ),
                                    Align(
                                      alignment: FractionalOffset.bottomCenter,
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 15),
                                        child: AnimatedSmoothIndicator(
                                          activeIndex: activIndex,
                                          count: sliders.length,
                                          effect: ExpandingDotsEffect(
                                            expansionFactor: 2,
                                            dotWidth: 20,
                                            activeDotColor: Colors.white,
                                            dotHeight: 4,
                                            dotColor: Colors.grey[200],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              ListView.builder(
                                  itemCount: collections.length,
                                  shrinkWrap: true,
                                  controller: con,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Column(
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            // FirebaseAnalytics().logEvent(
                                            //     name: 'Collection Analytics',
                                            //     parameters: null);
                                            if (index == 0) {
                                              Scrollable.ensureVisible(
                                                  dataKey1.currentContext);
                                            } else if (index == 1) {
                                              Scrollable.ensureVisible(
                                                  dataKey2.currentContext);
                                            } else {
                                              Scrollable.ensureVisible(
                                                  dataKey3.currentContext);
                                            }
                                            if (_activeMeterIndex == null ||
                                                _activeMeterIndex != index) {
                                              setState(() =>
                                                  _activeMeterIndex = index);
                                            } else {
                                              setState(() =>
                                                  _activeMeterIndex = null);
                                            }
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.6,
                                            // 480 / 300= 1.6
                                            child: Stack(
                                              children: <Widget>[
                                                Container(
                                                    key: index == 0
                                                        ? dataKey1
                                                        : index == 1
                                                            ? dataKey2
                                                            : dataKey3,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          collections[index]
                                                                  ['data']
                                                              .image,
                                                      fit: BoxFit.fill,
                                                    )),
                                                Center(
                                                  child: Text(
                                                    collections[index]['data']
                                                        .name,
                                                    style: TextStyle(
                                                        color: collections[index]['data']
                                                                        .menuColor ==
                                                                    null ||
                                                                collections[index]['data']
                                                                        .menuColor ==
                                                                    ""
                                                            ? Theme.of(context)
                                                                .primaryColor
                                                            : Color(int.parse(
                                                                collections[index]
                                                                        ['data']
                                                                    .menuColor
                                                                    .split(
                                                                        "(")[1]
                                                                    .replaceAll(
                                                                        ")", ""))),
                                                        fontSize: 30,
                                                        fontWeight: FontWeight.w800),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        ExpandableWidget.manual(
                                            expand: index ==
                                                        _activeMeterIndex &&
                                                    _activeMeterIndex != null
                                                ? true
                                                : false,
                                            animationDuration:
                                                Duration(milliseconds: 500),
                                            vsync: this,
                                            child: ListView(
                                              shrinkWrap: true,
                                              controller: con,
                                              children: [
                                                _buildPanel(
                                                    index,
                                                    homeScreenNotifier
                                                        .filtersModel,
                                                    homeScreenNotifier
                                                        .collections,
                                                    collections[index]['data']
                                                        .subCollection)
                                              ],
                                            ))
                                      ],
                                    );
                                  }),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 25, left: 10, right: 10),
                                child: Column(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () => Navigator.of(context).push(
                                        PageTransition(
                                            child: NewsLetter(),
                                            type:
                                                PageTransitionType.bottomToTop,
                                            settings: RouteSettings(
                                                name: 'NewsLetter')),
                                      ),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 15),
                                        child: Text(
                                          labels["newsletter"],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.of(context).push(
                                          PageTransition(
                                              child: ContactUs(),
                                              type: PageTransitionType
                                                  .bottomToTop,
                                              settings: RouteSettings(
                                                  name: 'ContactUs'))),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                                    color: Colors.grey[500],
                                                    width: 0.5))),
                                        margin: EdgeInsets.only(top: 10),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 20),
                                        child: Text(labels["need_help"] + "?",
                                            textAlign: TextAlign.center),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.of(context).push(
                                          PageTransition(
                                              child: BuyingGuide(),
                                              type: PageTransitionType
                                                  .bottomToTop,
                                              settings: RouteSettings(
                                                  name: 'Buyinguide'))),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                                    color: Colors.grey[500],
                                                    width: 0.5))),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 20),
                                        child: Text(labels["buying_guide"],
                                            textAlign: TextAlign.center),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    show = !show;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "About Outfitters",
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              !show
                                  ? Container()
                                  : Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(bottom: 15),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AboutOutfitters(
                                                              name: "About Us",
                                                              url:
                                                                  "https://outfitters.com.pk/pages/about-us-mobile-app"),
                                                      settings: RouteSettings(
                                                          name:
                                                              'AboutOutfitters')));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              child: Text(
                                                "About Us",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0.2),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AboutOutfitters(
                                                              name: "Stores",
                                                              url:
                                                                  "https://outfitters.com.pk/pages/find-a-store-mobile-app"),
                                                      settings: RouteSettings(
                                                          name:
                                                              'AboutOutfitters')));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              child: Text(
                                                "Stores",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0.2),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AboutOutfitters(
                                                              name:
                                                                  "Contact Us",
                                                              url:
                                                                  "https://outfitters.com.pk/pages/contact-us-mobile-app"),
                                                      settings: RouteSettings(
                                                          name:
                                                              'AboutOutfitters')));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              child: Text(
                                                "Contact Us",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0.2),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AboutOutfitters(
                                                              name:
                                                                  "Track Your Order",
                                                              url:
                                                                  "https://outfitters.com.pk/pages/track-your-order-mobile-app"),
                                                      settings: RouteSettings(
                                                          name:
                                                              'AboutOutfitters')));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              child: Text(
                                                "Track Your Order",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0.2),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AboutOutfitters(
                                                              name:
                                                                  "Customer Feedback/Complaint form",
                                                              url:
                                                                  "https://outfitters.com.pk/pages/complaint-form-mobile-app"),
                                                      settings: RouteSettings(
                                                          name:
                                                              'AboutOutfitters')));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              child: Text(
                                                "Customer Feedback/Complaint form",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0.2),
                                              ),
                                            ),
                                          ),
                                          // InkWell(
                                          //   onTap: () {
                                          //     Navigator.push(
                                          //         context,
                                          //         MaterialPageRoute(
                                          //             builder: (context) =>
                                          //                 AboutOutfitters(
                                          //                     name: "News",
                                          //                     url:
                                          //                         "https://outfitters.com.pk/pages/complaint-form-mobile-app"),
                                          //             settings: RouteSettings(
                                          //                 name:
                                          //                     'AboutOutfitters')));
                                          //   },
                                          //   child: Container(
                                          //     padding: EdgeInsets.all(8),
                                          //     child: Text(
                                          //       "News",
                                          //       style: TextStyle(
                                          //           fontWeight: FontWeight.w400,
                                          //           letterSpacing: 0.2),
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AboutOutfitters(
                                              name: "Returns & Exchange",
                                              url:
                                                  "https://outfitters.com.pk/pages/returns-exchange-mobile-app"),
                                          settings: RouteSettings(
                                              name: 'AboutOutfitters')));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    labels["return_exchange"],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.2),
                                  ),
                                ),
                              ),
                              InkWell(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(vertical: 30),
                                  child: Text(
                                    'v0.0.1',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: homeScreenNotifier.ann.isAnnounce
                            ? Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width,
                                color: Theme.of(context).primaryColorLight,
                                // padding: EdgeInsets.symmetric(
                                //     horizontal: 10, vertical: 10),
                                child: Marquee(
                                    text: homeScreenNotifier.ann.annouce
                                        .toString(),
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12)),
                              )
                            : Container(),
                      ),
                    ],
                  );
                })),
          );
  }

  Widget _buildPanel(indexi, filters, col, data) {
    List subCol = [];
    subCol.clear();
    for (var i = 0; i < data.length; i++) {
      subCol.add({"data": data[i], "sid": int.parse(data[i].sortOrder)});
      subCol.sort((a, b) => a['sid'].compareTo(b['sid']));
    }
    return FutureBuilder(
        future: Future.delayed(new Duration(seconds: 5)),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else
            return Theme(
              data: Theme.of(context).copyWith(
                  accentColor: Theme.of(context).primaryColorLight,
                  dividerColor: Colors.transparent),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: subCol.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, ind) {
                        return Container(
                            child: subCol[ind]['data']
                                        .nestedSubCollection
                                        .length ==
                                    0
                                ? InkWell(
                                    onTap: () {
                                      Navigator.of(context,
                                              rootNavigator: false)
                                          .push(MaterialPageRoute(
                                        maintainState: true,
                                        builder: (context) => Collections(
                                          selected: col[indexi]
                                              .name
                                              .toString()
                                              .toUpperCase(),
                                          subColList: col,
                                          sorting:
                                              subCol[ind]['data'].sortingValue,
                                          shopifyId:
                                              subCol[ind]['data'].shopifyId,
                                          name: subCol[ind]['data'].name,
                                          filterx: filters,
                                          isFilters: true,
                                          imgx: subCol[ind]['data']
                                                      .customTags ==
                                                  null
                                              ? []
                                              : subCol[ind]['data'].customTags,
                                        ),
                                      ));
                                    },
                                    child: Container(
                                      child: ListTile(
                                        title: Text(
                                          subCol[ind]['data']
                                              .name
                                              .toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: subCol[ind]['data']
                                                            .menuColor ==
                                                        null ||
                                                    subCol[ind]['data']
                                                            .menuColor ==
                                                        ""
                                                ? Colors.black
                                                : Color(int.parse(subCol[ind]
                                                        ['data']
                                                    .menuColor
                                                    .split("(")[1]
                                                    .replaceAll(")", ""))),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          if (selectedValue == ind) {
                                            selectedValue = -1;
                                          } else {
                                            selectedValue = ind;
                                          }
                                          setState(() {});
                                        },
                                        title: Text(
                                          subCol[ind]['data']
                                                      .name
                                                      .toUpperCase() ==
                                                  "SALE"
                                              ? subCol[ind]['data']
                                                  .name
                                                  .toUpperCase()
                                              : subCol[ind]['data'].name,
                                          style: TextStyle(
                                              color: subCol[ind]['data']
                                                              .menuColor ==
                                                          null ||
                                                      subCol[ind]['data']
                                                              .menuColor ==
                                                          ""
                                                  ? Colors.black
                                                  : Color(int.parse(subCol[ind]
                                                          ['data']
                                                      .menuColor
                                                      .split("(")[1]
                                                      .replaceAll(")", ""))),
                                              fontWeight: FontWeight.w400),
                                        ),
                                        trailing: Icon(Icons.arrow_drop_down),
                                      ),
                                      ind == selectedValue
                                          ? nested(ind, subCol[ind]['data'],
                                              filters, col[indexi].name, col)
                                          : Container()
                                    ],
                                  ));
                      }),
                ],
              ),
            );
        });
  }

  Widget nested(i, subCol, filters, selectedCol, col) {
    List nesCol = [];
    for (var i = 0; i < subCol.nestedSubCollection.length; i++) {
      nesCol.add({
        "data": subCol.nestedSubCollection[i],
        "sid": int.parse(subCol.nestedSubCollection[i].sortOrder)
      });
      nesCol.sort((a, b) => a['sid'].compareTo(b['sid']));
    }
    return Container(
      child: ListView.builder(
          itemCount: nesCol.length,
          shrinkWrap: true,
          controller: con,
          itemBuilder: (BuildContext context, int index) {
            return nesCol[index]['data'].nestedSubCollection2.length == 0
                ? ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    dense: false,
                    onTap: () {
                      Navigator.of(context, rootNavigator: false).push(
                          MaterialPageRoute(
                              maintainState: true,
                              builder: (context) => Collections(
                                  selected:
                                      selectedCol.toString().toUpperCase(),
                                  subColList: col,
                                  sorting: nesCol[index]['data'].sortingValue,
                                  shopifyId: nesCol[index]['data'].shopifyId,
                                  name: nesCol[index]['data'].name,
                                  filterx: filters,
                                  isFilters: true,
                                  imgx: nesCol[index]['data'].customTags),
                              settings: RouteSettings(
                                  name: 'Nested Collection Screen')));
                    },
                    title: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        nesCol[index]['data'].name.toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  )
                : nestedSubCol(
                    index, filters, nesCol[index]['data'], selectedCol, col);
          }),
    );
  }

  Widget nestedSubCol(index, filters, nesCol, selectedCol, col) {
    List nesSubCol = [];
    for (var i = 0; i < nesCol.nestedSubCollection2.length; i++) {
      nesSubCol.add({
        "data": nesCol.nestedSubCollection2[i],
        "sid": int.parse(nesCol.nestedSubCollection2[i].sortOrder)
      });
      nesSubCol.sort((a, b) => a['sid'].compareTo(b['sid']));
    }
    return Column(
      children: [
        ListTile(
          onTap: () {
            if (selectedValue2 == index) {
              selectedValue2 = -1;
            } else {
              selectedValue2 = index;
            }
            setState(() {});
          },
          title: Text(
            nesCol.name,
            style: TextStyle(color: Colors.black),
          ),
          trailing: Icon(Icons.arrow_drop_down),
        ),
        selectedValue2 != index
            ? Container()
            : ListView.builder(
                itemCount: nesSubCol.length,
                shrinkWrap: true,
                controller: con,
                itemBuilder: (BuildContext context, int inds) {
                  return ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    dense: false,
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => Collections(
                                sorting: nesSubCol[inds]['data'].sortingValue,
                                selected: selectedCol.toString().toUpperCase(),
                                subColList: col,
                                shopifyId: nesSubCol[inds]['data'].shopifyId,
                                name: nesSubCol[inds]['data'].name,
                                filterx: filters,
                                isFilters: true,
                                imgx: nesSubCol[inds]['data'].customTags,
                              ),
                          settings:
                              RouteSettings(name: 'Nested Collection Screen')));
                    },
                    title: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        nesSubCol[inds]['data'].name.toString(),
                        style: TextStyle(
                            color: nesSubCol[inds]['data'].name.toString() ==
                                    "Women's day"
                                ? Colors.pink
                                : Colors.black),
                      ),
                    ),
                  );
                }),
      ],
    );
  }

  Widget internetError(HomeScreenNotifier homeScreenNotifier) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SvgPicture.asset('assets/images/connection.svg'),
        Text(
          'No Connection',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text('Slow or not internet connection.')),
        Text('Please check your internet settings.'),
        Align(
          alignment: FractionalOffset.center,
          child: InkWell(
            onTap: () {
              if (connectionStatus != ConnectivityStatus.Offline) {
                homeScreenNotifier.getDatabase();
              } else {
                Toast.showToast(context, 'No internet available');
              }
            },
            child: Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.symmetric(vertical: 11, horizontal: 25),
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Try Again',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ),
        )
      ],
    );
  }
}
