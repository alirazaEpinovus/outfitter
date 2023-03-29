import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:outfitters/UI/Notifiers/WishNotifer.dart';
import 'package:outfitters/UI/Screens/HomeScreen.dart';
import 'package:outfitters/UI/Screens/MyAccount.dart';
import 'package:outfitters/UI/Screens/ScanAndShop.dart';
import 'package:outfitters/UI/Screens/Signin.dart';
import 'package:outfitters/UI/Screens/Stores.dart';
import 'package:outfitters/UI/Screens/Wishlist.dart';
import 'package:outfitters/UI/Widgets/WishCountIcon.dart';
import 'package:outfitters/UI/Widgets/custom_alert.dart';
import 'package:outfitters/Utils/Constant.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/DatabaseHelper.dart';

// class BottamNavigation extends StatefulWidget {
//   // final FirebaseAnalytics analytics;
//   // final FirebaseAnalyticsObserver observer;
//   // BottamNavigation({
//   //   // this.analytics, this.observer
//   // });
//   @override
//   _BottamNavigationState createState() => _BottamNavigationState();
// }

// class _BottamNavigationState extends State<BottamNavigation> {
//   PageController _pageController;
//   int _page = 0;
//   final databaseHelper = DatabaseHelper.instance;
//   SharedPreferences sharedPreferences;
//   String accessToken;
//   DateTime now = DateTime.now();
//   bool isLogin;
//   Future<void> checkexpireTokenDate() async {
//     sharedPreferences = await SharedPreferences.getInstance();
//     isLogin = sharedPreferences.getBool('isLogin');
//   }

//   // Future<Null> _currentScreen() async {
//   //   await widget.analytics.setCurrentScreen(
//   //       screenName: 'Wall Screen', screenClassOverride: 'WallScreen');
//   // }

//   // Future<Null> _sendAnalytics() async {
//   //   await widget.analytics
//   //       .logEvent(name: 'full_screen_tapped', parameters: <String, dynamic>{});
//   // }

//   @override
//   void initState() {
//     super.initState();
//     setState(() {});
//     checkexpireTokenDate();
//     _pageController = PageController(initialPage: 0);
//   }

//   @override
//   Widget build(BuildContext context) {
//     try {
//       isLogin = sharedPreferences.getBool('isLogin') == null
//           ? false
//           : sharedPreferences.getBool('isLogin');
//     } catch (Exception) {}

//     return WillPopScope(
//       onWillPop: () {
//         if (_pageController.page == 0) {
//           exitDialog(context);
//         } else if (_pageController.page == 1) {
//           setState(() {});

//           navigationTapped(0);
//         } else if (_pageController.page == 2) {
//           navigationTapped(1);
//         } else if (_pageController.page == 3) {
//           navigationTapped(2);
//         } else if (_pageController.page == 4) {
//           navigationTapped(3);
//         }
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: PageView(
//           physics: NeverScrollableScrollPhysics(),
//           controller: _pageController,
//           onPageChanged: onPageChanged,
//           children: <Widget>[
//             HomeScreen(),
//             Wishlist(),
//             ScanAndShop(),
//             StoresLocators(),
//             (isLogin != null && isLogin)
//                 ? MyAccount()
//                 : SignIn(
//                     ischeckout: false,
//                   ),
//           ],
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           backgroundColor: Theme.of(context).primaryColor,
//           elevation: 20,
//           type: BottomNavigationBarType.fixed,
//           items: <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//               icon: SvgPicture.asset(
//                 'assets/images/home_unactive.svg',
//                 color: Colors.grey[500],
//                 height: 25,
//                 width: 25,
//               ),
//               label: '',
//               activeIcon: SvgPicture.asset(
//                 'assets/images/home_active.svg',
//                 height: 25,
//                 width: 25,
//                 color: Theme.of(context).primaryColorLight,
//               ),
//             ),
//             BottomNavigationBarItem(
//               icon: Stack(
//                 children: <Widget>[
//                   SvgPicture.asset(
//                     'assets/images/wishlist_unactive.svg',
//                     color: Colors.grey[500],
//                     height: 25,
//                     width: 25,
//                   ),
//                   WishCountItem()
//                 ],
//               ),
//               label: '',
//               activeIcon: Stack(
//                 children: <Widget>[
//                   SvgPicture.asset(
//                     'assets/images/whishlisht_Active.svg',
//                     color: Theme.of(context).primaryColorLight,
//                     height: 25,
//                     width: 25,
//                   ),
//                   WishCountItem()
//                 ],
//               ),
//             ),
//             BottomNavigationBarItem(
//               icon: SvgPicture.asset(
//                 'assets/images/barcode_unactive.svg',
//                 color: Colors.grey[500],
//                 height: 30,
//                 width: 30,
//               ),
//               label: '',
//               activeIcon: SvgPicture.asset(
//                 'assets/images/barcode_active.svg',
//                 height: 30,
//                 width: 30,
//                 color: Theme.of(context).primaryColorLight,
//               ),
//             ),
//             BottomNavigationBarItem(
//               icon: SvgPicture.asset(
//                 'assets/images/MapUnactive.svg',
//                 height: 25,
//                 width: 25,
//                 color: Colors.grey[500],
//               ),
//               label: '',
//               activeIcon: SvgPicture.asset(
//                 'assets/images/mapActive.svg',
//                 height: 25,
//                 width: 25,
//                 color: Theme.of(context).primaryColorLight,
//               ),
//             ),
//             BottomNavigationBarItem(
//               icon: SvgPicture.asset(
//                 'assets/images/UserUnactive.svg',
//                 height: 25,
//                 width: 25,
//                 color: Colors.grey[500],
//               ),
//               label: '',
//               activeIcon: SvgPicture.asset(
//                 'assets/images/UserActive.svg',
//                 height: 25,
//                 width: 25,
//                 color: Theme.of(context).primaryColorLight,
//               ),
//             ),
//           ],
//           onTap: navigationTapped,
//           currentIndex: _page,
//         ),
//       ),
//     );
//   }

//   void navigationTapped(int page) {
//     _pageController.jumpToPage(page);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _pageController.dispose();
//   }

//   void onPageChanged(int page) {
//     setState(() {
//       this._page = page;
//     });
//   }

//   exitDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => CustomAlert(
//         child: Padding(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               SizedBox(height: 15),
//               Text(
//                 Constant.appName,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 25),
//               Text(
//                 "Are you sure you want to quit?",
//                 style: TextStyle(
//                   fontWeight: FontWeight.w500,
//                   fontSize: 14,
//                 ),
//               ),
//               SizedBox(height: 40),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Container(
//                       height: 40,
//                       width: 130,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor:
//                                 Theme.of(context).colorScheme.secondary,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                             )),
//                         child: Text(
//                           "Yes",
//                           style: TextStyle(
//                             color: Colors.white,
//                           ),
//                         ),
//                         onPressed: () => exit(0),
//                       )),
//                   Container(
//                     height: 40,
//                     width: 130,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                               Theme.of(context).colorScheme.secondary,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5.0),
//                           )),
//                       child: Text(
//                         "Yes",
//                         style: TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//                       onPressed: () => exit(0),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class BottamNavigation extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  BottamNavigation({this.analytics, this.observer});
  @override
  State<BottamNavigation> createState() => _BottamNavigationState();
}

