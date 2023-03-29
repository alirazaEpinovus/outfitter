import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:outfitters/UI/Screens/BottamNavigation.dart';
import 'package:outfitters/UI/Screens/Language/all_translations.dart';
import 'package:outfitters/Utils/Helper.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class Introduction1 extends StatefulWidget {
  @override
  _Introduction1State createState() => _Introduction1State();
}

class _Introduction1State extends State<Introduction1> {
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
    changeLanguage.setNewLanguage('en');
    Helper.savePreferenceString('language', 'en');
    Helper.savePreferenceBoolean('remember', true);
    // loadValues();
  }

  @override
  Widget build(BuildContext context) {
    return sharedPreferences == null
        ? Container()
        : Scaffold(
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
                            child: SvgPicture.asset(
                                'assets/images/notification.svg')),
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(labels["notifications"],
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800))),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(labels["intro_1"],
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
                        margin:
                            EdgeInsets.only(bottom: 15, left: 20, right: 20),
                        padding: EdgeInsets.symmetric(vertical: 17),
                        child: Text(
                          labels["next"],
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
