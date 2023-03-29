import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:outfitters/UI/GraphQL/Query/GraphQlQueries.dart';
import 'package:outfitters/UI/Screens/ChangePassword.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyInformation extends StatefulWidget {
  @override
  _MyInformationState createState() => _MyInformationState();
}

class _MyInformationState extends State<MyInformation> {
  SharedPreferences sharedPreferences;

  dynamic labels;

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

  Future<String> accesTokenGet() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getString('accessToken').toString();
  }

  @override
  Widget build(BuildContext context) {
    return sharedPreferences == null
        ? Container()
        : Scaffold(
            body: Container(
                child: FutureBuilder<String>(
                    future: accesTokenGet(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Query(
                            options: QueryOptions(
                              document: gql(readProfileData),
                              // this is the query string you just created

                              variables: {
                                'customerAccessToken': snapshot.data,
                              },
                            ),
                            builder: (QueryResult result,
                                {VoidCallback refetch, FetchMore fetchMore}) {
                              if (result.hasException) {
                                return Text(result.exception.toString());
                              }

                              if (result.isLoading) {
                                return Container(
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ));
                              }
                              return Scaffold(
                                appBar: AppBar(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  centerTitle: true,
                                  automaticallyImplyLeading: true,
                                  elevation: 2,
                                  title: Column(
                                    children: <Widget>[
                                      Text(
                                        labels["my_info"],
                                        style: AppTheme.TextTheme.titlebold,
                                      ),
                                      Text(
                                        result.data['customer']['email'] == null
                                            ? ""
                                            : result.data['customer']['email'],
                                        style: AppTheme.TextTheme.smalltext,
                                      )
                                    ],
                                  ),
                                ),
                                body: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 15),
                                        child: Text(
                                          labels["personal_details"],
                                          style: AppTheme.TextTheme.boldText,
                                        ),
                                      ),
                                      InkWell(
                                        // onTap: () => Navigator.of(context).push(
                                        //     PageTransition(
                                        //         child: MainAddress(),
                                        //         type: PageTransitionType
                                        //             .leftToRight)),
                                        child: Container(
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              border: Border(
                                                  top: BorderSide(
                                                      width: 0.3,
                                                      color: Colors.grey),
                                                  bottom: BorderSide(
                                                      width: 0.3,
                                                      color: Colors.grey))),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: Center(
                                              child: Text(
                                                  labels["add_main_address"],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color: Colors.black))),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => Navigator.of(context).push(
                                          PageTransition(
                                              child: ChangePasswordScreen(),
                                              type: PageTransitionType
                                                  .leftToRight,
                                              settings: RouteSettings(
                                                  name:
                                                      'Change Password screen')),
                                        ),
                                        child: Container(
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              border: Border(
                                                  top: BorderSide(
                                                      width: 0.3,
                                                      color: Colors.grey),
                                                  bottom: BorderSide(
                                                      width: 0.3,
                                                      color: Colors.grey))),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: Center(
                                              child: Text(labels["change_pass"],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color: Colors.black))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      } else {
                        return Container();
                      }
                    })));
  }
}
