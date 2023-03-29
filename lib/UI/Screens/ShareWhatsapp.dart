import 'dart:io';

import 'package:flutter/material.dart';
import 'package:outfitters/Database/DatabaseHelper.dart';
import 'package:outfitters/Models/WishlistModel.dart';
import 'package:outfitters/UI/Widgets/ToastClass.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;
import 'package:url_launcher/url_launcher.dart';

class ShareWhatsapp extends StatefulWidget {
  @override
  _ShareWhatsappState createState() => _ShareWhatsappState();
}

class _ShareWhatsappState extends State<ShareWhatsapp> {
  List<String> _options = [];
  int _groupValue = -1;
  List<WishListModel> wishlist = [];
  TextEditingController _notecontroller = TextEditingController();
  final databasehelper = DatabaseHelper.instance;
  FocusNode _noteNode = FocusNode();

  @override
  void initState() {
    _options = [
      "You'r going to love this",
      "Surprise! Look what I found!",
      "Look, I love this!",
      "Do you need help thinking of a gift for me?"
    ];
    databasehelper.wishqueryAllRows().then((onValue) => wishlist = onValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          leading: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(Icons.close)),
          centerTitle: true,
          elevation: 1,
          title: Text(
            'SHARE WISHLIST',
            style: AppTheme.TextTheme.titlebold,
          ),
          actions: <Widget>[
            InkWell(
              onTap: () {
                if (_groupValue == -1) {
                  Toast.showToast(context, 'Please select one option');
                } else {
                  Navigator.pop(context);
                  String message =
                      "${_options[_groupValue]}\n ${_notecontroller.text} \n ${Uri.parse(productsLink())}  ";
                  launchWhatsApp(message: message);
                  print("${Uri.encodeComponent(productsLink())}");
                }
              },
              child: Container(
                width: 90,
                padding: EdgeInsets.only(right: 20, left: 20),
                alignment: Alignment.centerRight,
                child: Container(
                  child: Text(
                    'Ok',
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                child: Text('What message would you like to send them?'),
              ),
              _myRadioButton(
                title: _options[0],
                value: 0,
                onChanged: (newValue) => setState(() => _groupValue = newValue),
              ),
              _myRadioButton(
                title: _options[1],
                value: 1,
                onChanged: (newValue) => setState(() => _groupValue = newValue),
              ),
              _myRadioButton(
                title: _options[2],
                value: 2,
                onChanged: (newValue) => setState(() => _groupValue = newValue),
              ),
              _myRadioButton(
                title: _options[3],
                value: 3,
                onChanged: (newValue) => setState(() => _groupValue = newValue),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                child: Text('Add a note'),
              ),
              Container(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          )))),
            ],
          ),
        ));
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

  void launchWhatsApp({
    @required String message,
  }) async {
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/?text=${Uri.parse(message)}";
      } else {
        return "whatsapp://send?text=$message";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      Toast.showToast(context, 'Ops! Whatsapp is not installed.');
    }
  }

  String productsLink() {
    List<String> onstoreproducts = [];
    wishlist.forEach((data) {
      print(data.onlineStoreUrl);
      data.onlineStoreUrl == null ||
              data.onlineStoreUrl == "1" ||
              data.onlineStoreUrl == "2"
          ? print(data.onlineStoreUrl)
          : onstoreproducts.add(data.onlineStoreUrl);
    });
    return onstoreproducts.join(' , \n');
  }
}
