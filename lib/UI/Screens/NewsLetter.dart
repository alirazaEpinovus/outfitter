import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:outfitters/UI/GraphQL/Mutation/mutationQueries.dart';
import 'package:outfitters/UI/Notifiers/ConnectionNotifier.dart';
import 'package:outfitters/UI/Widgets/ToastClass.dart';
import 'package:outfitters/UI/Widgets/loadingDialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsLetter extends StatefulWidget {
  @override
  _NewsLetterState createState() => _NewsLetterState();
}

class _NewsLetterState extends State<NewsLetter> {
  TextEditingController _emailController = TextEditingController();
  String email;
  FocusNode _emailNode = FocusNode();
  SharedPreferences sharedPreferences;
  final _formKey = GlobalKey<FormState>();
  bool isAutoValidate = false;
  dynamic labels;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  loadValues() async {
    sharedPreferences = await SharedPreferences.getInstance();
    labels = json.decode(sharedPreferences.getString("labels"));

    setState(() {});
  }

  @override
  void initState() {
    loadValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var connection = Provider.of<ConnectivityStatus>(context);
    return Container(
      child: Mutation(
          options: MutationOptions(
              document: gql(newLetterSubcribe),
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
                              style:
                                  TextStyle(fontSize: 12, color: Colors.red)),
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
                Navigator.of(context).pop();
                if (resultData.data['customerCreate']['customer'] != null) {
                  Toast.showToast(context, " You are successfully Subscribe.");
                  _emailController.clear();
                } else {
                  Toast.showToast(
                    context,
                    resultData.data['customerCreate']['customerUserErrors']
                        .first['message'],
                  );
                }
              }),
          builder: (RunMutation mutation, QueryResult result) {
            return Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 4,
                  centerTitle: true,
                  title: InkWell(
                    child: Text(
                      'Newsletter',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  leading: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                  automaticallyImplyLeading: false,
                  iconTheme: IconThemeData(
                    color: Colors.black,
                  ),
                  // actions: <Widget>[
                  //   InkWell(
                  //     onTap: (){

                  //     },
                  //                 child: Container(
                  //       width: 90,
                  //       padding: EdgeInsets.only(right: 20, left: 20),
                  //       alignment: Alignment.centerRight,
                  //       child: Container(
                  //         child: Text(
                  //           labels["save"],
                  //           style: TextStyle(
                  //               color: Colors.black,
                  //               fontWeight: FontWeight.w400,
                  //               fontSize: 15),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ],
                ),
                body: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          'This is where you can manage your subscription to our newsletter',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w400,
                              fontSize: 15),
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                                // padding: EdgeInsets.only(left: 10),
                                width: MediaQuery.of(context).size.width - 40,
                                child: TextFormField(
                                    textInputAction: TextInputAction.done,
                                    focusNode: _emailNode,
                                    validator: (value) {
                                      Pattern pattern =
                                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                      RegExp regex = new RegExp(pattern);
                                      if (value.trim().isEmpty ||
                                          !regex.hasMatch(value)) {
                                        return 'Please enter valid email address';
                                      }
                                      return null;
                                    },
                                    onFieldSubmitted: (term) {
                                      _emailNode.unfocus();
                                    },
                                    controller: _emailController,
                                    keyboardType: TextInputType.text,
                                    decoration: new InputDecoration(
                                      hintText: 'Email',
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: Color(0xFFA2A2A2),
                                        fontSize: 13,
                                        fontStyle: FontStyle.normal,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 2.0, horizontal: 10.0),
                                      suffix: _emailController.text.isNotEmpty
                                          ? GestureDetector(
                                              onTap: () =>
                                                  _emailController.clear(),
                                              child: Icon(Icons.clear))
                                          : SizedBox(),
                                    )))
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 5, left: 5, right: 5),
                        color: Colors.grey[500],
                        height: 1,
                      ),
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            if (connection != ConnectivityStatus.Offline) {
                              LoadingDialouge()
                                  .showLoadingDialog(context, 'Processing...');
                              mutation(
                                <String, dynamic>{
                                  "input": {
                                    "email": "${_emailController.text}",
                                    "password": "${_emailController.text}",
                                    "acceptsMarketing": true,
                                  }
                                },
                              );
                            } else {
                              showInSnackBar('No Internet Services Available');
                            }
                          } else {
                            setState(() => isAutoValidate = true);
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context).primaryColorLight,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            'Subscribe',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30, bottom: 10),
                        child: Text(
                          'Subscribe to our newsletter and be the first to receive the latest fashion news, promotions and more!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w400,
                              fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
}
