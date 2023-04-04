import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:outfitters/UI/Screens/BottamNavigation.dart';
import 'package:outfitters/Utils/Helper.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Language/all_translations.dart';
import 'dart:io' show Platform;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    changeLanguage.setNewLanguage('en');
    Helper.savePreferenceString('language', 'en');
    Helper.savePreferenceBoolean('remember', true);
    super.initState();
  }

  // check1stTime() async {
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();

  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   if (sharedPreferences.getBool("is1stTime") == null) {
  //     PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //     String versionCode = packageInfo.buildNumber;
  //     print("1sttime");
  //     sharedPreferences.setBool("is1stTime", true);
  //     FirebaseFirestore.instance
  //         .collection("build_number")
  //         .doc("build")
  //         .update(Platform.isIOS
  //             ? {
  //                 'ios': int.parse(versionCode),
  //               }
  //             : {
  //                 'build_number': int.parse(versionCode),
  //               });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: true,
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      height: 200,
                      width: 200,
                      child:
                          SvgPicture.asset('assets/images/notification.svg')),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text("Notifications",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w800))),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                          "Be the first to hear about the most recent promotions and to receive the latest information for your orders",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14)))
                ],
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => BottamNavigation())),
                child: Container(
                  color: Theme.of(context).primaryColorLight,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(bottom: 15, left: 20, right: 20),
                  padding: EdgeInsets.symmetric(vertical: 17),
                  child: Text(
                    "Next",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
