import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:outfitters/Models/ProductsModel.dart';
import 'package:outfitters/UI/GraphQL/Query/GraphQlQueries.dart';
import 'package:outfitters/UI/Screens/ProductDetails.dart';
import 'package:outfitters/UI/Widgets/LoadingAnimation.dart';
import 'package:outfitters/UI/Widgets/PhotoItem.dart';
import 'package:page_transition/page_transition.dart';

class WearWithProducts extends StatefulWidget {
  final taglist;
  WearWithProducts({@required this.taglist}) : assert(taglist != null);
  @override
  _WearWithProductsState createState() => _WearWithProductsState();
}

class _WearWithProductsState extends State<WearWithProducts> {
  List<String> tags = [];

  @override
  void initState() {
    widget.taglist.forEach((data) {
      // if (data.contains("Ritem")) {
      tags.add(data);
      // }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return tags.length > 0 && tags != null
        ? Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Wear With',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    Container(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                            splashColor: Colors.grey.withOpacity(0.7),
                            onTap: () {
                              setState(() {});
                            },
                            child: Icon(
                              Icons.refresh,
                              size: 18,
                              color: Colors.grey,
                            )),
                      ),
                    )
                  ],
                ),
              ),
              Query(
                  options: QueryOptions(
                    document: gql(
                        getproductsfromtags), // this is the query string you just created
                    variables: {
                      'Tag': fetchtags(tags),
                    },
                  ),
                  builder: (QueryResult result,
                      {VoidCallback refetch, FetchMore fetchMore}) {
                    if (result.hasException) {
                      return Text(result.exception.toString());
                    }

                    if (result.isLoading) {
                      return Container(
                          child: Center(child: LoadingAnimation()));
                    }

                    ProductModel productModel =
                        ProductModel.fromJson(result.data);

                    return Container(
                      height: 120,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: productModel.products.productedges.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      height: 100,
                                      width: 80,
                                      child: PhotoItem(
                                          imageUrl: productModel
                                              .products
                                              .productedges[index]
                                              .productnode
                                              .images
                                              .imagesedges
                                              .first
                                              .imagesnode
                                              .src)),
                                  Container(
                                    padding: EdgeInsets.only(top: 3),
                                    child: Center(
                                      child: Text(
                                        'PKR ${productModel.products.productedges[index].productnode.variants.variantedges.first.variantnode.price}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
            ],
          )
        : SizedBox();
  }

  String fetchtags(var data) {
    List<String> tags = [];
    data.forEach((data) async {
      tags.add('tag:$data');
    });

    return tags.join(' OR ');
  }
}
