import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'dart:developer' as dev;
import 'package:intl/intl.dart';
import 'package:outfitters/UI/GraphQL/Mutation/mutationQueries.dart';
import 'package:outfitters/UI/Notifiers/ConnectionNotifier.dart';
import 'package:outfitters/UI/Screens/AboutOutfitters.dart';
import 'package:outfitters/UI/Screens/MyAccount.dart';
import 'package:outfitters/UI/Screens/ResetPassword.dart';
import 'package:outfitters/UI/Screens/ShoppingBag.dart';
import 'package:outfitters/UI/Screens/Signup.dart';
import 'package:outfitters/UI/Widgets/CheckoutGuest.dart';
import 'package:outfitters/UI/Widgets/LoadingDialog.dart';
import 'package:outfitters/UI/Widgets/ToastClass.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;
import 'package:outfitters/main.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  final checkoutitems;
  final ischeckout;
  SignIn({this.checkoutitems, this.ischeckout});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  SharedPreferences sharedPreferences;
  dynamic labels;

  String fbEmail = '';

  loadValues() async {
    sharedPreferences = await SharedPreferences.getInstance();
    labels = json.decode(sharedPreferences.getString("labels"));

    setState(() {});
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _emailMessaging = TextEditingController();

  TextEditingController _passwordcontroller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool passwordshow = false;

  FocusNode _emailNode = FocusNode();
  FocusNode _emailNodeMessaging = FocusNode();

  FocusNode _passwordNode = FocusNode();
  bool isAutoValidate = false;
  bool passwordVisibility = true;
  String profileInformation;
  // FacebookLogin facebookLogin = FacebookLogin();

  @override
  void initState() {
    super.initState();

    loadValues();
  }

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    return Mutation(
      options: MutationOptions(
        document: gql(shopifyLogin),
        update: (cache, QueryResult result) {
          if (result.hasException) {
          } else {}
        },
        onError: (OperationException error) {
          dev.log("oerror_________________________________ $error");
          showDialog<AlertDialog>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  error.graphqlErrors.first.message,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                actions: <Widget>[
                  SimpleDialogOption(
                    child: const Text('DISMISS',
                        style: TextStyle(fontSize: 12, color: Colors.red)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            },
          );
        },
        onCompleted: (dynamic resultData) async {
          dev.log(
              "onCompleted___________________________________________________");
          debugPrint('resultData: ${resultData}');

          if (resultData['customerAccessTokenCreate']['customerAccessToken'] !=
              null) {
            print('date is ' +
                resultData['customerAccessTokenCreate']['customerAccessToken']
                    ['expiresAt']);
            DateTime input = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").parse(
                resultData['customerAccessTokenCreate']['customerAccessToken']
                    ['expiresAt']);
            print(input);

            sharedPreferences = await SharedPreferences.getInstance();
            sharedPreferences.setBool("isLogin", true);
            sharedPreferences.setString(
                "accessToken",
                resultData['customerAccessTokenCreate']['customerAccessToken']
                    ['accessToken']);
            fbEmail == ""
                ? sharedPreferences.setString('email', _emailController.text)
                : sharedPreferences.setString('email', fbEmail);
            sharedPreferences.setString("expireAt", input.toString());

            Toast.showToast(context, "You are successfully Logged in");
            LoadingDialouge().showLoadingDialog(context, 'Processing');
            setState(() {});

            // Future.delayed(Duration(seconds: 7)).whenComplete(() {
            // Navigator.of(context, rootNavigator: true).pop();

            // Navigator.pop(context);

            // int count = 0;
            // Navigator.of(context).popUntil((_) => count++ >= 3);
            // });
            widget.ischeckout
                ? Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => new ShoppingBag()))
                : Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => new MyAccount()));

            // Navigator.of(context).pushReplacement(MaterialPageRoute(
            // builder: (context) => new BottamNavigation()));
          } else {
            dev.log("error___________________________________________________");
            // Navigator.pop(context);
            Toast.showToast(
              context,
              "Unidentified customer",
              // resultData
              //     .data['customerAccessTokenCreate']['customerUserErrors']
              //     .first['message']
              //     .toString()
            );
          }
        },
      ),
      builder: (RunMutation mutation, QueryResult result) {
        return sharedPreferences == null
            ? Container()
            : Scaffold(
                resizeToAvoidBottomInset: false,
                key: _scaffoldKey,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  centerTitle: true,
                  elevation: 1,
                  automaticallyImplyLeading: false,
                  leading: widget.ischeckout
                      ? InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.arrow_back_ios_new_outlined),
                          ),
                        )
                      : SizedBox(
                          height: 0,
                        ),
                  title: Text(
                    'Outfitters',
                    style: AppTheme.TextTheme.titlebold,
                  ),
                ),
                body: SingleChildScrollView(
                    child: Container(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Container(
                              padding: EdgeInsets.only(left: 10),
                              width: MediaQuery.of(context).size.width,
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
                                  cursorColor: Colors.black,
                                  onFieldSubmitted: (term) {
                                    _emailNode.unfocus();
                                    FocusScope.of(context)
                                        .requestFocus(_passwordNode);
                                  },
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: new InputDecoration(
                                    hintText: labels["email"],
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: Color(0xFFA2A2A2),
                                      fontSize: 13,
                                      fontStyle: FontStyle.normal,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 2.0, horizontal: 10.0),
                                    suffix: _emailController.text.isNotEmpty
                                        ? GestureDetector(
                                            onTap: () =>
                                                _emailController.clear(),
                                            child: Icon(Icons.clear))
                                        : SizedBox(),
                                  ))),
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                          child: Divider(
                            height: 1,
                          ),
                        ),
                        Container(
                          child: Container(
                            padding: EdgeInsets.only(left: 10),
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                //focusNode: _passwordFocus,
                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return labels["pass_valid"];
                                  }
                                  return null;
                                },
                                cursorColor: Colors.black,
                                obscureText: !passwordshow,
                                // validator:
                                onSaved: (value) {
                                  //password = value;
                                },
                                onFieldSubmitted: (terms) {
                                  _passwordNode.unfocus();
                                },
                                controller: _passwordcontroller,
                                keyboardType: TextInputType.text,
                                decoration: new InputDecoration(
                                  hintText: labels["password"],
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: Color(0xFFA2A2A2),
                                    fontSize: 13,
                                    fontStyle: FontStyle.normal,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                )),
                          ),
                        ),
                        Container(
                          // color:Colors.black45,
                          margin:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                          child: Divider(
                            height: 2,
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context).push(
                              PageTransition(
                                  child: ResetPassword(),
                                  type: PageTransitionType.rightToLeft,
                                  settings: RouteSettings(
                                      name: 'Reset password Screen'))),
                          child: Container(
                              padding: EdgeInsets.symmetric(vertical: 30),
                              child: Center(
                                  child: Text(labels["forgot_pass"],
                                      style: TextStyle(
                                        color: Colors.black45,
                                      )))),
                        ),
                        InkWell(
                          onTap: () {
                            if (_formKey.currentState.validate()) {
                              if (connectionStatus !=
                                  ConnectivityStatus.Offline) {
                                print("pressssssss");

                                mutation(
                                  <String, dynamic>{
                                    "input": {
                                      "email": "${_emailController.text}",
                                      "password": "${_passwordcontroller.text}",
                                    }
                                  },
                                );
                              } else {
                                final snackbar = SnackBar(
                                  content:
                                      Text('No Internet Services Available'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: snackbar));
                              }
                            } else {
                              setState(() {
                                isAutoValidate = true;
                              });
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: AppTheme.Colors.grey.withOpacity(0.3),
                            padding: EdgeInsets.symmetric(vertical: 17),
                            child: Container(
                                child: Center(child: Text(labels["login"]))),
                          ),
                        ),
                        // InkWell(
                        //   onTap: () async {
                        //     Map<String, dynamic> profile;
                        //     var facebookLoginResult =
                        //         await facebookLogin.logIn(['email']);

                        //     switch (facebookLoginResult.status) {
                        //       case FacebookLoginStatus.error:
                        //         Toast.showToast(context, "Error occur");
                        //         break;
                        //       case FacebookLoginStatus.cancelledByUser:
                        //         break;
                        //       case FacebookLoginStatus.loggedIn:
                        //         var graphResponse = await http.get(
                        //             'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult.accessToken.token}');

                        //         profile = json.decode(graphResponse.body);
                        //         print("Profile=====================$profile");

                        //         if (profile != null) {
                        //           fbEmail = "${profile['email'].toString()}";
                        //           LoadingDialouge()
                        //               .showLoadingDialog(context, 'Processing');
                        //           mutation(<String, dynamic>{
                        //             "input": {
                        //               "email": "${profile['email'].toString()}",
                        //               "password": "${profile['id']}"
                        //             }
                        //           });
                        //           break;
                        //         }
                        //     }
                        //   },
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //         image: DecorationImage(
                        //             image: AssetImage(
                        //                 'assets/images/facebookbg.png'),
                        //             fit: BoxFit.fill)),
                        //     padding: EdgeInsets.symmetric(vertical: 15),
                        //     child: Stack(
                        //       children: <Widget>[
                        //         Container(
                        //             margin: EdgeInsets.only(left: 35),
                        //             child: SvgPicture.asset(
                        //                 'assets/images/fb.svg')),
                        //         Center(
                        //             child: Container(
                        //           padding: EdgeInsets.symmetric(vertical: 5),
                        //           child: Text(
                        //             labels["fb_login"],
                        //             textAlign: TextAlign.center,
                        //             style: TextStyle(color: Colors.white),
                        //           ),
                        //         )),
                        //       ],
                        //     ),
                        //   ),
                        // ),

                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 40),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AboutOutfitters(
                                          name: "Privacy Policy",
                                          url:
                                              "https://outfitters.com.pk/pages/privacy-policy-mobile-app"),
                                      settings: RouteSettings(
                                          name: 'AboutOutfitters')));
                            },
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: [
                                TextSpan(
                                    text: labels["by_logging"],
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 12)),
                                TextSpan(
                                    text: labels["privacy_policy"],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        decoration: TextDecoration.underline))
                              ]),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20, top: 40),
                          child: Text(labels["new_customer"],
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 16)),
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context).push(
                              PageTransition(
                                  child: Signup(),
                                  type: PageTransitionType.leftToRight,
                                  settings:
                                      RouteSettings(name: 'Sign up Screen'))),
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            color: AppTheme.Colors.grey.withOpacity(0.3),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child:
                                Center(child: Text(labels["create_account"])),
                          ),
                        ),
                        widget.ischeckout
                            ? CheckoutGuest(items: widget.checkoutitems)
                            : SizedBox(
                                height: 0,
                              ),

                        InkWell(
                          onTap: () {
                            Alert(
                                context: context,
                                title: "Messaging Alerts",
                                content: Column(
                                  children: <Widget>[
                                    TextField(
                                      controller: _emailMessaging,
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.account_circle),
                                        labelText: 'Email',
                                      ),
                                    ),
                                  ],
                                ),
                                buttons: [
                                  DialogButton(
                                    onPressed: () async {
                                      final QuerySnapshot result =
                                          await FirebaseFirestore.instance
                                              .collection('alertEmails')
                                              .where('email',
                                                  isEqualTo:
                                                      _emailMessaging.text)
                                              .limit(1)
                                              .get();
                                      final List<DocumentSnapshot> documents =
                                          result.docs;

                                      documents.length == 1
                                          ? Toast.showToast(
                                              context, "Email already exist")
                                          : FirebaseFirestore.instance
                                              .collection("alertEmails")
                                              .doc()
                                              .set({
                                              // final databaseReference =
                                              //     FirebaseDatabase.instance.reference();
                                              // databaseReference
                                              //     .child("alertsEmail")
                                              //     .set({
                                              'email': _emailMessaging.text,
                                              "fcmToken": Token
                                            });
                                      _emailMessaging.clear;
                                      print(
                                          'alertsEmail : ${_emailMessaging.text}');

                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Get Alerts",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  )
                                ]).show();
                          },
                          child: Container(
                            margin:
                                EdgeInsets.only(left: 20, right: 10, top: 30),
                            child: Text("In App Messaging alerts",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 16)),
                          ),
                        ),

                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                          child: Divider(
                            height: 1,
                          ),
                        )
                      ],
                    ),
                  ),
                )));
      },
    );
  }
}
