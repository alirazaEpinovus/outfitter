import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:outfitters/Database/DatabaseHelper.dart';
import 'package:outfitters/Models/WishlistModel.dart';
import 'package:outfitters/UI/Widgets/ToastClass.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as Apptheme;
// import 'package:cloud_functions/cloud_functions.dart';

class ShareWishList extends StatefulWidget {
  @override
  _ShareWishListState createState() => _ShareWishListState();
}

class _ShareWishListState extends State<ShareWishList> {
  final _formKey = GlobalKey<FormState>();
  // TextEditingController _yourEmailController = TextEditingController();
  TextEditingController _yourNamecontroller = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _notecontroller = TextEditingController();

  FocusNode _noteNode = FocusNode();
  FocusNode _emailNode = FocusNode();
  FocusNode _nameNode = FocusNode();
  FocusNode _yourEmailNode = FocusNode();
  FocusNode _yourNameNode = FocusNode();
  int _groupValue = -1;
  final databasehelper = DatabaseHelper.instance;
  List<WishListModel> wishlist = [];
  bool isAutoValidate = false;
  List<String> _options = [];
  SharedPreferences sharedPreferences;
  dynamic labels;

  loadValues() async {
    sharedPreferences = await SharedPreferences.getInstance();
    labels = json.decode(sharedPreferences.getString("labels"));
    setState(() {});
  }

  @override
  void initState() {
    databasehelper.wishqueryAllRows().then((onValue) => wishlist = onValue);
    super.initState();
    loadValues();
  }

