import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:outfitters/Models/ProductsModel.dart';
import 'package:outfitters/UI/GraphQL/Query/GraphQlQueries.dart';
import 'package:outfitters/UI/Screens/Collections.dart';
import 'package:outfitters/UI/Widgets/CartIconWidget.dart';
import 'package:outfitters/UI/Widgets/EmptyState.dart';
import 'package:outfitters/UI/Widgets/ErrorState.dart';
import 'package:outfitters/UI/Widgets/LoadingAnimation.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;
import 'package:outfitters/UI/Widgets/ProductWidget.dart';

class SearchProducts extends StatefulWidget {
  final String collectionName;
  final String selected;
  final List subColList;
  final String shopifyId;
  final String name;
  final filterx;
  final String sorting;
  final bool isFilters;
  final List imgx;
  SearchProducts(
      {this.collectionName,
      this.selected,
      this.shopifyId,
      this.sorting,
      this.isFilters,
      this.filterx,
      this.name,
      this.subColList,
      this.imgx});
  @override
  _SearchProductsState createState() => _SearchProductsState();
}

class _SearchProductsState extends State<SearchProducts> {
  final formKey = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();
  FocusNode searchNode = FocusNode();
  String searchProductStr;
  ScrollController _scrollController = new ScrollController();
  ProductModel productModel;
  // List<Productedges> filterProducts;
  var abc;
  int index = 0;
  bool search = false;
  String selectedValue;
  bool value = false;
  String selectedVal;
  int findout = 0;
  @override
  void initState() {
    searchNode.requestFocus();
    // filterProducts = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: value,
        centerTitle: true,
        title: value
            ? Text(
                "$selectedVal",
                style: AppTheme.TextTheme.boldText,
              )
            : InkWell(
                onTap: () {
                  index = 0;
                  if (widget.collectionName != null) {
                    Navigator.pop(context);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => Collections(
                              sorting: widget.sorting,
                              selected: widget.selected,
                              subColList: widget.subColList,
                              shopifyId: widget.shopifyId,
                              name: widget.name,
                              filterx: widget.filterx,
                              isFilters: widget.isFilters,
                              imgx: widget.imgx,
                            ),
                        settings:
                            RouteSettings(name: 'Nested Collection Screen')));
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: SvgPicture.asset(
                  'assets/images/logo.svg',
                  height: 35,
                  width: 130,
                ),
              ),
        actions: <Widget>[CartIconWidget()],
      ),
      body: Flex(
        direction: Axis.vertical,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Form(
            key: formKey,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.79,
                    height: 35,

                    // margin: EdgeInsets.only(bottom: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(6)),

                    child: TextFormField(
                      controller: searchController,
                      onChanged: (val) {
                        setState(() {
                          searchProductStr = val;
                          abc = val.replaceAll(RegExp("\\ "), '-');
                          search = false;
                        });
                      },
                      onFieldSubmitted: (val) {
                        setState(() {
                          value = true;
                          selectedVal = val;
                          searchController = TextEditingController();
                          search = true;

                          searchProductStr = val;
                          abc = val.replaceAll(RegExp("\\ "), '-');
                        });
                      },
                      focusNode: searchNode,
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(3.0, 4.0, 5.0, 15.0),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[500],
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        index = 0;
                        if (widget.collectionName != null) {
                          Navigator.pop(context);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => Collections(
                                        sorting: widget.sorting,
                                        selected: widget.selected,
                                        subColList: widget.subColList,
                                        shopifyId: widget.shopifyId,
                                        name: widget.name,
                                        filterx: widget.filterx,
                                        isFilters: widget.isFilters,
                                        imgx: widget.imgx,
                                      ),
                                  settings: RouteSettings(
                                      name: 'Nested Collection Screen')));
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text('Cancel')))
                ],
              ),
            ),
          ),
          searchProductStr != null && search == false
              ? Flexible(
                  flex: 35,
                  child: Query(
                      options: QueryOptions(
                          document: gql(
                              searchProducts), // this is the query string you just created
                          variables: widget.collectionName != null
                              ? {
                                  'Search':
                                      "(tag:$abc OR title:$abc*) AND ${widget.collectionName}"
                                }
                              : {'Search': "tag:$abc OR title:$abc*"}),
                      builder: (QueryResult result,
                          {VoidCallback refetch, FetchMore fetchMore}) {
                        if (result.isLoading && result.data == null) {
                          return Container(
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.75,
                              child: LoadingAnimation());
                        }
                        if (result.hasException) {
                          return ErrorState();
                        }

                        if (result.data == null && result.exception == null) {
                          return ErrorState();
                        }
                        if (result.data == null) {
                          return EmptyState();
                        }

                        if (result.data['products']['edges'].length > 0) {
                          productModel = ProductModel.fromJson(result.data);
                          final String fetchMoreCursor =
                              productModel.products.productedges.last.cursor;

                          FetchMoreOptions opts = FetchMoreOptions(
                            variables: {'cursor': fetchMoreCursor},
                            updateQuery:
                                (previousResultData, fetchMoreResultData) {
                              final List<dynamic> repos = [
                                ...previousResultData['products']['edges']
                                    as List<dynamic>,
                                ...fetchMoreResultData['products']['edges']
                                    as List<dynamic>
                              ];

                              fetchMoreResultData['products']['edges'] = repos;

                              return fetchMoreResultData;
                            },
                          );

                          _scrollController
                            ..addListener(() {
                              index = 0;
                              if (_scrollController.offset >=
                                      _scrollController
                                          .position.maxScrollExtent &&
                                  !_scrollController.position.outOfRange) {
                                if (!result.isLoading) {
                                  if (productModel
                                      .products.pageInfo.hasNextPage) {
                                    fetchMore(opts);
                                  } else {
                                    print("No more Product");
                                  }
                                }
                              }
                            });
                          return Container(
                            child: ListView(
                                controller: _scrollController,
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                children: productModel.products.productedges
                                    .where((element) =>
                                        element.productnode.availableForSale ==
                                        true)
                                    .map<Widget>((item) {
                                  return InkWell(
                                      onTap: () {
                                        setState(() {});
                                        value = true;
                                        selectedVal = item.productnode.title;
                                        searchController =
                                            TextEditingController();
                                        search = true;
                                        abc = item.productnode.title
                                            .replaceAll(RegExp("\\ "), '-');
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                      },
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              // color: Colors.grey[50],
                                              margin: EdgeInsets.all(7),
                                              padding: EdgeInsets.all(7),
                                              child: Text(item.productnode.title
                                                  .toString()),
                                            ),
                                            Container(
                                              color: Colors.grey[300],
                                              height: 1,
                                            ),
                                          ]));
                                }).toList()),
                          );
                        } else {
                          return EmptyState();
                        }
                      }),
                )
              : SizedBox(),
          searchProductStr != null && search == true
              ? Flexible(
                  flex: 35,
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Query(
                        options: QueryOptions(
                            document: gql(
                                searchProducts), // this is the query string you just created
                            variables: widget.collectionName != null
                                ? {
                                    'Search':
                                        "(tag:$abc OR title:$abc*) AND ${widget.collectionName}"
                                  }
                                : {'Search': "tag:$abc OR title:$abc*"}),
                        builder: (QueryResult result,
                            {VoidCallback refetch, FetchMore fetchMore}) {
                          if (result.isLoading && result.data == null) {
                            return Container(
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.75,
                                child: LoadingAnimation());
                          }

                          if (result.hasException) {
                            return ErrorState();
                          }

                          if (result.data == null && result.exception == null) {
                            return ErrorState();
                          }
                          if (result.data == null) {
                            return EmptyState();
                          }

                          if (result.data['products']['edges'].length > 0) {
                            productModel = ProductModel.fromJson(result.data);

                            if (productModel.products.pageInfo.hasNextPage) {
                              final String fetchMoreCursor = productModel
                                  .products.productedges.last.cursor;

                              FetchMoreOptions opts = FetchMoreOptions(
                                variables: {'cursor': fetchMoreCursor},
                                updateQuery:
                                    (previousResultData, fetchMoreResultData) {
                                  final List<dynamic> repos = [
                                    ...previousResultData['products']['edges']
                                        as List<dynamic>,
                                    ...fetchMoreResultData['products']['edges']
                                        as List<dynamic>
                                  ];

                                  fetchMoreResultData['products']['edges'] =
                                      repos;

                                  return fetchMoreResultData;
                                },
                              );

                              _scrollController
                                ..addListener(() {
                                  double maxScroll = _scrollController
                                      .position.maxScrollExtent;
                                  double currentScroll =
                                      _scrollController.position.pixels;
                                  double delta = 200.0; // or something else..
                                  if (maxScroll - currentScroll <= delta) {
                                    if (productModel
                                        .products.pageInfo.hasNextPage) {
                                      fetchMore(opts);
                                    }
                                  }
                                });
                            }
                            return Container(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: SingleChildScrollView(
                                  controller: _scrollController,
                                  child: Wrap(children: [
                                    for (int ind = 0;
                                        ind <
                                            productModel
                                                .products.productedges.length;
                                        ind++)
                                      for (int index = 0;
                                          index <
                                              productModel
                                                  .products
                                                  .productedges[ind]
                                                  .productnode
                                                  .options
                                                  .first
                                                  .values
                                                  .length;
                                          index++)
                                        produ(
                                            ind,
                                            productModel
                                                .products
                                                .productedges[ind]
                                                .productnode
                                                .options[0]
                                                .values
                                                .length,
                                            productModel
                                                .products
                                                .productedges[ind]
                                                .productnode
                                                .options[1]
                                                .values
                                                .length,
                                            index),
                                  ]),
                                ),
                              ),
                            );
                          } else {
                            return EmptyState();
                          }
                        }),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }

  Widget produ(ind, leng, sizesL, index) {
    bool available = false;
    bool availableImg = false;

    for (int i = 0; i < sizesL; i++) {
      if (productModel.products.productedges[ind].productnode.variants
          .variantedges[i + (sizesL * index)].variantnode.available) {
        available = true;
        break;
      }
    }
    if (leng != 1) {
      for (int i = 0;
          i <
              productModel.products.productedges[ind].productnode.images
                  .imagesedges.length;
          i++) {
        if (productModel.products.productedges[ind].productnode.images
                .imagesedges[i].imagesnode.altText ==
            productModel.products.productedges[ind].productnode.options[0]
                .values[index]) {
          availableImg = true;
          break;
        }
      }
    } else {
      availableImg = true;
    }

    return available && availableImg
        ? Container(
            height: 300,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width / 2,
            child: ProductWidget(
                filterProducts: productModel.products.productedges[ind],
                index: ind,
                cValue: index,
                leng: leng,
                sizesL: sizesL,
                grid: false))
        : Container(
            width: 0,
          );
  }
}
