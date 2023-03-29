import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:outfitters/Models/CountriesModel.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;
import 'package:outfitters/Utils/Helper.dart';

class Countries extends StatefulWidget {
  @override
  _CountriesState createState() => _CountriesState();
}

class _CountriesState extends State<Countries> {
  CountriesModel countriesModel;
  bool show = false;
  FocusNode searchcountryNode = FocusNode();
  String search;
  TextEditingController searchController = TextEditingController();

  Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
    return rootBundle
        .loadString(assetsPath)
        .then((jsonStr) => jsonDecode(jsonStr));
  }

  @override
  void initState() {
    parseJsonFromAssets("assets/jsonfiles/countrydata.json").then((onValue) {
      setState(() {
        countriesModel = CountriesModel.fromJson(onValue);
        show = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(Icons.clear)),
          elevation: 1,
          title: Text(
            'CHOOSE YOUR LOCATION',
            style: AppTheme.TextTheme.boldText,
          ),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: searchcountryNode.hasFocus
                          ? MediaQuery.of(context).size.width - 110
                          : MediaQuery.of(context).size.width - 20,
                      color: Colors.grey[200],
                      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: Row(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(right: 10, left: 5),
                              child: Icon(
                                Icons.search,
                                color: Colors.black,
                              )),
                          Expanded(
                            child: TextField(
                              onChanged: _changeListener,
                              focusNode: searchcountryNode,
                              style: TextStyle(fontSize: 17),
                              controller: searchController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.black),
                                hintText: 'Search Here',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    searchcountryNode.hasFocus
                        ? Container(
                            width: 90,
                            child: InkWell(
                              onTap: () {
                                searchController.clear();
                              },
                              child: Center(
                                child: Text('Cancel'),
                              ),
                            ),
                          )
                        : SizedBox()
                  ],
                ),
              ),
              Expanded(
                child: Container(
                    child: show
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: countriesModel.countryData.length,
                            itemBuilder: (BuildContext context, int index) {
                              return search == null
                                  ? _countryWidget(
                                      countriesModel.countryData[index])
                                  : show &&
                                          search != null &&
                                          countriesModel.countryData[index].name
                                              .toUpperCase()
                                              .contains(search.toUpperCase())
                                      ? _countryWidget(
                                          countriesModel.countryData[index])
                                      : SizedBox();
                            })
                        : Container()),
              ),
            ],
          ),
        ));
  }

  Widget _countryWidget(CountryData countryData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: () async {
            Helper.savePreferenceString(
                    "country", countryData.name.toUpperCase())
                .then((onValue) => Navigator.of(context).pop());
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(right: 20, left: 20),
                    child: SvgPicture.asset(
                      'assets/images/bag.svg',
                      color: Theme.of(context).primaryColorLight,
                    )),
                Text(
                  '${countryData.name.toUpperCase()}',
                  style: AppTheme.TextTheme.regularTextBig,
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 50),
          child: Divider(
            color: Colors.grey,
            height: 2,
          ),
        )
      ],
    );
  }

  void _changeListener(String value) {
    setState(() {
      search = value;
      show = true;
    });
  }
}
