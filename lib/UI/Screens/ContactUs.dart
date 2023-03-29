import 'package:flutter/material.dart';
import 'package:outfitters/UI/Widgets/ToastClass.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
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

  launchEmail(String mailTo) async {
    var url = 'mailto:$mailTo?subject=&body=';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Toast.showToast(context, 'Gmail is not installed');
    }
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return sharedPreferences == null
        ? Container()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              centerTitle: true,
              title: Text(
                labels["contact"],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              elevation: 2,
            ),
            body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 40),
                      child: Text(
                        labels["we_will_speedly"],
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w400,
                            fontSize: 15),
                      )),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                              width: 0.3,
                            ),
                            bottom: BorderSide(
                              width: 0.3,
                            ))),
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Material(
                          child: InkWell(
                            onTap: () =>
                                launchEmail("contactus@outfitters.com.pk"),
                            child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                labels["send_email"],
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15, bottom: 15),
                          child: Divider(
                            height: 3,
                            thickness: 1,
                            color: Colors.grey[300],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _makePhoneCall('tel: +924235467243');
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              labels["call"] + ' +92-42-35467243',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
