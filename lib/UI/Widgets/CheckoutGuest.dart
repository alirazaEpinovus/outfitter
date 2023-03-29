import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:outfitters/UI/GraphQL/Mutation/mutationQueries.dart';
import 'package:outfitters/UI/Screens/WebViewCheckouts.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;

class CheckoutGuest extends StatelessWidget {
  final items;
  CheckoutGuest({@required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Text('As a Guest',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          ),
          Mutation(
              options: MutationOptions(
                  document: gql(checkoutmutationwithemail),
                  onError: (OperationException error) {
                    Navigator.of(context).pop();
                    AlertDialog();
                  },
                  onCompleted: (dynamic resultData) {
                    Navigator.of(context).pop();
                    if (resultData['checkoutCreate']['checkout']['webUrl'] !=
                        null) {
                      Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  WebViewCheckouts(
                                    weburl: resultData['checkoutCreate']
                                        ['checkout']['webUrl'],
                                  ),
                              settings:
                                  RouteSettings(name: 'Checkout Screen')));
                    }
                  }),
              builder: (RunMutation runMutation, QueryResult result) {
                return InkWell(
                  onTap: () {
                    runMutation(<String, dynamic>{"Checkoutitems": items});
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    color: AppTheme.Colors.grey.withOpacity(0.3),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: Text('Checkout as a Guest')),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
