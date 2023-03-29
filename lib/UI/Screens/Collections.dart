import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/rendering.dart';
import 'package:outfitters/Database/DatabaseHelper.dart';
import 'package:outfitters/Models/ProductsModel.dart';
import 'package:outfitters/UI/GraphQL/Query/GraphQlQueries.dart';
import 'package:outfitters/UI/Widgets/CartIconWidget.dart';
import 'package:outfitters/UI/Widgets/ErrorState.dart';
import 'package:outfitters/UI/Widgets/LoadingAnimation.dart';
import 'package:outfitters/Utils/GraphQlHelper.dart';
import 'package:outfitters/UI/Widgets/ErrorState2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:outfitters/UI/Widgets/ProductWidget.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter/src/widgets/image.dart' as Image;
import 'package:outfitters/UI/Screens/FiltersScreen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:outfitters/UI/Widgets/paginationLoadingWidget.dart';
import 'package:outfitters/Models/homeScreenModel.dart';
import 'package:outfitters/UI/Notifiers/NewFilters.dart';
import 'package:outfitters/UI/Screens/SearchProduct.dart';
import 'package:outfitters/UI/Widgets/ToastClass.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;

class Items {
  Items({
    this.expandedValue,
    this.headerValue,
    this.graphQl,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  String graphQl;
  bool isExpanded;
}

class Collections extends StatefulWidget {
  final String selected;
  final List subColList;
  final String shopifyId;
  final String name;
  final filterx;
  final String sorting;
  final bool isFilters;
  final List imgx;
  Collections(
      {@required this.selected,
      @required this.subColList,
      @required this.shopifyId,
      @required this.name,
      @required this.sorting,
      @required this.filterx,
      @required this.isFilters,
      @required this.imgx})
      : assert(selected != null),
        assert(subColList != null),
        assert(shopifyId != null),
        assert(name != null),
        assert(imgx != null);
  @override
  _CollectionsState createState() =>
      _CollectionsState(this.shopifyId, this.name, this.subColList);
}

class _CollectionsState extends State<Collections>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final List subColList;
  final String shopifyId;
  final String name;

  _CollectionsState(this.shopifyId, this.name, this.subColList);
  int selectedCol;
  String cartMsg = "";
  int count;
  bool success = false;
  Color colorx;
  String productId;
  List<dynamic> repos;
  // bool applyfilters = false;
  List<dynamic> products = [];
  int selectedValue = -1;
  int selectedValue2 = -1;
  final graphqlconnection = GraphQlHelper();
  // int index = 0;
  int len = -1;
  ScrollController controller;
  int isFavorite = 0;
  List productSizes;
  var variantsId;
  var productImagess;
  ProductModel productModel;
  List _filtersItems = [];
  List allLists = [];
  List listData = [];
  bool reverse = false;
  GlobalKey _stackKey = GlobalKey();
  List collectionx = [];
  String sort;
  QueryResult _result;
  FetchMoreOptions opts;
  FetchMore _fetchMore;
  var connectionStatus;
  bool isfiltersApply;
  List _miniSliderItems = [];

  String readProduct;
  SharedPreferences sharedPreferences;
  List<bool> avialableForSale = [];
  int _selectsizeIndex;
  int _selectsizeIndexNew;
  ScrollController _scrollController = new ScrollController();

  String cartCount;
  int cartitems = 1;
  int countValue = 0;
  bool abccc = false;
  int selectedInd = -1;
  List<Productedges> filterProducts = [];
  List<Productedges> productedges;
  // ScrollController _scrollViewController;

  final databaseHelper = DatabaseHelper.instance;

  var subcollectionName;
  var subcollectionNameLength;
  String countr;
  ScrollController con;
  bool miniSlider = false;

  StreamController<bool> _scollUp = StreamController<bool>.broadcast();
  StreamController<List<String>> _checked =
      StreamController<List<String>>.broadcast();

  @override
  void dispose() {
    // _scrollViewController.dispose();
    _scrollController.dispose();
    _scrollController.removeListener(_paginationListener);
    _scollUp.close();
    _checked.close();

    super.dispose();
  }

  List datax = [];

  @override
  void initState() {
    if (widget.sorting == null || widget.sorting == "") {
      sort = 'RELEVANCE';
      Provider.of<FilterNotifier>(context, listen: false).setIndex(0);
    } else if (widget.sorting == "Popularity") {
      sort = 'RELEVANCE';
      reverse = false;
      Provider.of<FilterNotifier>(context, listen: false).setIndex(0);
    } else if (widget.sorting == "Price, low to high") {
      sort = 'PRICE';
      reverse = false;
      Provider.of<FilterNotifier>(context, listen: false).setIndex(1);
    } else if (widget.sorting == "Price, high to low") {
      sort = 'PRICE';
      reverse = true;
      Provider.of<FilterNotifier>(context, listen: false).setIndex(2);
    } else if (widget.sorting == "Alphabetically, A-Z") {
      sort = 'TITLE';
      reverse = false;
      Provider.of<FilterNotifier>(context, listen: false).setIndex(3);
    } else if (widget.sorting == "Alphabetically, Z-A") {
      sort = 'TITLE';
      reverse = true;
      Provider.of<FilterNotifier>(context, listen: false).setIndex(4);
    } else if (widget.sorting == "Date, old to new") {
      sort = 'CREATED';
      reverse = false;
      Provider.of<FilterNotifier>(context, listen: false).setIndex(5);
    } else if (widget.sorting == "Date, new to old") {
      sort = 'CREATED';
      reverse = true;
      Provider.of<FilterNotifier>(context, listen: false).setIndex(6);
    } else if (widget.sorting == "Best Selling") {
      sort = 'BEST_SELLING';
      reverse = true;
      Provider.of<FilterNotifier>(context, listen: false).setIndex(7);
    }

    widgetSelector = widget.selected.toUpperCase();
    isfiltersApply = false;
    con = ScrollController();
    con.addListener(() {
      if (con.offset >= con.position.maxScrollExtent &&
          !con.position.outOfRange) {
        setState(() {});
      } else if (con.offset <= con.position.minScrollExtent &&
          !con.position.outOfRange) {
        setState(() {});
      } else {
        setState(() {});
      }
    });
    // _scrollViewController = ScrollController();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //_paginationListener();
    //});
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.addListener(() {
        print('scrolling');
      });
      _scrollController.position.isScrollingNotifier.addListener(() {
        if (_scrollController.hasClients) {
          print('scroll is stopped');
        } else {
          // _paginationListener();
          print('scroll is started');
        }
      });
    });

