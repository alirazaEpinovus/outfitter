import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:outfitters/Database/DatabaseHelper.dart';
import 'package:outfitters/Models/ProductsModel.dart';
import 'package:outfitters/UI/GraphQL/Query/GraphQlQueries.dart';
import 'package:outfitters/UI/Widgets/CartIconWidget.dart';
import 'package:outfitters/UI/Widgets/ErrorState.dart';
import 'package:outfitters/UI/Widgets/LoadingAnimation.dart';
import 'package:outfitters/UI/Widgets/ProductCartWidget.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;

class ProductDetailsCart extends StatefulWidget {
  final productId, cValue;
  ProductDetailsCart({@required this.productId, @required this.cValue})
      : assert(productId != null);
  @override
  _ProductDetailsCartState createState() =>
      _ProductDetailsCartState(this.productId);
}

class _ProductDetailsCartState extends State<ProductDetailsCart> {
  final productId;
  _ProductDetailsCartState(this.productId);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Query(
            options:
                QueryOptions(document: gql(readProductDetails), variables: {
              "ProductId": productId,
            }),
            builder: (QueryResult result, {refetch, FetchMore fetchMore}) {
              if (result.isLoading && result.data == null) {
                return Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: LoadingAnimation());
              }
              if (result.data == null && result.hasException == null) {
                return ErrorState();
              }

              if (result.data == null) {
                return Center(
                    child: Container(
                  child: Text("No result Found"),
                ));
              }
              if (result.data['node'].length == 0) {
                return Center(child: Text('Empty Collecton'));
              }
              Productnode productDetails =
                  Productnode.fromJson(result.data['node']);

              return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    centerTitle: true,
                    elevation: 2,
                    leading: InkWell(
                        onTap: () => Navigator.pop(context, true),
                        child: Icon(Icons.arrow_back_ios)),
                    title: Text(
                      result.data['node']['title'],
                      style: AppTheme.TextTheme.smallboldText,
                    ),
                    actions: <Widget>[CartIconWidget()],
                  ),
                  body: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: ProductCartWidget(
                          productDetails: productDetails,
                          cValue: widget.cValue)));
            }));
  }
}
