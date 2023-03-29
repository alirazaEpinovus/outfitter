import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:outfitters/UI/GraphQL/Mutation/mutationQueries.dart';
import 'package:outfitters/UI/Notifiers/ConnectionNotifier.dart';
import 'package:outfitters/UI/Widgets/ToastClass.dart';
import 'package:outfitters/UI/Widgets/loadingDialog.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  FocusNode _emailNode = FocusNode();
  TextEditingController _emailController = TextEditingController();
  bool isValidate = false;

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 1,
        title: Text(
          'Reset Password',
          style: AppTheme.TextTheme.titlebold,
        ),
      ),
      body: SingleChildScrollView(
        child: Mutation(
            options: MutationOptions(
                document: gql(resetPassword),
                update: (cache, QueryResult result) {
                  if (result.hasException) {
                  } else {}
                },
                onError: (OperationException error) {
                  showDialog<AlertDialog>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Center(
                          child: Text(
                            error.graphqlErrors.first.message,
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(15)),
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
                  Future.delayed(Duration(seconds: 2)).whenComplete(() {
                    resultData.data['customerRecover']['customerUserErrors'] !=
                            null
                        ? Toast.showToast(context, "Email has sent Successfull")
                        : Toast.showToast(
                            context,
                            resultData
                                .data['customerRecover']['customerUserErrors']
                                .first['message']
                                .toString());
                    // Navigator.pop(context);
                  });
                }),
            builder: (RunMutation mutation, QueryResult result) {
              return Container(
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            focusNode: _emailNode,
                            validator: (value) {
                              Pattern pattern =
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              RegExp regex = new RegExp(pattern);
                              if (value.trim().isEmpty ||
                                  !regex.hasMatch(value)) {
                                return 'Please enter valid email address';
                              } else {
                                return null;
                              }
                            },
                            cursorColor: Colors.black,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  print('length is ${value.length}');
                                });
                              }
                            },

                            // validator:
                            onSaved: (value) {
                              //password = value;
                            },
                            onFieldSubmitted: (term) {
                              _emailNode.unfocus();
                            },
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: new InputDecoration(
                              hintText: "Email",
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Color(0xFFA2A2A2),
                                fontSize: 14,
                                fontStyle: FontStyle.normal,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 10.0),
                              suffix: _emailController.text.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () => _emailController.clear(),
                                      child: Icon(Icons.clear))
                                  : SizedBox(),
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            if (connectionStatus !=
                                ConnectivityStatus.Offline) {
                              LoadingDialouge()
                                  .showLoadingDialog(context, 'Processing...');
                              Navigator.pop(context);
                              mutation(
                                <String, dynamic>{
                                  "email": "${_emailController.text}",
                                },
                              );
                            } else {
                              Toast.showToast(
                                  context, 'No Internet Connection Available');
                            }
                          } else {
                            setState(() {
                              isValidate = true;
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 17),
                          decoration: BoxDecoration(
                              color: AppTheme.Colors.grey.withOpacity(0.3),
                              border: Border.all(
                                  color: AppTheme.Colors.grey, width: 0.5)),
                          child: Center(child: Text('Send')),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