    setState(() {});
    super.initState();
  }

  onSelectedsize(int index) {
    setState(() {
      _selectsizeIndexNew = index;
    });
  }

  List<String> categoryList = List<String>();

  var favproid;
  int _index;
  bool isLoading = false;
  static String value;
  var error;
  String collectionTitle;
  bool selected = false;
  int findout = 0;
  List<String> _queryList = [];
  String stringList;
  String titles;
  String description;
  final formatter = new NumberFormat("#,###,###");
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  bool isShowDetailContainer = true;
  bool loading = false;
  String widgetSelector;

  void setpage(bool result) {
    setState(() {
      isfiltersApply = result;
    });
  }

  sorting(bool reversedata, String sorting) {
    reverse = reversedata;
    sort = sorting;
  }

  // _paginationListener() {
  //   _scrollController
  //     ..addListener(() {
  //       // index = 0;
  //       if (_scrollController.offset >= 700) {
  //         if (_scrollController.position.pixels >
  //             MediaQuery.of(context).size.height * 0.5) {
  //           // print(_scrollController.position.pixels.toString());
  //           if (isShowDetailContainer) {
  //             // index = 0;
  //             setState(() {
  //               isShowDetailContainer = false;
  //             });
  //           }
  //         }
  //         _scollUp.sink.add(true);
  //       } else {
  //         if (!isShowDetailContainer) {
  //           setState(() {
  //             isShowDetailContainer = true;
  //           });
  //           _scollUp.sink.add(false);
  //         }
  //       }
  //       if (_scrollController.position.pixels ==
  //           _scrollController.position.maxScrollExtent) {
  //         if (isfiltersApply) {
  //           if (_result != null &&
  //               !_result.loading &&
  //               _result.data != null &&
  //               _result.data['products'] != null &&
  //               _result.data['products']['pageInfo'] != null &&
  //               _result.data['products']['pageInfo']['hasNextPage'] != null) {
  //             if (_result.data['products']['pageInfo']['hasNextPage']) {
  //               if (opts != null) {
  //                 _fetchMore(opts);
  //               }
  //             }
  //           }
  //         } else {
  //           if (_result != null &&
  //               !_result.loading &&
  //               _result.data != null &&
  //               _result.data['node'] != null &&
  //               _result.data['node']['products'] != null &&
  //               _result.data['node']['products']['pageInfo'] != null &&
  //               _result.data['node']['products']['pageInfo']['hasNextPage'] !=
  //                   null) {
  //             if (_result.data['node']['products']['pageInfo']['hasNextPage']) {
  //               if (opts != null) {
  //                 _fetchMore(opts);
  //               }
  //             }
  //           }
  //         }
  //       }
  //     });
  // }
  _paginationListener() {
    _scrollController
      ..addListener(() {
        if (_scrollController.offset >= 20) {
          if (_scrollController.position.pixels >
              MediaQuery.of(context).size.height / 13) {
            print(_scrollController.position.pixels.toString());
            if (isShowDetailContainer) {
              setState(() {
                isShowDetailContainer = false;
              });
            }
          }
          _scollUp.sink.add(true);
        } else {
          if (!isShowDetailContainer) {
            setState(() {
              isShowDetailContainer = true;
            });
            _scollUp.sink.add(false);
          }
        }
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (isfiltersApply) {
            if (_result != null &&
                !_result.isLoading &&
                _result.data != null &&
                _result.data['products'] != null &&
                _result.data['products']['pageInfo'] != null &&
                _result.data['products']['pageInfo']['hasNextPage'] != null) {
              if (_result.data['products']['pageInfo']['hasNextPage']) {
                if (opts != null) {
                  _fetchMore(opts);
                }
              }
            }
          } else {
            if (_result != null &&
                !_result.isLoading &&
                _result.data != null &&
                _result.data['node'] != null &&
                _result.data['node']['products'] != null &&
                _result.data['node']['products']['pageInfo'] != null &&
                _result.data['node']['products']['pageInfo']['hasNextPage'] !=
                    null) {
              if (_result.data['node']['products']['pageInfo']['hasNextPage']) {
                if (opts != null) {
                  _fetchMore(opts);
                }
              }
            }
          }
        }
      });
  }

  _onStartScroll(ScrollMetrics metrics) {
    print("Scroll Start");
  }

  _onUpdateScroll(ScrollMetrics metrics) {
    print("Scroll Update");
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (isfiltersApply) {
        if (_result != null &&
            _result.isNotLoading &&
            _result.data != null &&
            _result.data['products'] != null &&
            _result.data['products']['pageInfo'] != null &&
            _result.data['products']['pageInfo']['hasNextPage'] != null) {
          if (_result.data['products']['pageInfo']['hasNextPage']) {
            if (opts != null) {
              _fetchMore(opts);
            }
          }
        }
      } else {
        if (_result != null &&
            !_result.isLoading &&
            _result.data != null &&
            _result.data['node'] != null &&
            _result.data['node']['products'] != null &&
            _result.data['node']['products']['pageInfo'] != null &&
            _result.data['node']['products']['pageInfo']['hasNextPage'] !=
                null) {
          if (_result.data['node']['products']['pageInfo']['hasNextPage']) {
            if (opts != null) {
              _fetchMore(opts);
            }
          }
        }
      }
    }
  }

  _onEndScroll(ScrollMetrics metrics) {
    print("Scroll End");
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (isfiltersApply) {
        if (_result != null &&
            !_result.isLoading &&
            _result.data != null &&
            _result.data['products'] != null &&
            _result.data['products']['pageInfo'] != null &&
            _result.data['products']['pageInfo']['hasNextPage'] != null) {
          if (_result.data['products']['pageInfo']['hasNextPage']) {
            if (opts != null) {
              _fetchMore(opts);
            }
          }
        }
      } else {
        if (_result != null &&
            !_result.isLoading &&
            _result.data != null &&
            _result.data['node'] != null &&
            _result.data['node']['products'] != null &&
            _result.data['node']['products']['pageInfo'] != null &&
            _result.data['node']['products']['pageInfo']['hasNextPage'] !=
                null) {
          if (_result.data['node']['products']['pageInfo']['hasNextPage']) {
            if (opts != null) {
              _fetchMore(opts);
            }
          }
        }
      }
    }
  }

  Future _openDialogAddress() async {
    if (_filtersItems != null) {
      FiltersModel filtersData = await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => FiltersScreen(
              link: "https://outfitters.com.pk/collections/" +
                  titles
                      .toLowerCase()
                      .replaceAll(RegExp(" - "), '-')
                      .replaceAll(RegExp("\\ "), '-') +
                  "?view=json",
              onSet: setpage,
              sorting: sorting,
              filterx: widget.filterx,
              isFilters: true,
              selectedFilter: "${listData.join(',')}"));
      setState(() {
        if (filtersData != null) {
          abccc = true;
          for (int i = _filtersItems.length; i > 1; i--) {
            _filtersItems.removeAt(1);
          }
          allLists.clear();
          allLists.add(filtersData);
          if (titles != null) {
            if (!_filtersItems
                .contains("tag:${titles.replaceAll(RegExp("\\ "), '-')}")) {
              _filtersItems.add("tag:${titles.replaceAll(RegExp("\\ "), '-')}");
            }
          }
          listData.clear();
          for (int i = 0; i < allLists.length; i++) {
            listData.add(allLists[i].colors);
            _filtersItems.add(allLists[i].colors.join(' AND '));
          }
        } else {
          abccc = false;
          for (int i = _filtersItems.length; i > 1; i--) {
            _filtersItems.removeAt(1);
          }
          listData.clear();
        }
      });
    } else {
      FiltersModel filtersData = await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => FiltersScreen(
              link: "https://outfitters.com.pk/collections/" +
                  titles
                      .toLowerCase()
                      .replaceAll(RegExp(" - "), '-')
                      .replaceAll(RegExp("\\ "), '-') +
                  "?view=json",
              onSet: setpage,
              sorting: sorting,
              filterx: widget.filterx,
              isFilters: true,
              selectedFilter: []));

      setState(() {
        if (filtersData != null) {
          for (int i = _filtersItems.length; i > 1; i--) {
            _filtersItems.removeAt(1);
          }
          abccc = true;

          allLists.clear();
          allLists.add(filtersData);
          if (titles != null) {
            if (!_filtersItems
                .contains("tag:${titles.replaceAll(RegExp("\\ "), '-')}")) {
              _filtersItems.add("tag:${titles.replaceAll(RegExp("\\ "), '-')}");
            }
          }
          listData.clear();
          for (int i = 0; i < allLists.length; i++) {
            listData.add(allLists[i].colors);
            _filtersItems.add(allLists[i].colors.join(' AND '));
          }
        } else {
          abccc = false;
          for (int i = _filtersItems.length; i > 1; i--) {
            _filtersItems.removeAt(1);
          }
          listData.clear();
        }
      });
    }
  }

  String queryString() {
    List<String> _query = [];
    List<List<Item>> _querycolorSize = [
      Provider.of<FilterNotifier>(context).size,
      Provider.of<FilterNotifier>(context).price
    ];

    _querycolorSize.forEach((item) {
      _query.clear();
      item.forEach((data) {
        if (data.isSelect) {
          _query.add('tag:$data');
          // print(_query);
        }
      });
      if (_query.isNotEmpty) _queryList.add(_query.join(' AND '));
    });
    return _queryList.join(' AND ');
  }

  Future<void> _pullRefresh() async {
    setState(() {
      loading = true;
      // print(loading);
    });
    Navigator.of(context).pushReplacement(CupertinoPageRoute(
        builder: (context) => Collections(
            sorting: widget.sorting,
            selected: widget.selected.toString().toUpperCase(),
            subColList: widget.subColList,
            shopifyId: widget.shopifyId,
            name: widget.name,
            filterx: widget.filterx,
            isFilters: true,
            imgx: widget.imgx),
        settings: RouteSettings(name: 'Collections Screen ')));
  }

  @override
  Widget build(BuildContext context) {
    filterProducts = [];
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent, // navigation bar color
      statusBarColor: Colors.black, // status bar color
      statusBarBrightness: Brightness.light,
    ));

    return RefreshIndicator(
        onRefresh: _pullRefresh,
        child: Scaffold(
            drawerEdgeDragWidth: 0,
            key: _scaffoldKey,
            drawer: Drawer(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: 29),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 35,
                                margin: EdgeInsets.only(left: 5.0),
                                alignment: Alignment.centerLeft,
                                child: SvgPicture.asset(
                                  'assets/images/logo.svg',
                                  height: 30,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 5.0),
                                alignment: Alignment.centerRight,
                                child: Icon(Icons.close),
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                          color: Colors.white,
                          margin:
                              EdgeInsets.only(left: 2.0, right: 2.0, top: 5),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    setState(() {
                                      widgetSelector = "MEN";
                                    });
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.center,
                                        height: 38,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xFF868686))),
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              height: 34.5,
                                              child: Text(
                                                subColList[0]
                                                    .name
                                                    .toUpperCase()
                                                    .toString(),
                                                style: TextStyle(
                                                  fontFamily: 'Lato',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                  color: widgetSelector == "MEN"
                                                      ? Colors.black
                                                      : Color(0xFF868686),
                                                ),
                                              ),
                                            ),
                                            widgetSelector == "MEN"
                                                ? Container(
                                                    // width: 90,
                                                    color: Colors.black,
                                                    height: 1.5,
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    setState(() {
                                      widgetSelector = "WOMEN";
                                    });
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.center,
                                        height: 38,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xFF868686))),
                                        // width: 90,
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              height: 34.5,
                                              child: Text(
                                                subColList[1]
                                                    .name
                                                    .toUpperCase()
                                                    .toString(),
                                                style: TextStyle(
                                                  fontFamily: 'Lato',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                  color:
                                                      widgetSelector == "WOMEN"
                                                          ? Colors.black
                                                          : Color(0xFF868686),
                                                ),
                                              ),
                                            ),
                                            widgetSelector == "WOMEN"
                                                ? Container(
                                                    // width: 90,
                                                    color: Colors.black,
                                                    height: 1.5,
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    setState(() {
                                      widgetSelector = "JUNIORS";
                                    });
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xFF868686))),
                                        // color: widgetSelector == "Juniors"
                                        //     ? Color.fromRGBO(26, 42, 140, 0.05)
                                        //     : Color(0xFFFFFFFF),
                                        alignment: Alignment.center,
                                        height: 38,
                                        // width: 90,
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              height: 34.5,
                                              child: Text(
                                                subColList[2]
                                                    .name
                                                    .toUpperCase()
                                                    .toString(),
                                                style: TextStyle(
                                                  fontFamily: 'Lato',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                  color: widgetSelector ==
                                                          "JUNIORS"
                                                      ? Colors.black
                                                      : Color(0xFF868686),
                                                ),
                                              ),
                                            ),
                                            widgetSelector == "JUNIORS"
                                                ? Container(
                                                    // width: 90,
                                                    color: Colors.black,
                                                    height: 1.5,
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                      chooseWidget(),
                    ],
                  ),
                ),
              ),
            ),
            appBar: AppBar(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              centerTitle: true,
              title: AutoSizeText(
                name,
                style: AppTheme.TextTheme.boldText,
              ),
              actions: <Widget>[
                InkWell(
                    onTap: () {
                      if (productModel != null) {
                        _openDialogAddress();
                      } else {
                        Toast.showToast(context, 'Please wait for result');
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 5, right: 2),
                      child: SvgPicture.asset(
                        'assets/images/filters.svg',
                        color: Theme.of(context).primaryColorLight,
                      ),
                    )),
                CartIconWidget()
              ],
            ),
            body: loading == true
                ? Container(
                    height: MediaQuery.of(context).size.height / 1.2,
                    child: Center(child: CircularProgressIndicator()))
                : Container(
                    child: Flex(
                      direction: Axis.vertical,
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              if (productModel != null) {
                                // index = 0;
                                Navigator.of(context).push(PageTransition(
                                    child: SearchProducts(
                                        collectionName:
                                            "tag:${titles.replaceAll(RegExp("\\ "), '-')}",
                                        sorting: widget.sorting,
                                        selected: widget.selected
                                            .toString()
                                            .toUpperCase(),
                                        subColList: widget.subColList,
                                        shopifyId: widget.shopifyId,
                                        name: widget.name,
                                        filterx: widget.filterx,
                                        isFilters: true,
                                        imgx: widget.imgx

                                        // _miniSliderItems.length ==
                                        //         0
                                        //     ? productModel.products.productedges
                                        //                 .length ==
                                        //             0
                                        //         ? "tag:${titles.replaceAll(RegExp("\\ "), '-')}"
                                        //         : _filtersItems[0].toString()
                                        //     : _miniSliderItems[0].toString(),
                                        ),
                                    type: PageTransitionType.bottomToTop,
                                    settings: RouteSettings(
                                        name: 'Search Products')));

                                // _scrollController
                                //     .removeListener(_paginationListener);

                                _scrollController.dispose();
                              } else {
                                Toast.showToast(
                                    context, 'Please wait for result');
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 1.4),
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 7),
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2)),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 6),
                                      child: Icon(
                                        Icons.search,
                                        color: Colors.grey[500],
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),
                        widget.imgx.length == 0 || widget.imgx.length == 1
                            ? Container()
                            : Flexible(
                                flex: 1,
                                child: Container(
                                  margin: EdgeInsets.only(
                                    left: 5,
                                    right: 5,
                                  ),
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: widget.imgx.length,
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int ind) {
                                        return InkWell(
                                          onTap: () {
                                            selectedInd = ind;
                                            if (productModel != null) {
                                              if (_miniSliderItems.length ==
                                                  2) {
                                                _miniSliderItems.removeAt(1);
                                              }
                                              miniSlider = true;
                                              if (_miniSliderItems.length ==
                                                  0) {
                                                _miniSliderItems.add(
                                                    "tag:${titles.replaceAll(RegExp("\\ "), '-')}");
                                                if (!_filtersItems.contains(
                                                    "tag:${titles.replaceAll(RegExp("\\ "), '-')}")) {
                                                  _filtersItems.add(
                                                      "tag:${titles.replaceAll(RegExp("\\ "), '-')}");
                                                }
                                              }
                                              _miniSliderItems.add(
                                                  "tag:${widget.imgx[ind]}");
                                              _miniSliderItems
                                                  .forEach((element) {
                                                // print("Element : $element");
                                              });
                                              setState(() {});
                                            } else {
                                              Toast.showToast(context,
                                                  'Please wait for result');
                                            }
                                          },
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                  bottom: 5,
                                                  left: 15,
                                                  right: 15,
                                                  top: 10),
                                              child: Text(
                                                widget.imgx[ind],
                                                style: TextStyle(
                                                    fontSize: ind == selectedInd
                                                        ? 16
                                                        : 16,
                                                    fontWeight: ind ==
                                                            selectedInd
                                                        ? FontWeight.bold
                                                        : FontWeight.normal),
                                              )),
                                        );
                                      }),
                                ),
                              ),
                        Flexible(
                          flex: 15,
                          child: GraphQLProvider(
                            client: graphqlconnection.client,
                            child: Query(
                              options: QueryOptions(
                                  document: isfiltersApply || miniSlider
                                      ? gql(filterCollection)
                                      : gql(readCollection),
                                  variables: isfiltersApply
                                      ? {
                                          "query":
                                              "${_filtersItems.join(' AND ')}",
                                          "rev": true,
                                          "cursor": null
                                        }
                                      : miniSlider
                                          ? {
                                              "query":
                                                  "${_miniSliderItems.join(' AND ')}",
                                              "rev": reverse,
                                              "cursor": null,
                                              "shortkey": '$sort'
                                            }
                                          : {
                                              "CollectionId": shopifyId,
                                              "shortkey": '$sort',
                                              "rev": reverse,
                                              "cursor": null
                                            }),
                              builder: (QueryResult result,
                                  {refetch, FetchMore fetchMore}) {
                                if (result.isLoading && result.data == null) {
                                  return Container(
                                      color: Colors.white,
                                      width: MediaQuery.of(context).size.width,
                                      child: LoadingAnimation());
                                }
                                if (result.data == null &&
                                    result.hasException == null) {
                                  return ErrorState();
                                }

                                if (result.data == null) {
                                  return ErrorState();
                                }
                                _result = result;

                                productModel =
                                    ProductModel.fromJson(result.data);

                                if (isfiltersApply || miniSlider) {
                                  productModel =
                                      ProductModel.fromJson(result.data);
                                  if (_result != null &&
                                      _result.data['products'] != null &&
                                      _result.data['products']['edges'] !=
                                          null &&
                                      _result.data['products']['edges'].length >
                                          0) {
                                    products = (_result.data['products']
                                        ['edges'] as List<dynamic>);
                                    // print("Product Length :: ${products.length}");

                                    final String fetchMoreCursor = result
                                        .data['products']['edges']
                                        .last['cursor'];

                                    if (fetchMoreCursor != null) {
                                      opts = FetchMoreOptions(
                                        variables: {'cursor': fetchMoreCursor},
                                        updateQuery: (previousResultData,
                                            fetchMoreResultData) {
                                          final List<dynamic> repos = [
                                            ...previousResultData['products']
                                                ['edges'] as List<dynamic>,
                                            ...fetchMoreResultData['products']
                                                ['edges'] as List<dynamic>
                                          ];

                                          fetchMoreResultData['products']
                                              ['edges'] = repos;

                                          return fetchMoreResultData;
                                        },
                                      );
                                      _fetchMore = fetchMore;
                                    } else {
                                      opts = null;
                                    }
                                  } else {
                                    return Center(
                                      child: Text('No Data found'),
                                    );
                                  }
                                } else {
                                  productModel = ProductModel.fromJson(
                                      result.data['node']);
                                  titles = _result.data['node']['title'];
                                  if (_result.data != null &&
                                      _result.data['node'] != null &&
                                      _result.data['node']['products'] !=
                                          null &&
                                      _result.data['node']['products']
                                              ['edges'] !=
                                          null &&
                                      _result.data['node']['products']['edges']
                                              .length >
                                          0) {
                                    products = (_result.data['node']['products']
                                        ['edges'] as List<dynamic>);
                                    // print("Product Length :: ${products.length}");

                                    final String fetchMoreCursor = result
                                        .data['node']['products']['edges']
                                        .last['cursor'];

                                    if (fetchMoreCursor != null) {
                                      opts = FetchMoreOptions(
                                        variables: {'cursor': fetchMoreCursor},
                                        updateQuery: (previousResultData,
                                            fetchMoreResultData) {
                                          final List<dynamic> repos = [
                                            ...previousResultData['node']
                                                    ['products']['edges']
                                                as List<dynamic>,
                                            ...fetchMoreResultData['node']
                                                    ['products']['edges']
                                                as List<dynamic>
                                          ];

                                          fetchMoreResultData['node']
                                              ['products']['edges'] = repos;

                                          return fetchMoreResultData;
                                        },
                                      );
                                      _fetchMore = fetchMore;
                                    } else {
                                      opts = null;
                                    }
                                  } else {
                                    if (products.isEmpty) {
                                      return Center(
                                        child: Text('No Data found'),
                                      );
                                    }
                                  }
                                }
                                return Stack(
                                  children: <Widget>[
                                    productModel.products.productedges.length ==
                                            0
                                        ? ErrorState2()
                                        : Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: NotificationListener<
                                                ScrollNotification>(
                                              onNotification:
                                                  // ignore: missing_return
                                                  (scrollNotification) {
                                                if (scrollNotification
                                                    is ScrollStartNotification) {
                                                  _onStartScroll(
                                                      scrollNotification
                                                          .metrics);
                                                } else if (scrollNotification
                                                    is ScrollUpdateNotification) {
                                                  _onUpdateScroll(
                                                      scrollNotification
                                                          .metrics);
                                                } else if (scrollNotification
                                                    is ScrollEndNotification) {
                                                  _onEndScroll(
                                                      scrollNotification
                                                          .metrics);
                                                }
                                              },
                                              child: SingleChildScrollView(
                                                controller: _scrollController,
                                                physics: BouncingScrollPhysics(
                                                    parent:
                                                        AlwaysScrollableScrollPhysics()),
                                                child: Wrap(children: [
                                                  for (int ind = 0;
                                                      ind <
                                                          productModel
                                                              .products
                                                              .productedges
                                                              .length;
                                                      ind++)
                                                    for (int index = 0;
                                                        index <
                                                            productModel
                                                                .products
                                                                .productedges[
                                                                    ind]
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

                                            // StaggeredGridView.count(
                                            //     controller: _scrollController,
                                            //     crossAxisCount: 2,
                                            //     shrinkWrap: true,
                                            //     // itemCount: productModel
                                            //     //     .products.productedges
                                            //     //     .where((element) =>
                                            //     //         element.productnode
                                            //     //             .availableForSale ==
                                            //     //         true)
                                            //     //     .length,
                                            //     // staggeredTileBuilder:
                                            //     //     (int index) {
                                            //     //   return index % 3 == 0
                                            //     //       ? new StaggeredTile
                                            //     //           .count(2, 2.7)
                                            //     //       : new StaggeredTile
                                            //     //           .count(1, 1.6);
                                            //     // },
                                            //     staggeredTiles: productModel
                                            //         .products.productedges
                                            //         .where((element) {
                                            //           if (element.productnode
                                            //                   .availableForSale ==
                                            //               true) {
                                            //             index++;
                                            //             print("$index");
                                            //           }

                                            //           return element.productnode
                                            //               .availableForSale;
                                            //         })
                                            //         .map<StaggeredTile>((_) =>
                                            //             index % 3 == 0
                                            //                 ? new StaggeredTile.count(
                                            //                     2, 2.8)
                                            //                 : new StaggeredTile
                                            //                     .count(1, 1.60))
                                            //         .toList(),
                                            //          mainAxisSpacing: 2.0,
                                            //          crossAxisSpacing: 2.0,
                                            //          physics:BouncingScrollPhysics(),
                                            //          children: productModel
                                            //         .products.productedges
                                            //         .where((element) =>
                                            //         element.productnode.availableForSale ==true)
                                            //         .map<Widget>((item) {
                                            //       return ProductWidget(
                                            //           filterProducts: item,
                                            //           index: index,
                                            //           grid: false);
                                            //       // }).toList(),
                                            //       // itemBuilder:
                                            //       //     (BuildContext context,
                                            //       //         int index) {
                                            //       //   isfiltersApply == false
                                            //       //       ? titles = titles
                                            //       //       : print("");

                                            //       //   return ProductWidget(
                                            //       //       filterProducts:
                                            //       //           productModel
                                            //       //               .products
                                            //       //               .productedges,
                                            //       //       index: index,
                                            //       //       grid: false);
                                            //     }).toList()),
                                          ),
                                    PaginationLoadingWidget(queryResult: result)
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )));
  }

  Widget produ(ind, leng, sizesL, index) {
    bool available = false;
    bool availableImg = false;

    for (int i = 0; i < sizesL; i++) {
      if (productModel.products.productedges[ind].productnode.variants
          .variantedges[i + (sizesL * index)].variantnode.available) {
        available = true;
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
        }
      }
    } else {
      availableImg = true;
    }
    len = available && availableImg ? len + 1 : len;
    return available && availableImg
        ? Container(
            height: len % 3 == 0 ? 655 : 350,
            //     ? MediaQuery.of(context).size.height * 0.85
            //     : MediaQuery.of(context).size.height * 0.45,
            alignment: Alignment.center,
            width: len % 3 == 0
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.width / 2,
            child: Container(
              margin: EdgeInsets.only(
                  right: len % 3 == 0 || len % 3 == 2 ? 0 : 2,
                  left: len % 3 == 0 || len % 3 == 1 ? 0 : 2),
              child: ProductWidget(
                  filterProducts: productModel.products.productedges[ind],
                  index: ind,
                  cValue: index,
                  leng: leng,
                  sizesL: sizesL,
                  grid: false),
            ))
        : Container(width: 0, height: 0);
  }

  Widget chooseWidget() {
    if (widgetSelector == "MEN") {
      return _buildPanel(0, subColList, subColList[0].subCollection);
    } else if (widgetSelector == "WOMEN") {
      return _buildPanel(1, subColList, subColList[1].subCollection);
    } else if (widgetSelector == "JUNIORS") {
      return _buildPanel(2, subColList, subColList[2].subCollection);
    }

    return Container();
  }

  Widget _buildPanel(indexi, col, data) {
    List subCol = [];
    subCol.clear();
    for (var i = 0; i < data.length; i++) {
      subCol.add({"data": data[i], "sid": int.parse(data[i].sortOrder)});
      subCol.sort((a, b) => a['sid'].compareTo(b['sid']));
    }
    return FutureBuilder(
        future: Future.delayed(new Duration(seconds: 5)),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else
            return Theme(
              data: Theme.of(context).copyWith(
                  accentColor: Theme.of(context).primaryColorLight,
                  dividerColor: Colors.transparent),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: subCol.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, ind) {
                        return Container(
                            child: subCol[ind]['data']
                                        .nestedSubCollection
                                        .length ==
                                    0
                                ? InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                          CupertinoPageRoute(
                                              builder: (context) => Collections(
                                                    sorting: subCol[ind]['data']
                                                        .sortingValue,
                                                    selected: col[indexi]
                                                        .name
                                                        .toString()
                                                        .toUpperCase(),
                                                    subColList: col,
                                                    shopifyId: subCol[ind]
                                                            ['data']
                                                        .shopifyId,
                                                    name: subCol[ind]['data']
                                                        .name,
                                                    filterx: widget.filterx,
                                                    isFilters: true,
                                                    imgx: subCol[ind]['data']
                                                                .customTags ==
                                                            null
                                                        ? []
                                                        : subCol[ind]['data']
                                                            .customTags,
                                                  ),
                                              settings: RouteSettings(
                                                  name:
                                                      'Collections Screen ')));
                                    },
                                    child: Container(
                                      child: ListTile(
                                        title: Text(
                                          subCol[ind]['data']
                                              .name
                                              .toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: subCol[ind]['data']
                                                            .menuColor ==
                                                        null ||
                                                    subCol[ind]['data']
                                                            .menuColor ==
                                                        ""
                                                ? Colors.black
                                                : Color(int.parse(subCol[ind]
                                                        ['data']
                                                    .menuColor
                                                    .split("(")[1]
                                                    .replaceAll(")", ""))),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          if (selectedValue == ind) {
                                            selectedValue = -1;
                                          } else {
                                            selectedValue = ind;
                                          }
                                          setState(() {});
                                        },
                                        title: Text(
                                          subCol[ind]['data']
                                                      .name
                                                      .toUpperCase() ==
                                                  "SALE"
                                              ? subCol[ind]['data']
                                                  .name
                                                  .toUpperCase()
                                              : subCol[ind]['data'].name,
                                          style: TextStyle(
                                              color: subCol[ind]['data']
                                                              .menuColor ==
                                                          null ||
                                                      subCol[ind]['data']
                                                              .menuColor ==
                                                          ""
                                                  ? Colors.black
                                                  : Color(int.parse(subCol[ind]
                                                          ['data']
                                                      .menuColor
                                                      .split("(")[1]
                                                      .replaceAll(")", ""))),
                                              fontWeight: FontWeight.w400),
                                        ),
                                        trailing: Icon(Icons.arrow_drop_down),
                                      ),
                                      ind == selectedValue
                                          ? nested(ind, subCol[ind]['data'],
                                              col[indexi].name, col)
                                          : Container()
                                    ],
                                  ));
                      }),
                ],
              ),
            );
        });
  }

  Widget nested(i, subCol, selectedCol, col) {
    List nesCol = [];
    for (var i = 0; i < subCol.nestedSubCollection.length; i++) {
      nesCol.add({
        "data": subCol.nestedSubCollection[i],
        "sid": int.parse(subCol.nestedSubCollection[i].sortOrder)
      });
      nesCol.sort((a, b) => a['sid'].compareTo(b['sid']));
    }
    return Container(
      child: ListView.builder(
          itemCount: nesCol.length,
          shrinkWrap: true,
          controller: con,
          itemBuilder: (BuildContext context, int index) {
            return nesCol[index]['data'].nestedSubCollection2.length == 0
                ? ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    dense: false,
                    onTap: () {
                      Navigator.of(context).pushReplacement(CupertinoPageRoute(
                          builder: (context) => Collections(
                              sorting: nesCol[index]['data'].sortingValue,
                              selected: selectedCol.toString().toUpperCase(),
                              subColList: col,
                              shopifyId: nesCol[index]['data'].shopifyId,
                              name: nesCol[index]['data'].name,
                              filterx: widget.filterx,
                              isFilters: true,
                              imgx: nesCol[index]['data'].customTags),
                          settings:
                              RouteSettings(name: 'Nested Collection Screen')));
                    },
                    title: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        nesCol[index]['data'].name.toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  )
                : nestedSubCol(index, nesCol[index]['data'], selectedCol, col);
          }),
    );
  }

  Widget nestedSubCol(index, nesCol, selectedCol, col) {
    List nesSubCol = [];
    for (var i = 0; i < nesCol.nestedSubCollection2.length; i++) {
      nesSubCol.add({
        "data": nesCol.nestedSubCollection2[i],
        "sid": int.parse(nesCol.nestedSubCollection2[i].sortOrder)
      });
      nesSubCol.sort((a, b) => a['sid'].compareTo(b['sid']));
    }
    return Column(
      children: [
        ListTile(
          onTap: () {
            if (selectedValue2 == index) {
              selectedValue2 = -1;
            } else {
              selectedValue2 = index;
            }
            setState(() {});
          },
          title: Text(
            nesCol.name,
            style: TextStyle(color: Colors.black),
          ),
          trailing: Icon(Icons.arrow_drop_down),
        ),
        selectedValue2 != index
            ? Container()
            : ListView.builder(
                itemCount: nesSubCol.length,
                shrinkWrap: true,
                controller: con,
                itemBuilder: (BuildContext context, int inds) {
                  return ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    dense: false,
                    onTap: () {
                      Navigator.of(context).pushReplacement(CupertinoPageRoute(
                          builder: (context) => Collections(
                                sorting: nesSubCol[inds]['data'].sortingValue,
                                selected: selectedCol.toString().toUpperCase(),
                                subColList: col,
                                shopifyId: nesSubCol[inds]['data'].shopifyId,
                                name: nesSubCol[inds]['data'].name,
                                filterx: widget.filterx,
                                isFilters: true,
                                imgx: nesSubCol[inds]['data'].customTags,
                              ),
                          settings:
                              RouteSettings(name: 'Nested Collection Screen')));
                    },
                    title: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        nesSubCol[inds]['data'].name.toString(),
                        style: TextStyle(
                            color: nesSubCol[inds]['data'].name.toString() ==
                                    "Women's day"
                                ? Colors.pink
                                : Colors.black),
                      ),
                    ),
                  );
                }),
      ],
    );
  }
}

class FiltersModel {
  List<String> colors;
  // List<String> size;
  // List<String> price;

  FiltersModel(this.colors);

  FiltersModel.empty() {
    colors = [];
    // size = [];
    // price = [];
  }
}
