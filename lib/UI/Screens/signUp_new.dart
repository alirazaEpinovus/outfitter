import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:outfitters/UI/GraphQL/Mutation/mutationQueries.dart';
import 'package:outfitters/UI/Notifiers/ConnectionNotifier.dart';
import 'package:outfitters/UI/Screens/AboutOutfitters.dart';
import 'package:outfitters/UI/Widgets/ToastClass.dart';
import 'package:outfitters/UI/Widgets/loadingDialog.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';
import 'package:outfitters/UI/Screens/Signin.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;

class SignupNew extends StatefulWidget {
  @override
  _SignupNewState createState() => _SignupNewState();
}

class _SignupNewState extends State<SignupNew> {
  // FacebookLogin facebookLogin = FacebookLogin();
  double screenwidth, screenheight;
  Size size;
  String email;
  String password;
  String confrimPassword;
  bool passwordVisibility = true;
  bool conformpasswordVisibility = true;
  bool passwordshow = false;
  bool privacypolicycheck = false;
  bool latetsNewscheck = false;
  bool isAutoValidate = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  TextEditingController _confirmPasswordcontroller = TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  FocusNode _emailNode = FocusNode();
  FocusNode _passwordNode = FocusNode();
  FocusNode _confirmPasswordNode = FocusNode();
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
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    size = MediaQuery.of(context).size;
    // screenheight = size.height;
    screenwidth = size.width;
    return Container(
      child: Mutation(
        options: MutationOptions(
          document: gql(signUp),
          update: (cache, QueryResult result) {
            if (result.hasException) {
            } else {}
          },
          onError: (OperationException error) {
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
          onCompleted: (dynamic resultData) {
            if (resultData.data['customerCreate']['customer'] != null) {
              Navigator.of(context).pushReplacement(PageTransition(
                child: SignIn(
                  checkoutitems: [],
                  ischeckout: false,
                ),
                type: PageTransitionType.leftToRight,
              ));
              Toast.showToast(context, " You are successfully Signup");
              LoadingDialouge().showLoadingDialog(context, 'Processing...');
            } else {
              Toast.showToast(
                context,
                resultData.data['customerCreate']['customerUserErrors']
                    .first['message'],
              );
            }
          },
        ),
        builder: (RunMutation mutation, QueryResult result) {
          return sharedPreferences == null
              ? Container()
              : Scaffold(
                  key: _scaffoldKey,
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    automaticallyImplyLeading: false,
                    centerTitle: true,
                    elevation: 1,
                    leading: Center(
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 5, top: 20, bottom: 20),
                          child: Text(
                            labels["cancel"],
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      labels["create_account"],
                      style: AppTheme.TextTheme.boldText,
                    ),
                    actions: <Widget>[
                      InkWell(
                        onTap: () async {
                          if (_formKey.currentState.validate()) {
                            if (password == confrimPassword) {
                              if (privacypolicycheck) {
                                if (connectionStatus !=
                                    ConnectivityStatus.Offline) {
                                  mutation(
                                    <String, dynamic>{
                                      "input": {
                                        "email": "${_emailController.text}",
                                        "password":
                                            "${_passwordcontroller.text}",
                                        "acceptsMarketing": latetsNewscheck,
                                        //  "acceptsMarketingUpdatedAt":latetsNewscheck
                                      }
                                    },
                                  );
                                } else {
                                  showInSnackBar(
                                      'No Internet Services Available');
                                }
                              } else {
                                showInSnackBar(
                                    'Accepts our terms and conditions');
                              }
                            } else {
                              showInSnackBar('Password is not same');
                            }
                          } else {
                            setState(() {
                              isAutoValidate = true;
                            });
                          }
                        },
                        child: Container(
                          width: 90,
                          padding: EdgeInsets.only(right: 25, left: 20),
                          alignment: Alignment.centerRight,
                          child: Container(
                            child: Text(
                              labels["save"],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  body: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.always,
                        child: Column(
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.only(left: 10),
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
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
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: new InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      hintText: "EMAIL",
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
                            Container(
                                padding: EdgeInsets.only(left: 10),
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    cursorColor: Colors.black,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: new InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      hintText: "USER NAME",
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
                            Container(
                                padding: EdgeInsets.only(left: 10),
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    cursorColor: Colors.black,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: new InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      hintText: "PASSWORD",
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
                            Container(
                                padding: EdgeInsets.only(left: 10),
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    cursorColor: Colors.black,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: new InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      hintText: "CONFIRM PASSWORD",
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
                            Container(
                                padding: EdgeInsets.only(left: 10),
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    cursorColor: Colors.black,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: new InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      hintText: "Mobile Number",
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
                            Container(
                                padding: EdgeInsets.only(left: 10),
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    cursorColor: Colors.black,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: new InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      hintText: "DATE OF BIRTH",
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
                            Container(
                                padding: EdgeInsets.only(left: 10),
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    cursorColor: Colors.black,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: new InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      hintText: "ADDRESS",
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
                            Container(
                                padding: EdgeInsets.only(left: 10),
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    cursorColor: Colors.black,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: new InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      hintText: "CITY",
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
                            Container(
                                padding: EdgeInsets.only(left: 10),
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    cursorColor: Colors.black,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: new InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      hintText: "POSTAL CODE",
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

                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 8),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(labels["latest_news"],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              letterSpacing: 0.5)),
                                      Container(
                                        child: Checkbox(
                                          checkColor: Colors.white,
                                          value: latetsNewscheck,
                                          onChanged: (bool newValue) {
                                            setState(() {
                                              latetsNewscheck = newValue;
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AboutOutfitters(
                                                            name:
                                                                "Privacy Policy",
                                                            url:
                                                                "https://outfitters.com.pk/pages/privacy-policy-mobile-app"),
                                                    settings: RouteSettings(
                                                        name:
                                                            'AboutOutfitters')));
                                          },
                                          child: Container(
                                              child: RichText(
                                            textAlign: TextAlign.left,
                                            text: TextSpan(children: [
                                              TextSpan(
                                                  text: labels["accept"],
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      letterSpacing: 0.5)),
                                              TextSpan(
                                                  text:
                                                      labels["privacy_policy"],
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      letterSpacing: 0.5,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ]),
                                          )),
                                        ),
                                        Container(
                                          child: Checkbox(
                                            checkColor: Colors.white,
                                            value: privacypolicycheck,
                                            onChanged: (bool newValue) {
                                              setState(() {
                                                privacypolicycheck = newValue;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
                            //         // ShowToast.showToastInBottam(
                            //         //     context, 'Cancel by user');
                            //         break;
                            //       case FacebookLoginStatus.loggedIn:
                            //         var graphResponse = await http.get(
                            //             'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult.accessToken.token}');

                            //         profile = json.decode(graphResponse.body);
                            //         if (profile != null) {
                            //           LoadingDialouge().showLoadingDialog(
                            //               context, 'Processing');
                            //           mutation(<String, dynamic>{
                            //             "input": {
                            //               "email": "${profile['email']}",
                            //               "password": "${profile['id']}",
                            //               "acceptsMarketing": true,
                            //               //  "acceptsMarketingUpdatedAt":latetsNewscheck
                            //             }
                            //           });

                            //           break;
                            //         }
                            //     }
                            //   },
                            //   child: Container(
                            //     margin: EdgeInsets.only(top: 10),
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
                            //           padding:
                            //               EdgeInsets.symmetric(vertical: 5),
                            //           child: Text(
                            //             "Register with Facebook",
                            //             textAlign: TextAlign.center,
                            //             style: TextStyle(color: Colors.white),
                            //           ),
                            //         )),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
}
