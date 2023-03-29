import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:outfitters/Database/DatabaseHelper.dart';
import 'package:outfitters/Models/ProductsModel.dart';
import 'package:outfitters/UI/Notifiers/CartNotifier.dart';
import 'package:outfitters/UI/Widgets/ToastClass.dart';
import 'package:outfitters/Utils/s.dart';
import 'package:outfitters/bloc/ProductDetailBloc.dart';
import 'package:provider/provider.dart';

class SizesScreen extends StatefulWidget {
  final List<Productedges> productModel;
  final int item;
  SizesScreen({@required this.productModel, @required this.item})
      : assert(productModel != null),
        assert(item != null);
  @override
  _SizesScreenState createState() =>
      _SizesScreenState(this.productModel, this.item);
}

class _SizesScreenState extends State<SizesScreen>
    with TickerProviderStateMixin {
  final List<Productedges> productModel;

  final int item;
  Duration _duration = Duration(seconds: 1);
  _SizesScreenState(this.productModel, this.item);
  var scroll;
  var scrollController = ScrollController();
  AnimationController _controller, _cartController;
  Animation<Offset> _offsetAnimation, _itemAnimation;
  bool isshow = false;
  bool iscartShow = false;
  var selectedIndex = -1;
  final database = DatabaseHelper.instance;
  bool isScroll = false;
  var swiperControl = new SwiperController();
  List<Variantnode> variantnode = [];
  final formatter = new NumberFormat("#,###,###");
  bool isShowAddToCartBtn = false;

  StreamController<List<Variantnode>> streamController =
      new StreamController<List<Variantnode>>.broadcast();

  @override
  void initState() {
    streamController.add(variantnode);
    variantnode.clear();
    streamController.sink.add(variantnode);
    productDetailBloc.initList();
    selectedIndex = -1;
    productModel[item].productnode.variants.variantedges.forEach((data) {
      if (data.variantnode.available) {
        productDetailBloc.addProductVariant(data.variantnode);
        variantnode.add(data.variantnode);
        streamController.sink.add(variantnode);
      }
    });
    scroll = BouncingScrollPhysics();
    _controller =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    _cartController =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    _offsetAnimation = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
        .animate(_controller);
    _itemAnimation = Tween<Offset>(begin: Offset(10, 0), end: Offset(0, 0))
        .animate(_cartController);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  double screenHeight, screenWidth;
  Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    _itemAnimation = Tween<Offset>(begin: Offset(2, 0), end: Offset(0, 0))
        .animate(_cartController);

    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Spacer(),
                      StreamBuilder<List<Variantnode>>(
                          initialData: productDetailBloc.list,
                          stream: productDetailBloc.getProductVariants,
                          builder: (context, snapshot) {
                            return Container(
                              width: 120,
                              child: SlideTransition(
                                position: _itemAnimation,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isShowAddToCartBtn = false;
                                    });
                                    addtoCartItem(productModel, widget.item,
                                        snapshot.data[selectedIndex]);
                                  },
                                  child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12),
                                      alignment: Alignment.center,
                                      decoration:
                                          BoxDecoration(color: Colors.black),
                                      child: Text(
                                        'Add To Cart',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      )),
                                ),
                              ),
                            );
                          })
                    ],
                  ),
                ),
                S.sDivider(height: 4),
                StreamBuilder<List<Variantnode>>(
                    initialData: productDetailBloc.list,
                    stream: productDetailBloc.getProductVariants,
                    builder: (context, snapshot) {
                      return Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          spacing: 5,
                          runSpacing: 6,
                          alignment: WrapAlignment.start,
                          children: List.generate(
                              snapshot.data.length,
                              (indexItem) => InkWell(
                                    onTap: () {
                                      if (!isShowAddToCartBtn) {
                                        setState(() {
                                          isShowAddToCartBtn = true;
                                          selectedIndex = indexItem;
                                        });
                                        _cartController.reset();
                                        _cartController.forward();
                                      }

                                      setState(() {
                                        selectedIndex = indexItem;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10.0),
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: selectedIndex == indexItem
                                                ? Colors.black
                                                : Colors.transparent,
                                            width: 1.2),
                                      ),
                                      child: Text(
                                        snapshot
                                                        .data[indexItem]
                                                        .selectedOptions[1]
                                                        .value ==
                                                    "WS-20" ||
                                                snapshot
                                                        .data[indexItem]
                                                        .selectedOptions[1]
                                                        .name ==
                                                    "Season"
                                            ? '${snapshot.data[indexItem].selectedOptions[2].value}'
                                            : '${snapshot.data[indexItem].selectedOptions[1].value}',
                                        style: TextStyle(
                                            fontWeight:
                                                selectedIndex == indexItem
                                                    ? FontWeight.w500
                                                    : FontWeight.w400),
                                      ),
                                    ),
                                  )));
                    }),
                S.sDivider(height: 14),
              ],
            ),
          )
        ],
      ),
    ));
  }

  addtoCartItem(List<Productedges> productModel, int productIndex,
      Variantnode variantnode) {
    setState(() {
      iscartShow = false;
    });
    Map<String, dynamic> row = {
      'graphid': variantnode.id,
      'p_name': productModel[productIndex].productnode.title,
      'p_id': productModel[productIndex].productnode.id,
      'p_color': variantnode.selectedOptions[0].value,
      ' p_size': !variantnode.selectedOptions.contains("Size")
          ? (variantnode.selectedOptions[1].value == "WS-20"
              ? variantnode.selectedOptions[2].value
              : variantnode.selectedOptions[1].value)
          : variantnode.selectedOptions[1].value,
      'varient_id': variantnode.id,
      'p_image': productModel[productIndex]
          .productnode
          .images
          .imagesedges
          .first
          .imagesnode
          .src,
      'price': variantnode.price,
      'quantity': 1,
      'compare_price': variantnode.compareAtPrice,
      'sku': variantnode.sku,
      'available': variantnode.available.toString()
    };
    database.insert(row,context).then((val) {
      print('====== back result $val');
      // Toast.showToast(context, 'Add to Cart Successfully!');
      Provider.of<CartNotifier>(context, listen: false).getcart();
    });
  }
}