  @override
  Widget build(BuildContext context) {
    _options = [
      labels["wishlist_msg1"],
      labels["wishlist_msg2"],
      labels["wishlist_msg3"],
      labels["wishlist_msg4"]
    ];
    return sharedPreferences == null
        ? Container()
        : Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                leading: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.close)),
                centerTitle: true,
                elevation: 1,
                title: Text(
                  labels["share_wishlist"],
                  style: Apptheme.TextTheme.titlebold,
                ),
                actions: <Widget>[
                  InkWell(
                    onTap: () {
                      // validateAndSave();
                    },
                    child: Container(
                      width: 90,
                      padding: EdgeInsets.only(right: 20, left: 20),
                      alignment: Alignment.centerRight,
                      child: Container(
                        child: Text(
                          labels["ok"],
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              body: Container(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                  labels["recipient"] + "\n" + labels["name"]),
                            ),
                            Container(
                                padding: EdgeInsets.only(left: 10),
                                width: MediaQuery.of(context).size.width / 1.4,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    focusNode: _nameNode,
                                    validator: (value) {
                                      if (value.trim().isEmpty) {
                                        return labels["recipient"] +
                                            labels["valid_name"];
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {},
                                    onFieldSubmitted: (terms) {
                                      _nameNode.unfocus();
                                      FocusScope.of(context)
                                          .requestFocus(_emailNode);
                                    },
                                    controller: _namecontroller,
                                    keyboardType: TextInputType.text,
                                    decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: Color(0xFFA2A2A2),
                                        fontSize: 13,
                                        fontStyle: FontStyle.normal,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 2.0, horizontal: 10.0),
                                    ))),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        height: 1,
                        color: Colors.grey,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                  labels["recipient"] + "\n" + labels["email"]),
                            ),
                            Container(
                                padding: EdgeInsets.only(left: 10),
                                width: MediaQuery.of(context).size.width / 1.4,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    focusNode: _emailNode,
                                    validator: (value) {
                                      Pattern pattern =
                                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                      RegExp regex = new RegExp(pattern);
                                      if (value.trim().isEmpty ||
                                          !regex.hasMatch(value)) {
                                        return labels["email_valid"];
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {},
                                    onFieldSubmitted: (terms) {
                                      _emailNode.unfocus();
                                      FocusScope.of(context)
                                          .requestFocus(_yourNameNode);
                                    },
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: Color(0xFFA2A2A2),
                                        fontSize: 13,
                                        fontStyle: FontStyle.normal,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 2.0, horizontal: 10.0),
                                    ))),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        height: 1,
                        color: Colors.grey,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(labels["your_name"] + " "),
                            ),
                            Container(
                                padding: EdgeInsets.only(left: 10),
                                width: MediaQuery.of(context).size.width / 1.4,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    focusNode: _yourNameNode,
                                    validator: (value) {
                                      if (value.trim().isEmpty) {
                                        return labels["valid_name"];
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {},
                                    onFieldSubmitted: (terms) {
                                      _yourNameNode.unfocus();
                                      FocusScope.of(context)
                                          .requestFocus(_yourEmailNode);
                                    },
                                    controller: _yourNamecontroller,
                                    keyboardType: TextInputType.text,
                                    decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: Color(0xFFA2A2A2),
                                        fontSize: 13,
                                        fontStyle: FontStyle.normal,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 2.0, horizontal: 10.0),
                                    ))),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        height: 1,
                        color: Colors.grey,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        height: 1,
                        color: Colors.grey,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 20),
                        child: Text(labels["msg"]),
                      ),
                      _myRadioButton(
                        title: _options[0],
                        value: 0,
                        onChanged: (newValue) =>
                            setState(() => _groupValue = newValue),
                      ),
                      _myRadioButton(
                        title: _options[1],
                        value: 1,
                        onChanged: (newValue) =>
                            setState(() => _groupValue = newValue),
                      ),
                      _myRadioButton(
                        title: _options[2],
                        value: 2,
                        onChanged: (newValue) =>
                            setState(() => _groupValue = newValue),
                      ),
                      _myRadioButton(
                        title: _options[3],
                        value: 3,
                        onChanged: (newValue) =>
                            setState(() => _groupValue = newValue),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 20),
                        child: Text(labels["add_note"]),
                      ),
                      Container(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 20),
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              focusNode: _noteNode,
                              onSaved: (value) {},
                              onFieldSubmitted: (terms) {
                                _noteNode.unfocus();
                              },
                              keyboardType: TextInputType.multiline,
                              maxLength: null,
                              maxLines: null,
                              controller: _notecontroller,
                              decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  )))),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  _launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await launch(url)) {
      await launch(url);
    }
  }

  Widget _myRadioButton({var title, int value, Function onChanged}) {
    return RadioListTile(
      value: value,
      activeColor: Colors.black,
      groupValue: _groupValue,
      onChanged: onChanged,
      title: Text(title),
    );
  }

  // validateAndSave() {
  //   final form = _formKey.currentState;
  //   if (form.validate()) {
  //     HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
  //         // region: "europe-west3",
  //         'sendMailSendGrid');
  //     // var callable =
  //     //     FirebaseFunctions.instance.httpsCallable('sendMailSendGrid');
  //     String subject = "<center><h1> Outfitters </h1></center>"
  //         "<hr>"
  //         "<center><h3>${_yourNamecontroller.text} wants to share their wishlist with you.</h3> </center>"
  //         "<center> ${_notecontroller.text} </center>"
  //         "<a href='https://outfitters.com.pk/' target='_blank' style='background-color: #000; color: #fff; display: block; height: 40px; width: 200px; margin: 20px auto; line-height: 40px; text-decoration: none;'><center>See Wishlist</center></a>"
  //         "<div>${productsLink()}</div>";

  //     callable.call(<String, dynamic>{
  //       "toEmail": _emailController.text,
  //       "fromEmail": "Outfitters<contactus@outfitters.com.pk>",
  //       "subject": _options[_groupValue],
  //       "text": subject,
  //       "html": "$subject"
  //     });

  //     Navigator.pop(context);
  //     Fluttertoast.showToast(msg: "Email sent Successfully");
  //     // _launchURL(
  //     //     _emailController.text, _options[_groupValue], manageBodytext());
  //     print("${productsLink()}");
  //   } else {
  //     setState(() {
  //       isAutoValidate = true;
  //     });
  //   }
  // }

  String manageBodytext() {
    return " ${_yourNamecontroller.text} wants to share their wishlist with you. \n \n ${_notecontroller.text} \n \n  ${Uri.encodeComponent(productsLink())}";
  }

  String productsLink() {
    List<String> onstoreproducts = [];
    wishlist.forEach((data) {
      onstoreproducts.add(
          "<div style='display: inline-block; width: 260px; min-width: 260px; text-align: center; padding: 0 10px'><a href='${data.onlineStoreUrl}' target='_blank '><img src='${data.productImage}' width='180'></a><h3 style='text-align: center;overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'> ${data.productName} </h3><p style='text-align: center'>Rs. ${data.productPrice}</p><a href='${data.onlineStoreUrl}' target='_blank'  style='background-color: #000; color: #fff; display: block; height: 40px; width: 100%; max-width: 200px; margin: 20px auto; line-height: 40px; text-decoration: none; text-align: center'>See Product</a></div>");
    });
    return onstoreproducts.join('');
  }
}
