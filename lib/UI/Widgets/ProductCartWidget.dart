import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:outfitters/Database/DatabaseHelper.dart';
import 'package:outfitters/Models/ProductsModel.dart';
import 'package:outfitters/UI/Notifiers/CartNotifier.dart';
import 'package:outfitters/UI/Screens/AboutOutfitters.dart';
import "package:flutter/src/widgets/image.dart" as Image;
import 'package:outfitters/UI/Screens/BuyingGuide.dart';
import 'package:outfitters/UI/Screens/ImageZoom.dart';
import 'package:outfitters/UI/Screens/ProductDetails.dart';
import 'package:outfitters/UI/Screens/SizeChartScreen.dart';
import 'package:outfitters/UI/Screens/WearWithProducts.dart';
import 'package:outfitters/UI/Screens/compositionAndCare.dart';
import 'package:outfitters/UI/Widgets/PhotoItem2.dart';
import 'package:outfitters/UI/Widgets/ToastClass.dart';
import 'package:outfitters/UI/Widgets/WishHeart.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;
import 'package:outfitters/bloc/ProductDetailBloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ProductCartWidget extends StatefulWidget {
  final productDetails, cValue;
  const ProductCartWidget({Key key, this.productDetails, this.cValue})
      : super(key: key);

  @override
  State<ProductCartWidget> createState() => _ProductCartWidgetState();
}

