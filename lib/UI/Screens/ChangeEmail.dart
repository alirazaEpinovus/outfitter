import 'package:flutter/material.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;

class ChangeEmail extends StatefulWidget {
  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  FocusNode _passwordNode = FocusNode();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: Text(
          'Change email',
          style: AppTheme.TextTheme.titlebold,
        ),
        elevation: 1,
        actions: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Center(
                  child: Text(
                'Ok',
              )))
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20, left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: Text('Password')),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextFormField(
                        textInputAction: TextInputAction.next,
                        focusNode: _passwordNode,
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Password Field is empty';
                          } else {
                            return null;
                          }
                        },
                        cursorColor: Colors.black,
                        obscureText: true,
                        // validator:
                        onSaved: (value) {
                          //password = value;
                        },
                        onFieldSubmitted: (terms) {
                          _passwordNode.unfocus();
                        },
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.black),
                          suffix: passwordController.text.isNotEmpty
                              ? GestureDetector(
                                  onTap: () => passwordController.clear(),
                                  child: Icon(Icons.clear))
                              : SizedBox(),
                        )),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
