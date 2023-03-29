import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:outfitters/UI/Screens/Countries.dart';
import 'package:outfitters/UI/Screens/Splash.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;
import 'package:outfitters/Utils/Helper.dart';
import 'package:page_transition/page_transition.dart';

import 'Language/all_translations.dart';

class SelectCountry extends StatefulWidget {
  @override
  _SelectCountryState createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry> {
  List<String> _languages = ['en', 'es'];
  bool isRemember = false;

  @override
  void initState() {
    super.initState();
    changeLanguage.setNewLanguage('en');
    Helper.savePreferenceString('language', 'en');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/scr1.png'),
                            fit: BoxFit.fill)),
                  )),
              Flexible(
                  flex: 1,
                  child: Container(
                    height: 50,
                    width: 150,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    alignment: FractionalOffset.centerLeft,
                    child: Image.asset(
                      'assets/sizecharts/img12.jpg',
                      color: Theme.of(context).primaryColorLight,
                    ),
                  )),
              Flexible(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Text(
                        'Choose your location',
                        style: AppTheme.TextTheme.boldText,
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(PageTransition(
                            child: Countries(),
                            type: PageTransitionType.leftToRight));
                        setState(() {});
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                    margin:
                                        EdgeInsets.only(right: 20, left: 10),
                                    child: SvgPicture.asset(
                                      'assets/images/bag.svg',
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    )),
                                FutureBuilder<String>(
                                    future:
                                        Helper.getSharePreference('country'),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        return Text(
                                          snapshot.data == null
                                              ? "PAKISTAN"
                                              : snapshot.data,
                                          style:
                                              AppTheme.TextTheme.regularTextBig,
                                        );
                                      } else {
                                        return SizedBox();
                                      }
                                    }),
                              ],
                            ),
                            Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Icon(Icons.arrow_drop_down))
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
              Flexible(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            'Select a language',
                            style: AppTheme.TextTheme.boldText,
                          ),
                        ),
                        FutureBuilder<String>(
                            future: Helper.getSharePreference('language'),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Container(
                                  margin: EdgeInsets.only(top: 14),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: List.generate(_languages.length,
                                          (index) {
                                        return InkWell(
                                          splashColor: Colors.transparent,
                                          onTap: () async {
                                            await changeLanguage.setNewLanguage(
                                                '${_languages[index]}');
                                            Helper.savePreferenceString(
                                                    'language',
                                                    _languages[index])
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
                  )),
              Flexible(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Checkbox(
                                value: isRemember,
                                onChanged: (value) {
                                  isRemember = !isRemember;
                                  Helper.savePreferenceBoolean(
                                          'remember', isRemember)
                                      .then((onValue) {
                                    setState(() {});
                                  });
                                }),
                            Container(
                              child: Text(
                                'Remember my selection',
                                style: AppTheme.TextTheme.boldText,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SplashScreen())),
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width - 30,
                            color: Theme.of(context).primaryColorLight,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                                child: Text(
                              'GO!',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            )),
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
