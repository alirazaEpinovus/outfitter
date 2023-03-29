import 'package:flutter/material.dart';
import 'package:outfitters/UI/Screens/AboutOutfitters.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BuyingGuide extends StatefulWidget {
  @override
  _BuyingGuideState createState() => _BuyingGuideState();
}

class _BuyingGuideState extends State<BuyingGuide> {
  SharedPreferences sharedPreferences;
  dynamic labels;
  @override
  void initState() {
    loadValues();
    super.initState();
  }

  loadValues() async {
    sharedPreferences = await SharedPreferences.getInstance();
    labels = json.decode(sharedPreferences.getString("labels"));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return sharedPreferences == null
        ? Container()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              automaticallyImplyLeading: false,
              leading: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.clear)),
              centerTitle: true,
              elevation: 1,
              title: Text(
                labels["buying_guide"],
                style: AppTheme.TextTheme.titlebold,
              ),
            ),
            body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AboutOutfitters(
                                  name: "Order Process",
                                  url:
                                      "https://outfitters.com.pk/pages/order-process-mobile-app"),
                              settings:
                                  RouteSettings(name: 'AboutOutfitters')));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 30),
                      child: Text(labels["order_process"]),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AboutOutfitters(
                                  name: "Shipping policy",
                                  url:
                                      "https://outfitters.com.pk/pages/shipping-mobile-app"),
                              settings:
                                  RouteSettings(name: 'AboutOutfitters')));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 30),
                      child: Text(labels["shipping"]),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AboutOutfitters(
                                  name: "FAQs",
                                  url:
                                      "https://outfitters.com.pk/pages/faqs-mobile-app"),
                              settings:
                                  RouteSettings(name: 'AboutOutfitters')));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 30),
                      child: Text(labels["faqs"]),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AboutOutfitters(
                                  name: "Terms & Conditions",
                                  url:
                                      "https://outfitters.com.pk/pages/terms-and-conditions"),
                              settings:
                                  RouteSettings(name: 'AboutOutfitters')));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 30),
                      child: Text(labels["terms_conditions"]),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 1,
                  )
                ],
              ),
            ),
          );
  }
}
