import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:outfitters/Utils/loadinganimation.dart';

class PaginationLoadingWidget extends StatelessWidget {
  final QueryResult queryResult;

  PaginationLoadingWidget({@required this.queryResult});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 0,
        child: AnimatedContainer(
            duration: Duration(milliseconds: 400),
            child: queryResult.isLoading && queryResult != null
                ? Container(
                    // height: 80,
                    padding: EdgeInsets.only(top: 4, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        LoadingAnimation(),
                        Text(
                          'Loading...',
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ))
                : Container()));
  }
}