class _BottamNavigationState extends State<BottamNavigation> {
  PageController _pageController;
  int _page = 0;
  final databaseHelper = DatabaseHelper.instance;
  SharedPreferences sharedPreferences;
  String accessToken;
  DateTime now = DateTime.now();
  bool isLogin;
  Future<void> checkexpireTokenDate() async {
    sharedPreferences = await SharedPreferences.getInstance();
    isLogin = sharedPreferences.getBool('isLogin');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
    checkexpireTokenDate();
    Provider.of<WishNotifier>(context, listen: false);

    _controller = PersistentTabController(initialIndex: 0);
  }

  int i = 0;

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        inactiveIcon: SvgPicture.asset(
          'assets/images/home_unactive.svg',
          color: Colors.grey[500],
          height: 25,
          width: 25,
        ),
        icon: SvgPicture.asset(
          'assets/images/home_active.svg',
          height: 25,
          width: 25,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
      PersistentBottomNavBarItem(
        inactiveIcon: Container(
          alignment: Alignment.center,
          child: Stack(
            children: <Widget>[
              SvgPicture.asset(
                'assets/images/wishlist_unactive.svg',
                color: Colors.grey[500],
                height: 25,
                width: 25,
              ),
              WishCountItem()
            ],
          ),
        ),
        icon: Container(
          alignment: Alignment.center,
          child: Stack(
            fit: StackFit.passthrough,
            children: <Widget>[
              SvgPicture.asset(
                'assets/images/whishlisht_Active.svg',
                color: Theme.of(context).primaryColorLight,
                height: 25,
                width: 25,
              ),
              WishCountItem()
            ],
          ),
        ),
      ),
      PersistentBottomNavBarItem(
        inactiveIcon: SvgPicture.asset(
          'assets/images/barcode_unactive.svg',
          color: Colors.grey[500],
          height: 30,
          width: 30,
        ),
        icon: SvgPicture.asset(
          'assets/images/barcode_active.svg',
          height: 30,
          width: 30,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
      PersistentBottomNavBarItem(
        inactiveIcon: SvgPicture.asset(
          'assets/images/MapUnactive.svg',
          height: 25,
          width: 25,
          color: Colors.grey[500],
        ),
        icon: SvgPicture.asset(
          'assets/images/mapActive.svg',
          height: 25,
          width: 25,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
      PersistentBottomNavBarItem(
        inactiveIcon: SvgPicture.asset(
          'assets/images/UserUnactive.svg',
          height: 25,
          width: 25,
          color: Colors.grey[500],
        ),
        icon: SvgPicture.asset(
          'assets/images/UserActive.svg',
          height: 25,
          width: 25,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
    ];
  }

  PersistentTabController _controller;

  @override
  Widget build(BuildContext context) {
    Provider.of<WishNotifier>(context, listen: false);

    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: <Widget>[
          HomeScreen(),
          Wishlist(),
          ScanAndShop(),
          StoresLocators(),
          (isLogin != null && isLogin)
              ? MyAccount()
              : SignIn(
                  ischeckout: false,
                ),
        ],
        items: _navBarsItems(),
        confineInSafeArea: true,
        handleAndroidBackButtonPress: true,

        // Default is true.
        resizeToAvoidBottomInset: true,
        // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true,
        hideNavigationBar: false,
        // Default is true.
        hideNavigationBarWhenKeyboardShows: true,
        // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.once,
        itemAnimationProperties: ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style2, // Choose the nav bar style with this property.
      ),
    );
  }
}
