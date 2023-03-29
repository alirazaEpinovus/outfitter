import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:outfitters/Models/SortingModel.dart';
import 'package:outfitters/UI/Notifiers/NewFilters.dart';
import 'package:outfitters/UI/Widgets/LoadingAnimation.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;
import 'package:provider/provider.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:outfitters/UI/Screens/Collections.dart';

class FiltersScreen extends StatefulWidget {
  final Function onSet;
  final Function sorting;
  final filterx;
  final selectedFilter, link;
  final bool isFilters;
  FiltersScreen(
      {this.onSet,
      this.sorting,
      this.filterx,
      this.link,
      this.selectedFilter,
      this.isFilters});
  @override
  _FiltersScreenState createState() =>
      _FiltersScreenState(this.onSet, this.sorting);
}

class _FiltersScreenState extends State<FiltersScreen>
    with SingleTickerProviderStateMixin {
  FiltersModel filtersData = new FiltersModel.empty();
  Function onSet;
  Function sorting;
  _FiltersScreenState(this.onSet, this.sorting);
  List<SortingModel> sortingModelList = [];
  var ab;
  var xyz;
  bool clearList = false;
  List size = [];
  List color = [];
  List type = [];
  List price = [];
  List filterPrice = [];
  List filterTypes = [];
  List filterColors = [];
  List filterSizes = [];
  var remStr;
  String apiUrl;

  @override
  void initState() {
    apiUrl = widget.link;
    sortingModelList.add(
        SortingModel(sortingString: 'Popularity', sortingValue: 'RELEVANCE'));
    sortingModelList.add(SortingModel(
        sortingString: 'Price : Low to High', sortingValue: 'PRICE'));
    sortingModelList.add(SortingModel(
        sortingString: 'Price : High to Low', sortingValue: 'PRICE'));
    sortingModelList.add(SortingModel(
        sortingString: 'Alphabetically, A-Z', sortingValue: 'TITLE'));
    sortingModelList.add(SortingModel(
        sortingString: 'Alphabetically, Z-A', sortingValue: 'TITLE'));
    sortingModelList.add(SortingModel(
        sortingString: 'Date: Old to New', sortingValue: 'CREATED'));
    sortingModelList.add(SortingModel(
        sortingString: 'Date: New to Old', sortingValue: 'CREATED'));
    sortingModelList.add(SortingModel(
        sortingString: 'Best Selling', sortingValue: 'BEST_SELLING'));
    getJsonData();
    super.initState();
    if (widget.filterx.price != null) {
      for (int q = 0; q < widget.filterx.price.length; q++) {
        filterPrice.add(widget.filterx.price[q].toString());
      }
    }
    if (widget.filterx.type != null) {
      for (int q = 0; q < widget.filterx.type.length; q++) {
        filterTypes.add(widget.filterx.type[q].toString());
      }
    }
    if (widget.filterx.size != null) {
      for (int q = 0; q < widget.filterx.size.length; q++) {
        filterSizes.add(widget.filterx.size[q].toString());
      }
    }
    if (widget.filterx.colors != null) {
      for (int q = 0; q < widget.filterx.colors.length; q++) {
        filterColors.add(widget.filterx.colors[q].toString());
      }
    }
    if (widget.isFilters == true) {
      ab = widget.selectedFilter
          .replaceAll(RegExp("\\["), '')
          .replaceAll(RegExp("\\]"), '');
      xyz = ab.split(", ");
      size.clear();
      price.clear();
      color.clear();
      type.clear();
      for (int i = 0; i < xyz.length; i++) {
        if (xyz[i].contains("(")) {
          remStr = xyz[i]
              .replaceAll(RegExp("\\("), '')
              .replaceAll(RegExp("\\)"), '');

          var xxx = remStr.split(" OR ");
          for (int a = 0; a < xxx.length; a++) {
            if (widget.filterx.size != null) {
              for (int q = 0; q < widget.filterx.size.length; q++) {
                if ("tag:" + widget.filterx.size[q].toString() == "${xxx[a]}") {
                  size.add("${xxx[a]}");
                }
              }
            }

            if (widget.filterx.type != null) {
              for (int q = 0; q < widget.filterx.type.length; q++) {
                if ("tag:" + widget.filterx.type[q].toString() == "${xxx[a]}") {
                  type.add("${xxx[a]}");
                }
              }
            }
            if (widget.filterx.colors != null) {
              for (int q = 0; q < widget.filterx.colors.length; q++) {
                if ("tag:" +
                        widget.filterx.colors[q].split("(")[0].toString() ==
                    "${xxx[a]}") {
                  color.add("${xxx[a]}");
                }
              }
            }

            if (widget.filterx.price != null) {
              for (int q = 0; q < widget.filterx.price.length; q++) {
                if ("tag:" + widget.filterx.price[q].toString() ==
                    "${xxx[a]}") {
                  price.add("${xxx[a]}");
                }
              }
            }
          }
        } else {
          if (widget.filterx.size != null) {
            for (int q = 0; q < widget.filterx.size.length; q++) {
              if ("tag:" + widget.filterx.size[q].toString() == "${xyz[i]}") {
                size.add("${xyz[i]}");
              }
            }
          }

          if (widget.filterx.type != null) {
            for (int q = 0; q < widget.filterx.type.length; q++) {
              if ("tag:" + widget.filterx.type[q].toString() == "${xyz[i]}") {
                type.add("${xyz[i]}");
              }
            }
          }

          if (widget.filterx.colors != null) {
            for (int q = 0; q < widget.filterx.colors.length; q++) {
              if (widget.filterx.colors[q].split("(")[0].toString() ==
                  "${xyz[i]}") {
                color.add("${xyz[i]}");
              }
            }
          }
          if (widget.filterx.price != null) {
            for (int q = 0; q < widget.filterx.price.length; q++) {
              if ("tag:" + widget.filterx.price[q].toString() == "${xyz[i]}") {
                price.add("${xyz[i]}");
              }
            }
          }
        }
      }
    }
  }

  List allTags = [];
  List prices = [];
  List colors = [];
  List types = [];
  List sizes = [];

  getJsonData() async {
    final jsonValue = await http.Client().get(Uri.parse(apiUrl));
    var document = parse(jsonValue.body);
    var responseBody = (document.body.innerHtml);
    var parsedJson = json.decode(responseBody);
    allTags = parsedJson['tags'];
    for (int i = 0; i < parsedJson['tags'].length; i++) {
      if (filterPrice.length != 0) {
        if (filterPrice.contains(parsedJson['tags'][i])) {
          prices.add(parsedJson['tags'][i]);
          print(prices.toString());
        }
      }
      if (filterSizes.length != 0) {
        if (filterSizes.contains(parsedJson['tags'][i])) {
          sizes.add(parsedJson['tags'][i]);
          print(sizes.toString());
        }
      }
      if (filterTypes.length != 0) {
        if (filterTypes.contains(parsedJson['tags'][i])) {
          types.add(parsedJson['tags'][i]);
          print(types.toString());
        }
      }
      if (filterColors.length != 0) {
        if (filterColors.contains(parsedJson['tags'][i])) {
          colors.add(parsedJson['tags'][i]);
          print(colors.toString());
        }
      }
    }
    setState(() {});

    return allTags;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(
        accentColor: Theme.of(context).primaryColorLight,
        dividerColor: Colors.transparent);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'Filters',
          style: AppTheme.TextTheme.boldText,
        ),
        leading: InkWell(
            onTap: () {
              if (clearList) {
                filtersData.colors.clear();
                filtersData = new FiltersModel.empty();
                onSet(false);
                Navigator.of(context).pop();
              } else if (size.isEmpty &&
                  price.isEmpty &&
                  color.isEmpty &&
                  type.isEmpty) {
                Navigator.of(context).pop();
              } else {
                if (size.isNotEmpty) {
                  String s = size.join(' OR ');
                  filtersData.colors.add("($s)");
                }
                if (price.isNotEmpty) {
                  String s = price.join(' OR ');
                  filtersData.colors.add("($s)");
                }
                if (color.isNotEmpty) {
                  String s = color.join(' OR ');
                  filtersData.colors.add("($s)");
                }
                if (type.isNotEmpty) {
                  String s = type.join(' OR ');
                  filtersData.colors.add("($s)");
                }
                Provider.of<FilterNotifier>(context, listen: false)
                    .setFiltersStatus(true);
                onSet(true);
                Navigator.of(context).pop(filtersData);
              }
            },
            child: Icon(Icons.arrow_back_ios)),
        actions: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: InkWell(
                  onTap: () {
                    setState(() {
                      size.clear();
                      price.clear();
                      type.clear();
                      color.clear();
                      filtersData = new FiltersModel.empty();
                      onSet(false);
                      clearList = true;
                    });
                  },
                  child: Center(child: Text('Clear Filter'))))
        ],
      ),
      body: Container(
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 65),
              child: SingleChildScrollView(child: Consumer(builder:
                  (BuildContext context, FilterNotifier filterNotifier, _) {
                if (filterNotifier == null) {
                  return LoadingAnimation();
                }
                return Column(
                  children: <Widget>[
                    Theme(
                      data: theme,
                      child: ExpansionTile(
                          initiallyExpanded: widget.isFilters ? false : true,
                          title: Text(
                            'Sort: ${sortingModelList[filterNotifier.sortingIndex].sortingString}',
                            style: AppTheme.TextTheme.boldText,
                          ),
                          children: List.generate(
                            sortingModelList.length,
                            (index) => InkWell(
                              onTap: () {
                                filterNotifier.indexUpdate(index);
                                if (index == 2 ||
                                    index == 6 ||
                                    index == 4 ||
                                    index == 7) {
                                  sorting(true,
                                      sortingModelList[index].sortingValue);
                                } else {
                                  sorting(false,
                                      sortingModelList[index].sortingValue);
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 20, top: 6),
                                    height: 7,
                                    width: 7,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            index == filterNotifier.sortingIndex
                                                ? Colors.black
                                                : Colors.white),
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(left: 5, top: 6),
                                      child: Text(
                                        '${sortingModelList[index].sortingString}',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(height: 1.3),
                                      )),
                                ],
                              ),
                            ),
                          )),
                    ),
                    widget.isFilters
                        ? colors.length == 0 &&
                                sizes.length == 0 &&
                                prices.length == 0 &&
                                types.length == 0
                            ? Container()
                            : Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.only(top: 5),
                                    child: Divider(
                                      color: Colors.grey,
                                      height: 1,
                                      thickness: 1,
                                    ),
                                  ),
                                  sizes.length != 0
                                      ? Theme(
                                          data: theme,
                                          child: ExpansionTile(
                                            title: Text(
                                              'Size',
                                              style:
                                                  AppTheme.TextTheme.boldText,
                                            ),
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: GridView.count(
                                                  shrinkWrap: true,
                                                  crossAxisCount: 3,
                                                  mainAxisSpacing: 10,
                                                  crossAxisSpacing: 10,
                                                  childAspectRatio: 2.5,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  children: List.generate(
                                                      sizes.length,
                                                      (index) => InkWell(
                                                            onTap: () {
                                                              size.contains(
                                                                      "tag:" +
                                                                          sizes[index]
                                                                              .toString())
                                                                  ? size.remove("tag:" +
                                                                      sizes[index]
                                                                          .toString())
                                                                  : size.add("tag:" +
                                                                      sizes[index]
                                                                          .toString());
                                                              clearList = false;

                                                              setState(() {});
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: size.contains("tag:" +
                                                                          sizes[index]
                                                                              .toString())
                                                                      ? Colors.grey[
                                                                          300]
                                                                      : Colors
                                                                          .transparent,
                                                                  border: Border.all(
                                                                      width:
                                                                          0.5,
                                                                      color: size.contains("tag:" +
                                                                              sizes[index]
                                                                                  .toString())
                                                                          ? Colors
                                                                              .black
                                                                          : Colors
                                                                              .grey[600])),
                                                              child: Center(
                                                                  child:
                                                                      AutoSizeText(
                                                                sizes[index]
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: size.contains("tag:" +
                                                                            sizes[index]
                                                                                .toString())
                                                                        ? Colors
                                                                            .black
                                                                        : Colors.grey[
                                                                            600],
                                                                    fontSize:
                                                                        16),
                                                                maxLines: 1,
                                                              )),
                                                            ),
                                                          )),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  colors.length != 0
                                      ? Theme(
                                          data: theme,
                                          child: ExpansionTile(
                                            title: Text(
                                              'Colors',
                                              style:
                                                  AppTheme.TextTheme.boldText,
                                            ),
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: GridView.count(
                                                  shrinkWrap: true,
                                                  crossAxisCount: 4,
                                                  mainAxisSpacing: 10,
                                                  crossAxisSpacing: 10,
                                                  childAspectRatio: 2.1,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  children: List.generate(
                                                      colors.length,
                                                      (index) => InkWell(
                                                            onTap: () {
                                                              color.contains(
                                                                      "tag:" +
                                                                          colors[index]
                                                                              .toString())
                                                                  ? color.remove("tag:" +
                                                                      colors[index]
                                                                          .toString())
                                                                  : color.add("tag:" +
                                                                      colors[index]
                                                                          .toString());

                                                              clearList = false;
                                                              setState(() {});
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: color.contains("tag:" +
                                                                          colors[index]
                                                                              .toString())
                                                                      ? Colors.grey[
                                                                          300]
                                                                      : Colors
                                                                          .transparent,
                                                                  border: Border.all(
                                                                      width:
                                                                          0.5,
                                                                      color: color.contains("tag:" +
                                                                              colors[index]
                                                                                  .toString())
                                                                          ? Colors
                                                                              .black
                                                                          : Colors
                                                                              .grey[600])),
                                                              child: Center(
                                                                  child:
                                                                      AutoSizeText(
                                                                colors[index],
                                                                style:
                                                                    TextStyle(
                                                                  color: color.contains("tag:" +
                                                                          colors[index]
                                                                              .toString())
                                                                      ? Colors
                                                                          .black
                                                                      : Colors.grey[
                                                                          600],
                                                                  fontSize: 16,
                                                                ),
                                                                maxLines: 1,
                                                              )),
                                                            ),
                                                          )),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  prices.length != 0
                                      ? Theme(
                                          data: theme,
                                          child: ExpansionTile(
                                            title: Text(
                                              'Price',
                                              style:
                                                  AppTheme.TextTheme.boldText,
                                            ),
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: GridView.count(
                                                  crossAxisCount: 2,
                                                  mainAxisSpacing: 10,
                                                  crossAxisSpacing: 10,
                                                  childAspectRatio: 4.5,
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  children: List.generate(
                                                      prices.length,
                                                      (index) => InkWell(
                                                            onTap: () {
                                                              price.contains(
                                                                      "tag:" +
                                                                          prices[index]
                                                                              .toString())
                                                                  ? price.remove("tag:" +
                                                                      prices[index]
                                                                          .toString())
                                                                  : price.add("tag:" +
                                                                      prices[index]
                                                                          .toString());
                                                              clearList = false;

                                                              setState(() {});
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: price.contains("tag:" +
                                                                          prices[index]
                                                                              .toString())
                                                                      ? Colors.grey[
                                                                          300]
                                                                      : Colors
                                                                          .transparent,
                                                                  border: Border.all(
                                                                      width:
                                                                          0.5,
                                                                      color: price.contains("tag:" +
                                                                              prices[index]
                                                                                  .toString())
                                                                          ? Colors
                                                                              .black
                                                                          : Colors
                                                                              .grey[600])),
                                                              child: Center(
                                                                  child:
                                                                      AutoSizeText(
                                                                prices[index],
                                                                style: TextStyle(
                                                                    color: price.contains("tag:" +
                                                                            prices[index]
                                                                                .toString())
                                                                        ? Colors
                                                                            .black
                                                                        : Colors
                                                                            .grey[600]),
                                                                maxLines: 1,
                                                              )),
                                                            ),
                                                          )),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  types.length != 0
                                      ? Theme(
                                          data: theme,
                                          child: ExpansionTile(
                                            title: Text(
                                              'Product Type',
                                              style:
                                                  AppTheme.TextTheme.boldText,
                                            ),
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: GridView.count(
                                                  shrinkWrap: true,
                                                  crossAxisCount: 4,
                                                  mainAxisSpacing: 10,
                                                  crossAxisSpacing: 10,
                                                  childAspectRatio: 2.1,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  children: List.generate(
                                                      types.length,
                                                      (index) => InkWell(
                                                            onTap: () {
                                                              type.contains(
                                                                      "tag:" +
                                                                          types[index]
                                                                              .toString())
                                                                  ? type.remove("tag:" +
                                                                      types[index]
                                                                          .toString())
                                                                  : type.add("tag:" +
                                                                      types[index]
                                                                          .toString());
                                                              clearList = false;

                                                              setState(() {});
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: type.contains("tag:" +
                                                                          types[index]
                                                                              .toString())
                                                                      ? Colors.grey[
                                                                          300]
                                                                      : Colors
                                                                          .transparent,
                                                                  border: Border.all(
                                                                      width:
                                                                          0.5,
                                                                      color: type.contains("tag:" +
                                                                              types[index]
                                                                                  .toString())
                                                                          ? Colors
                                                                              .black
                                                                          : Colors
                                                                              .grey[600])),
                                                              child: Center(
                                                                  child:
                                                                      AutoSizeText(
                                                                types[index]
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  color: type.contains("tag:" +
                                                                          types[index]
                                                                              .toString())
                                                                      ? Colors
                                                                          .black
                                                                      : Colors.grey[
                                                                          600],
                                                                  fontSize: 16,
                                                                ),
                                                                maxLines: 1,
                                                              )),
                                                            ),
                                                          )),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      : Container(),
                                ],
                              )
                        : Container()
                  ],
                );
              })),
            ),
            Container(
              height: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      if (clearList) {
                        filtersData.colors.clear();
                        filtersData = new FiltersModel.empty();
                        onSet(false);
                        Navigator.of(context).pop();
                      } else if (size.isEmpty &&
                          price.isEmpty &&
                          color.isEmpty &&
                          type.isEmpty) {
                        Navigator.of(context).pop();
                      } else {
                        if (size.isNotEmpty) {
                          String s = size.join(' OR ');
                          filtersData.colors.add("($s)");
                        }
                        if (price.isNotEmpty) {
                          String s = price.join(' OR ');
                          filtersData.colors.add("($s)");
                        }
                        if (color.isNotEmpty) {
                          String s = color.join(' OR ');
                          filtersData.colors.add("($s)");
                        }
                        if (type.isNotEmpty) {
                          String s = type.join(' OR ');
                          filtersData.colors.add("($s)");
                        }
                        Provider.of<FilterNotifier>(context, listen: false)
                            .setFiltersStatus(true);
                        onSet(true);
                        Navigator.of(context).pop(filtersData);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 5),
                      width: double.infinity,
                      color: Theme.of(context).primaryColorLight,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        'APPLY',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
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
