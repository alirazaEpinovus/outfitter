import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:outfitters/UI/Screens/BottamNavigation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Introduction2 extends StatefulWidget {
  @override
  _Introduction2State createState() => _Introduction2State();
}

class _Introduction2State extends State<Introduction2> {
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
                              'assets/images/earth.svg',
                              color: Theme.of(context).primaryColorLight,
                            )),
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(labels["geolocation"],
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800))),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(labels["intro_2"],
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 14)))
                      ],
                    ),
                  ),
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              BottamNavigation())),
                      child: Container(
                        color: Theme.of(context).primaryColorLight,
                        width: MediaQuery.of(context).size.width,
                        margin:
                            EdgeInsets.only(bottom: 15, left: 20, right: 20),
                        padding: EdgeInsets.symmetric(vertical: 17),
                        child: Text(
                          labels["start"],
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
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
