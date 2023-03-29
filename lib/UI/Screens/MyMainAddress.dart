import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:outfitters/UI/Widgets/ToastClass.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MainAddress extends StatefulWidget {
  @override
  _MainAddressState createState() => _MainAddressState();
}

class _MainAddressState extends State<MainAddress> {
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;
  bool isNetwork = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String phone;
  String email;
  String emergencyPhone;
  List _addressItems = [];
  SharedPreferences sharedPreferences;
  FocusNode _phoneFocus = new FocusNode();
  FocusNode _emailFocus = new FocusNode();
  TextEditingController companyController = TextEditingController();
  TextEditingController gstController = TextEditingController();
  TextEditingController phoneController;
  var phonNo = "";
  var abcList = [];
  List both = [];
  List address = [];

  savevalueGet() async {
    sharedPreferences = await SharedPreferences.getInstance();
    phonNo = sharedPreferences.getString('phoneNumber').toString();
    print(sharedPreferences.getString('address').toString());
    abcList = sharedPreferences.getStringList('addresses');
    phoneController = new TextEditingController(
      text: phonNo == null || phonNo == "null" ? "" : phonNo,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    savevalueGet();
    //check internet connection
    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      print(result.toString());
      if (result == ConnectivityResult.none) {
        setState(() {
          isNetwork = false;
        });
      } else if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          isNetwork = true;
        });
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Text("Outfitters"),
          centerTitle: true,
          elevation: 4,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // phonNo != null
                //     ? Container(
                //         child: Text(
                //           "Phone Number",
                //           style: TextStyle(
                //               color: Color(0xFFA2A2A2),
                //               fontSize: 14,
                //               fontFamily: "Roboto",
                //               fontWeight: FontWeight.normal),
                //         ),
                //       )
                //     : Container(),
                Container(
                  // height: 40,
                  margin: EdgeInsets.only(left: 5, right: 5),
                  width: MediaQuery.of(context).size.width - 10,
                  child: TextFormField(
                    controller: phoneController,
                    textInputAction: TextInputAction.next,
                    focusNode: _phoneFocus,
                    keyboardType: TextInputType.phone,
                    onSaved: (String value) => phone = value,
                    onFieldSubmitted: (term) {
                      _phoneFocus.unfocus();
                    },
                    validator: validatePhone,
                    maxLength: 11,
                    decoration: new InputDecoration(
                      fillColor: Colors.black,
                      labelText: "Phone Number",
                      labelStyle: TextStyle(
                          color: Color(0xFFA2A2A2),
                          fontSize: 14,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
                Container(
                  margin: _addressItems.length == 0
                      ? EdgeInsets.only(left: 5, right: 5, top: 20, bottom: 15)
                      : EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Text(
                          "Address",
                          style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: () {
                            _openDialogAddress();
                          },
                          child: Icon(
                            Icons.add_circle,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _addressItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return getAddressRow(index);
                    }),
                abcList != null
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: abcList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return getAddressRow2(index);
                        })
                    : Container(),
                Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 5, right: 5, top: 5),
                  color: Colors.grey[500],
                ),
                Text("$address"),

                InkWell(
                  onTap: () async {
                    for (int i = 0; i < _addressItems.length; i++) {
                      address.add(_addressItems[i].address);
                    }

                    final prefs = await SharedPreferences.getInstance();
                    // prefs.setString("phoneNumber", phoneController.text);
                    await prefs.setStringList("addresses", address);
                    Navigator.pop(context);
                    Toast.showToast(context, 'Successfully Saved...');
                  },
                  child: Container(
                      alignment: Alignment.center,
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black,
                      margin: EdgeInsets.only(left: 5, right: 5, top: 50),
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getAddressRow2(int index) {
    return TextButton(
      child: Container(
        // margin: EdgeInsets.only(top: 2, bottom: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                child: Text(
                  "Address ${index + 1}: ",
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                child: Text(
                  abcList[index],
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
      onPressed: () {
        setState(() {
          // _items.removeAt(index);
        });
      },
    );
  }

  Widget getAddressRow(int index) {
    return TextButton(
      child: Container(
        // margin: EdgeInsets.only(top: 2, bottom: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                child: Text(
                  "Address ${index + 1}: ",
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                child: Text(
                  _addressItems[index].address,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
      onPressed: () {
        setState(() {
          // _items.removeAt(index);
        });
      },
    );
  }

  validateAndSave() async {
    final form = _formKey.currentState;
    if (form.validate()) {
    } else {
      print('form is invalid');
    }
  }

  String validatePhone(String value) {
    final RegExp phoneExp = RegExp(r'^\d\d\d\d\d\d\d\d\d\d\d$');

    if (value.length == 0) {
      return "Phone number can't be empty";
    } else if (value[0] != "0") {
      return "Phone number is not valid";
    } else if (value[1] != "3") {
      return "Phone number is not valid";
    } else if (value[2] == "5") {
      return "Phone number is not valid";
    } else if (value[2] == "6") {
      return "Phone number is not valid";
    } else if (value[2] == "7") {
      return "Phone number is not valid";
    } else if (value[2] == "8") {
      return "Phone number is not valid";
    } else if (value[2] == "9") {
      return "Phone number is not valid";
    } else if (!phoneExp.hasMatch(value)) {
      return "Phone number is not correct";
    }
    return null;
  }

  Future _openDialogAddress() async {
    AddressModel addressData = await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => DialogAddAddress());

    setState(() {
      if (addressData != null) {
        _addressItems.add(addressData);
        print(_addressItems);
      }
    });
  }
}

class AddressModel {
  String address;

  AddressModel(this.address);

  AddressModel.empty() {
    address = "";
  }
}

class DialogAddAddress extends StatefulWidget {
  @override
  _DialogAddAddressState createState() => new _DialogAddAddressState();
}

class _DialogAddAddressState extends State<DialogAddAddress>
    with SingleTickerProviderStateMixin {
  AddressModel _addressData = new AddressModel.empty();

  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(milliseconds: 540), vsync: this);
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  TextEditingController addressController = new TextEditingController();
  String address;
  FocusNode _addressFocus = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        // heightFactor: MediaQuery.of(context).size.height - 200,
        child: Material(
          color: Colors.transparent,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: Center(
              child: Container(
                  width: MediaQuery.of(context).size.width - 50,
                  height: 230,
                  decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0))),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 9,
                            child: Container(
                              margin: EdgeInsets.only(top: 15, left: 25),
                              child: Text(
                                'ADD ADDRESS',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: "Lato",
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                  padding: EdgeInsets.only(
                                      top: 10, left: 10, right: 10, bottom: 10),
                                  child: Icon(Icons.close)),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        // height: 40,
                        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                        width: MediaQuery.of(context).size.width - 10,
                        child: TextFormField(
                          controller: addressController,
                          textInputAction: TextInputAction.next,
                          focusNode: _addressFocus,
                          keyboardType: TextInputType.text,
                          onChanged: (String value) {
                            _addressData.address = value;
                          },
                          onFieldSubmitted: (term) {
                            _addressFocus.unfocus();
                          },
                          decoration: new InputDecoration(
                            fillColor: Colors.black,
                            hintText: "Address",
                            hintStyle: TextStyle(
                                color: Color(0xFFA2A2A2),
                                fontSize: 14,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 30,
                        margin: EdgeInsets.only(
                            left: 20, right: 20, bottom: 10, top: 30),
                        height: 45,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.0),
                                      side: BorderSide(color: Colors.black)))),
                          child: Text(
                            'ADD',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "Lato",
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0),
                          ),
                          onPressed: () async {
                            // if (addressController.text == "") {
                            //   return Flushbar(
                            //     messageText: Text(
                            //       "Address cann't be empty",
                            //       style: TextStyle(
                            //           fontSize: 15,
                            //           color: Colors.white,
                            //           fontWeight: FontWeight.w500),
                            //     ),
                            //     duration: Duration(seconds: 3),
                            //     isDismissible: true,
                            //     icon: Image.asset(
                            //       "assets/images/cancel.png",
                            //       // scale: 1.0,
                            //       height: 30,
                            //       width: 30,
                            //     ),
                            //     backgroundColor: Colors.red,
                            //     margin: EdgeInsets.all(8),
                            //     borderRadius: 8,
                            //   )..show(context);
                            // } else {
                            Navigator.of(context).pop(_addressData);
                            // }
                          },
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
