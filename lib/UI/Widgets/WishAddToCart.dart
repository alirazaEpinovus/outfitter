import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:outfitters/Database/DatabaseHelper.dart';
import 'package:outfitters/Models/ProductsModel.dart';
import 'package:outfitters/UI/GraphQL/Query/GraphQlQueries.dart';
import 'package:outfitters/UI/Notifiers/CartNotifier.dart';
import 'package:outfitters/UI/Notifiers/ConnectionNotifier.dart';
import 'package:outfitters/UI/Widgets/ToastClass.dart';
import 'package:provider/provider.dart';

class WishAddToCart extends StatefulWidget {
  final String id;
  WishAddToCart({this.id});
  @override
  _WishAddToCartState createState() => _WishAddToCartState();
}

class _WishAddToCartState extends State<WishAddToCart> {
  final database = DatabaseHelper.instance;
  int selectedIndex;
  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    return connectionStatus != ConnectivityStatus.Offline
        ? Query(
            options: QueryOptions(
                document: gql(
                    productfetch), // this is the query string you just created
                variables: {"productid": widget.id}),
            builder: (QueryResult result,
                {VoidCallback refetch, FetchMore fetchMore}) {
              if (result.isLoading && result.data == null) {
                return Container(
                    height: 100,
                    child: Center(child: CircularProgressIndicator()));
              }

              if (result.hasException) {
                return Text('Something went wrong.');
              }

              if (result.data == null && result.exception == null) {
                return const Text('Both data and errors are null');
              }
              if (result.data == null) {
                return Text('No data found');
              }
              Productnode productnode =
                  Productnode.fromJson(result.data['node']);
              List<Variantnode> productlist = [];
              productnode.variants.variantedges.forEach((data) {
                if (data.variantnode.available) {
                  productlist.add(data.variantnode);
                }
              });
              if (productlist.length == 0) {
                return Container(
                    height: 170,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/sadface.svg',
                          height: 130,
                          width: 130,
                        ),
                        Text(
                          'Sorry! the item is sold out now.',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ],
                    ));
              }
              return Container(
                  height: (productlist.length).toDouble() * 40,
                  child: Container(
                    child: Column(
                        children: List.generate(
                            productlist.length,
                            (indexItem) => Stack(
                                  children: <Widget>[
                                    if (productlist[indexItem].available)
                                      InkWell(
                                        onTap: () {
                                          selectedIndex = indexItem;
                                          if (mounted) setState(() {});
                                        },
                                        child: Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.5),
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors.grey,
                                                        width: 1))),
                                            child: Text(
                                                '${productlist[indexItem].selectedOptions[1].value}')),
                                      ),
                                    selectedIndex == indexItem
                                        ? Container(
                                            width: double.infinity,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    addtoCartItem(productnode,
                                                        productlist[indexItem]);
                                                  },
                                                  child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 12,
                                                              horizontal: 10),
                                                      decoration: BoxDecoration(
                                                          color: Colors.black),
                                                      child: Text(
                                                        'ADD To Cart',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          )
                                        : SizedBox(),
                                  ],
                                ))),
                  ));
            })
        : Container(
            height: 170,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/connection.svg',
                  height: 130,
                  width: 130,
                ),
                Text(
                  'Please check your internet settings',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ],
            ));
  }

  addtoCartItem(Productnode productnode, Variantnode variantnode) {
    Map<String, dynamic> row = {
      'graphid': variantnode.id,
      'p_name': productnode.title,
      'p_id': productnode.id,
      'p_color': variantnode.selectedOptions[0].value,
      'p_size': variantnode.selectedOptions.contains("Size")
          ? (variantnode.selectedOptions[1].value == "WS-20" ||
                  variantnode.selectedOptions[1].name == "Season"
              ? variantnode.selectedOptions[2].value
              : variantnode.selectedOptions[1].value)
          : variantnode.selectedOptions[1].value,
      'varient_id': variantnode.id,
      'p_image': productnode.images.imagesedges.first.imagesnode.src,
      'price': variantnode.price,
      'quantity': 1,
      'compare_price': variantnode.compareAtPrice,
      'sku': variantnode.sku
    };
    database.insert(row, context).then((val) {
      Navigator.of(context).pop();
      // Toast.showToast(context, 'Add to Cart Successfully!');

      Provider.of<CartNotifier>(context, listen: false).getcart();
    });
  }
}
