import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQlHelper {
  static HttpLink httpLink = HttpLink(
    'https://outfitterspk.myshopify.com/api/2019-07/graphql',
    defaultHeaders: <String, String>{
      'X-Shopify-Storefront-Access-Token': '75e049669db9a451ebba44c7a193b3f1',
      'Accept': 'application/json'
    },
  );
  static Link linke = httpLink;
  ValueNotifier<GraphQLClient> client = ValueNotifier(GraphQLClient(
    cache: GraphQLCache(),
    link: linke,
  ));

  GraphQLClient clientToQuery() {
    return GraphQLClient(link: linke, cache: GraphQLCache());
  }
}
