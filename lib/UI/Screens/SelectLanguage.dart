import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;
import 'package:outfitters/Utils/Helper.dart';
import 'BottamNavigation.dart';
import 'Language/all_translations.dart';

class SelectLanguage extends StatefulWidget {
  @override
  _SelectLanguageState createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  SharedPreferences sharedPreferences;
  dynamic labels;
  List<String> _languages = ['en', 'es'];

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
                labels["select_language"],
                style: AppTheme.TextTheme.titlebold,
              ),
            ),
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      labels["select_language"],
                      style: AppTheme.TextTheme.boldText,
                    ),
                  ),
                  FutureBuilder<String>(
                      future: Helper.getSharePreference('language'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Container(
                            margin: EdgeInsets.only(top: 14),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children:
                                    List.generate(_languages.length, (index) {
                                  return InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () async {
                                      await changeLanguage.setNewLanguage(
                                          '${_languages[index]}');
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  BottamNavigation()));

                                      Helper.savePreferenceString(
                                              'language', _languages[index])
                                          .then((onValue) {
                                        setState(() {});
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: 0.4,
                                              color: snapshot.data ==
                                                      _languages[index]
                                                  ? Colors.black
                                                  : Colors.grey)),
                                      child: Text(
                                        _languages[index].toUpperCase(),
                                        style: TextStyle(
                                            color: snapshot.data ==
                                                    _languages[index]
                                                ? Colors.black
                                                : Colors.grey),
                                      ),
                                    ),
                                  );
                                })),
                          );
                        } else {
                          return SizedBox();
                        }
                      })
                ],
              ),
            ),
          );
  }
}