class _ProductCartWidgetState extends State<ProductCartWidget>
    with TickerProviderStateMixin {
  var scroll;
  var scrollController = ScrollController();
  AnimationController _controller, _cartController;
  Animation<Offset> _offsetAnimation, _itemAnimation;
  bool isshow = false;
  bool iscartShow = false;
  var selectedIndex = -1;
  List imgList = [];
  List proSold = [];
  List proSold2 = [];

  final database = DatabaseHelper.instance;
  bool isScroll = false;
  var swiperControl = new SwiperController();
  List<Variantnode> variantnode = [];
  StreamController<List<Variantnode>> streamController =
      new StreamController<List<Variantnode>>.broadcast();
  ScrollController _scrollController = new ScrollController();
  final formatter = new NumberFormat("#,###,###");

  @override
  void initState() {
    scroll = BouncingScrollPhysics();
    _controller =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    _cartController =
        AnimationController(duration: Duration(milliseconds: 250), vsync: this);
    _offsetAnimation = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
        .animate(_controller);
    _itemAnimation = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
        .animate(_cartController);

    if (widget.productDetails.options[0].values.length == 1) {
      proSold.add(0);
      proSold2.add(0);
    } else {
      for (int i = 0; i < widget.productDetails.options[0].values.length; i++) {
        for (int j = 0;
            j < widget.productDetails.options[1].values.length;
            j++) {
          if (widget
              .productDetails
              .variants
              .variantedges[
                  j + (widget.productDetails.options[1].values.length * i)]
              .variantnode
              .available) {
            for (int k = 0;
                k < widget.productDetails.images.imagesedges.length;
                k++) {
              if (widget.productDetails.images.imagesedges[k].imagesnode
                      .altText ==
                  widget.productDetails.options.first.values[i]) {
                proSold.add(i);
                proSold2.add(k);

                break;
              }
            }
            break;
          }
        }
      }
    }

    widget.productDetails.images.imagesedges
        .where((element) =>
            element.imagesnode.altText ==
            widget
                .productDetails.options.first.values[int.parse(widget.cValue)])
        .forEach((item) {
      imgList.add(item.imagesnode.src);
    });
    if (imgList.isEmpty) {
      for (int i = 0;
          i < widget.productDetails.images.imagesedges.length;
          i++) {
        if (widget.productDetails.images.imagesedges[i].imagesnode.altText ==
            null) {
          imgList
              .add(widget.productDetails.images.imagesedges[i].imagesnode.src);
        }
      }
    }

    for (int i = 0; i < widget.productDetails.options[1].values.length; i++) {
      print(i +
          (widget.productDetails.options[1].values.length *
              int.parse(widget.cValue)));
      if (widget
          .productDetails
          .variants
          .variantedges[i +
              (widget.productDetails.options[1].values.length *
                  int.parse(widget.cValue))]
          .variantnode
          .available) {
        variantnode.add(widget
            .productDetails
            .variants
            .variantedges[i +
                (widget.productDetails.options[1].values.length *
                    int.parse(widget.cValue))]
            .variantnode);
        streamController.sink.add(variantnode);
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
        height: (MediaQuery.of(context).size.height - kToolbarHeight) * 0.85,
        child: Swiper(
          itemBuilder: (BuildContext context, int position) {
            return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GalleryExample(
                                imagesList: imgList,
                              ),
                          settings: RouteSettings(name: 'Zoom Images List')));
                },
                child: PhotoItem2(imageUrl: imgList[position]));
          },
          autoplay: false,
          itemCount: imgList.length,
          loop: false,
          physics: scroll,
          onIndexChanged: (v) {
            if (v == imgList.length - 1) {
              scrollController
                  .jumpTo(scrollController.position.maxScrollExtent);
              setState(() {
                isScroll = true;
              });
            } else {
              scrollController
                  .jumpTo(scrollController.position.minScrollExtent);
              setState(() {
                isScroll = false;
              });
            }
          },
          scrollDirection: Axis.vertical,
          pagination: new SwiperPagination(
              alignment: FractionalOffset.centerLeft,
              margin: EdgeInsets.only(left: 20),
              builder: DotSwiperPaginationBuilder(
                  activeColor: Colors.black, color: Colors.grey[700])),
        ),
      ),
      SizedBox(
        height: (MediaQuery.of(context).size.height - kToolbarHeight) * 0.20,
      ),
      widget.productDetails.tags != null &&
              widget.productDetails.tags.contains('Ritem')
          ? WearWithProducts(
              taglist: widget.productDetails.tags,
            )
          : SizedBox(),
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 50, left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                WishHeart(
                  graphid: widget.productDetails.id,
                  image: imgList.first,
                  name: widget.productDetails.title,
                  value: widget.cValue.toString(),
                  price: widget.productDetails.variants.variantedges[0]
                      .variantnode.price,
                  onlinestoreUrl: widget.productDetails.onlineStoreUrl,
                  // available:widget.productDetails.variants
                  // .variantedges[0].variantnode.available.toString() ,
                ),
                InkWell(
                  onTap: () {
                    if (isshow) {
                      isshow = false;
                      _controller.reverse();
                    } else {
                      isshow = true;
                      _controller.forward();
                    }

                    iscartShow = false;
                    setState(() {});
                  },
                  child: Container(
                    margin:
                        EdgeInsets.only(bottom: 10, top: 10, left: 3, right: 3),
                    padding:
                        EdgeInsets.only(bottom: 2, top: 2, left: 3, right: 3),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: isshow == false
                        ? Text('INFO',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ))
                        : Text('CLOSE',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            )),
                  ),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () => _shareStoreUrl(widget.productDetails.onlineStoreUrl),
            child: Container(
              margin: EdgeInsets.only(top: 15, left: 20, right: 20),
              child: Icon(
                Feather.share,
                size: 26,
              ),
            ),
          ),
        ],
      ),
      isshow
          ? SlideTransition(
              position: _offsetAnimation,
              child: Container(
                  margin: EdgeInsets.only(top: 80),
                  padding: EdgeInsets.symmetric(vertical: 30),
                  color: Colors.white.withOpacity(0.90),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 20),
                            child: Text(
                              '${widget.productDetails.title}',
                              style: AppTheme.TextTheme.boldText,
                            )),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 1, horizontal: 20),
                            child: Text(
                                '${widget.productDetails.variants.variantedges.first.variantnode.sku}',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: "BentonSans",
                                  height: 1.4,
                                  fontSize: 12,
                                ))),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 1, horizontal: 20),
                            child: Text(
                                '${widget.productDetails.description}'
                                        .contains("Size & Fits")
                                    ? '${widget.productDetails.description}'
                                        .split('Size & Fits')[1]
                                        ?.replaceFirst(
                                            RegExp(r"\Composition[^]*"), "")
                                    : '${widget.productDetails.description}'
                                                .contains("(model-data)") ||
                                            '${widget.productDetails.description}'
                                                .contains("model-data)")
                                        ? '${widget.productDetails.description}'
                                            .split('(model-data)')[1]
                                            ?.replaceFirst(
                                                RegExp(
                                                    r"\((model-data-end)[^]*"),
                                                "")
                                        : "",
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: "BentonSans",
                                  height: 1.4,
                                  fontSize: 12,
                                ))),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              // margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Colors: ',
                                style: TextStyle(
                                  fontFamily: 'Avenir',
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                widget.productDetails.options.first
                                    .values[int.parse(widget.cValue)],
                                style: TextStyle(
                                    fontFamily: 'Avenir',
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 80,
                          child: ListView.builder(
                              itemCount: proSold.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int i) {
                                return InkWell(
                                  onTap: () => Navigator.of(context)
                                      .pushReplacement(PageTransition(
                                          child: ProductDetails(
                                              productModel:
                                                  widget.productDetails,
                                              item: 0,
                                              cValue: proSold[i],
                                              sizesL: widget.productDetails
                                                  .options[1].values.length,
                                              leng: widget.productDetails
                                                  .options[0].values.length),
                                          type: PageTransitionType.fade,
                                          settings: RouteSettings(
                                              name: 'Product Details'))),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: int.parse(widget.cValue) ==
                                                    proSold[i]
                                                ? Colors.black
                                                : Colors.transparent)),
                                    margin: EdgeInsets.only(left: 15, top: 5),
                                    height: 70,
                                    width: 70,
                                    child: Image.Image.network(widget
                                        .productDetails
                                        .images
                                        .imagesedges[proSold2[i]]
                                        .imagesnode
                                        .src
                                        .toString()),
                                  ),
                                );
                              }),
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context).push(
                            PageTransition(
                                child: CompositionAndCare(
                                    descriptionHtml: widget
                                                .productDetails.descriptionHtml
                                                .contains("(model-data)") ||
                                            widget
                                                .productDetails.descriptionHtml
                                                .contains("model-data)")
                                        ? widget.productDetails.descriptionHtml
                                            .split('(model-data)')[1]
                                            ?.replaceFirst(
                                                RegExp(
                                                    r"\((model-data-end)[^]*"),
                                                "")
                                        : widget
                                            .productDetails.descriptionHtml),
                                type: PageTransitionType.bottomToTop),
                          ),
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 40),
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    top: BorderSide(
                                        color: Colors.grey[400], width: 3))),
                            child: Text(
                              'Composition and Care',
                              style: TextStyle(letterSpacing: 0.2),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            String text = "SimplifiedSizechart";
                            final tagList = widget.productDetails.tags;
                            tagList.forEach((item) {
                              if (item.contains(text)) {
                                Navigator.of(context).push(PageTransition(
                                    child: SizeChartScreen(sizechart: item),
                                    type: PageTransitionType.bottomToTop,
                                    settings:
                                        RouteSettings(name: 'Size Chart')));
                              } else {
                                Toast.showToast(context, "No size chart found");
                              }
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    top: BorderSide(
                                        color: Colors.grey[400], width: 1))),
                            child: Text('Size Guide',
                                style: TextStyle(letterSpacing: 0.2)),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AboutOutfitters(
                                        name: "Privacy Policy",
                                        url:
                                            "https://outfitters.com.pk/pages/privacy-policy-mobile-app"),
                                    settings: RouteSettings(
                                        name: 'AboutOutfitters')));
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    top: BorderSide(
                                        color: Colors.grey[400], width: 1),
                                    bottom: BorderSide(
                                        color: Colors.grey[400], width: 1))),
                            child: Text('Privacy Policy',
                                style: TextStyle(letterSpacing: 0.2)),
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context).push(
                              PageTransition(
                                  child: BuyingGuide(),
                                  type: PageTransitionType.bottomToTop)),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey[400], width: 3))),
                            child: Text('Buying Guide',
                                style: TextStyle(letterSpacing: 0.2)),
                          ),
                        ),
                      ],
                    ),
                  )))
          : SizedBox(),
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(seconds: 1),
            margin: isScroll &&
                    widget.productDetails.tags != null &&
                    widget.productDetails.tags.contains('Ritem')
                ? EdgeInsets.only(
                    bottom:
                        (MediaQuery.of(context).size.height - kToolbarHeight) *
                            0.25,
                  )
                : EdgeInsets.only(
                    bottom:
                        (MediaQuery.of(context).size.height - kToolbarHeight) *
                            0.03,
                  ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    iscartShow
                        ? Container(
                            child: Column(
                                children: List.generate(
                                    variantnode.length,
                                    (indexItem) => Stack(
                                          children: <Widget>[
                                            InkWell(
                                              onTap: () {
                                                selectedIndex = indexItem;
                                                _cartController.reset();
                                                _cartController.forward();

                                                setState(() {});
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 12,
                                                    horizontal: 10),
                                                decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey,
                                                            width: 1))),
                                                child: Text(variantnode[
                                                                    indexItem]
                                                                .selectedOptions[
                                                                    1]
                                                                .value ==
                                                            "WS-20" ||
                                                        variantnode[indexItem]
                                                                .selectedOptions[
                                                                    1]
                                                                .name ==
                                                            "Season"
                                                    ? '${variantnode[indexItem].selectedOptions[2].value}'
                                                    : '${variantnode[indexItem].selectedOptions[1].value}'),
                                              ),
                                            ),
                                            selectedIndex == indexItem
                                                ? Container(
                                                    width: double.infinity,
                                                    child: SlideTransition(
                                                      position: _itemAnimation,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () {
                                                              addtoCartItem(
                                                                  widget
                                                                      .productDetails,
                                                                  variantnode[
                                                                      indexItem]);
                                                            },
                                                            child: Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    2,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            12,
                                                                        horizontal:
                                                                            10),
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .black),
                                                                child: Text(
                                                                  'Add To Cart',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox(),
                                          ],
                                        ))),
                          )
                        : SizedBox(),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 2, left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          color: Colors.white,
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                "Rs. " +
                                    formatter.format(double.parse(widget
                                        .productDetails
                                        .variants
                                        .variantedges
                                        .first
                                        .variantnode
                                        .price
                                        .toString())),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: widget
                                                .productDetails
                                                .variants
                                                .variantedges
                                                .first
                                                .variantnode
                                                .price !=
                                            widget
                                                .productDetails
                                                .variants
                                                .variantedges
                                                .first
                                                .variantnode
                                                .compareAtPrice
                                        ? Colors.red
                                        : Colors.black),
                              ),
                              widget.productDetails.variants.variantedges.first
                                          .variantnode.price !=
                                      widget
                                          .productDetails
                                          .variants
                                          .variantedges
                                          .first
                                          .variantnode
                                          .compareAtPrice
                                  ? Text(
                                      formatter.format(double.parse(widget
                                          .productDetails
                                          .variants
                                          .variantedges
                                          .first
                                          .variantnode
                                          .compareAtPrice
                                          .toString())),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          decoration:
                                              TextDecoration.lineThrough),
                                    )
                                  : SizedBox()
                            ],
                          )),
                      StreamBuilder<List<Variantnode>>(
                          stream: streamController.stream,
                          initialData: variantnode,
                          builder: (context, snapshot) {
                            print('====== varient ${snapshot.data.length}');
                            if (snapshot.data.length > 0) {
                              return InkWell(
                                onTap: () {
                                  if (widget.productDetails.variants
                                          .variantedges.length ==
                                      1) {
                                    addtoCartItem(
                                        widget.productDetails, variantnode[0]);
                                  } else {
                                    iscartShow = !iscartShow;
                                    isshow = false;
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 6),
                                  color: Colors.black,
                                  child: iscartShow
                                      ? Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.white,
                                        )
                                      : Text(
                                          'ADD',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                ),
                              );
                            } else {
                              return Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 12),
                                  color: Colors.grey,
                                  child: Text(
                                    'Sold Out',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ));
                            }
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    ]));
  }

  addtoCartItem(Productnode productModel, Variantnode variantnode) {
    setState(() {
      iscartShow = false;
    });
    Map<String, dynamic> row = {
      'graphid': variantnode.id,
      'p_name': productModel.title,
      'p_id': productModel.id,
      'p_color': variantnode.selectedOptions[0].value,
      'p_size': !variantnode.selectedOptions.contains("Size")
          ? (variantnode.selectedOptions[1].value == "WS-20" ||
                  variantnode.selectedOptions[1].value == "Summer-20" ||
                  variantnode.selectedOptions[1].value == "Summer-19"
              ? variantnode.selectedOptions[2].value
              : variantnode.selectedOptions[1].value)
          : variantnode.selectedOptions[0].value,
      'varient_id': variantnode.id,
      "p_value": widget.cValue.toString(),
      'p_image': imgList[0],
      'price': variantnode.price,
      'quantity': 1,
      'compare_price': variantnode.compareAtPrice,
      'sku': variantnode.sku,
      'available': variantnode.available.toString()
    };
    database.insert(row, context).then((val) {
      print('====== back result $val');
      Toast.showToast(context, 'Added to Cart Successfully!');
      Provider.of<CartNotifier>(context, listen: false).getcart();
    });
  }

  // addtoCartItem(
  //   productDetails,
  //   Variantnode variantnode,
  //   String productId,
  // ) {
  //   setState(() {
  //     iscartShow = false;
  //   });
  //   Map<String, dynamic> row = {
  //     'graphid': variantnode.id,
  //     'p_name': widget.productDetails,
  //     'p_id': productId,
  //     'p_color': variantnode.selectedOptions[0].value,
  //     ' p_size': !variantnode.selectedOptions.contains("Size")
  //         ? (variantnode.selectedOptions[1].value == "WS-20"
  //             ? variantnode.selectedOptions[2].value
  //             : variantnode.selectedOptions[1].value)
  //         : variantnode.selectedOptions[1].value,
  //     'varient_id': variantnode.id,
  //     "p_value": widget.cValue.toString(),
  //     'p_image': imgList[0],
  //     'price': variantnode.price,
  //     'quantity': 1,
  //     'compare_price': variantnode.compareAtPrice,
  //     'sku': variantnode.sku,
  //     'available': variantnode.available.toString()
  //   };
  //   database.insert(row).then((val) {
  //     print('====== back result $val');
  //     Toast.showToast(context, 'Add to Cart Successfully!');
  //     Provider.of<CartNotifier>(context, listen: false).getcart();
  //   });
  // }

  _shareStoreUrl(String storeUrl) {
    final RenderBox box = context.findRenderObject();
    Share.share(storeUrl,
        subject: "Outfitters",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
