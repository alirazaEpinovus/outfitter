import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:outfitters/Database/DatabaseHelper.dart';
import 'package:outfitters/Models/ProductsModel.dart';
import "package:flutter/src/widgets/image.dart" as Image;
import 'package:outfitters/Models/SizeChartModel.dart';
import 'package:outfitters/UI/Notifiers/CartNotifier.dart';
import 'package:outfitters/UI/Screens/AboutOutfitters.dart';
import 'package:outfitters/UI/Screens/BuyingGuide.dart';
import 'package:outfitters/UI/Screens/ImageZoom.dart';
import 'package:outfitters/UI/Screens/SizeChart.dart';
import 'package:outfitters/UI/Screens/SizeChartScreen.dart';
import 'package:outfitters/UI/Screens/WearWithProducts.dart';
import 'package:outfitters/UI/Screens/compositionAndCare.dart';
import 'package:outfitters/UI/Widgets/CartIconWidget.dart';
import 'package:outfitters/UI/Widgets/PhotoItem2.dart';
import 'package:outfitters/UI/Widgets/SoldOutTag.dart';
import 'package:outfitters/UI/Widgets/ToastClass.dart';
import 'package:outfitters/UI/Widgets/WishHeart.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;
import 'package:outfitters/Utils/Helper.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ProductDetails extends StatefulWidget {
  final Productnode productModel;
  final int item, leng, cValue, sizesL;
  ProductDetails(
      {@required this.productModel,
      @required this.item,
      @required this.cValue,
      @required this.leng,
      @required this.sizesL})
      : assert(productModel != null),
        assert(item != null);
  @override
  _ProductDetailsState createState() => _ProductDetailsState(
      this.productModel, this.item, this.cValue, this.leng, this.sizesL);
}

class _ProductDetailsState extends State<ProductDetails>
    with TickerProviderStateMixin {
  // final ProductModel productModel;
  final Productnode productModel;

  final int item, leng, cValue, sizesL;
  Duration _duration = Duration(seconds: 1);
  _ProductDetailsState(
      this.productModel, this.item, this.cValue, this.leng, this.sizesL);
  var scroll;
  var scrollController = ScrollController();
  AnimationController _controller, _cartController;
  Animation<Offset> _offsetAnimation, _itemAnimation;
  bool isshow = false;
  bool showSizes = false;
  bool iscartShow = false;
  List proSold = [];
  List proSold2 = [];
  List imgList = [];

  var selectedIndex = -1;
  final database = DatabaseHelper.instance;
  bool isScroll = false;
  var swiperControl = new SwiperController();
  List<Variantnode> variantnode = [];
  final formatter = new NumberFormat("#,###,###");
  bool isShowAddToCartBtn = false;

  StreamController<List<Variantnode>> streamController =
      new StreamController<List<Variantnode>>.broadcast();
  String text = "SimplifiedSizechart";
  var simpleTag;

  bool tagCheck = false;

  @override
  void initState() {
    productModel.tags.forEach((item) {
      if (item.contains(text)) {
        setState(() {
          simpleTag = item;
          tagCheck = true;
        });
      }
    });
    streamController.add(variantnode);
    variantnode.clear();
    streamController.sink.add(variantnode);
    selectedIndex = -1;

    if (leng == 1) {
      proSold.add(0);
      proSold2.add(0);
    } else {
      for (int i = 0; i < leng; i++) {
        for (int j = 0; j < sizesL; j++) {
          if (productModel
              .variants.variantedges[j + (sizesL * i)].variantnode.available) {
            for (int k = 0; k < productModel.images.imagesedges.length; k++) {
              if (productModel.images.imagesedges[k].imagesnode.altText ==
                  productModel.options.first.values[i]) {
                print(
                    "${productModel.images.imagesedges[k].imagesnode.altText} == ${productModel.options.first.values[i]}  $k");
                proSold.add(i);
                proSold2.add(k);
                print(proSold.toString());
                break;
              }
            }
            break;
          }
        }
      }
    }
    imgList.clear();

    productModel.images.imagesedges
        .where((element) =>
            element.imagesnode.altText ==
            productModel.options.first.values[cValue])
        .forEach((item) {
      imgList.add(item.imagesnode.src);
    });
    if (imgList.isEmpty) {
      for (int i = 0; i < productModel.images.imagesedges.length; i++) {
        if (productModel.images.imagesedges[i].imagesnode.altText == null) {
          imgList.add(productModel.images.imagesedges[i].imagesnode.src);
        }
      }
    }

    for (int i = 0; i < sizesL; i++) {
      print(i + (sizesL * cValue));
      if (productModel
          .variants.variantedges[i + (sizesL * cValue)].variantnode.available) {
        variantnode.add(productModel
            .variants.variantedges[i + (sizesL * cValue)].variantnode);
        streamController.sink.add(variantnode);
      }
    }
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          elevation: 2,
          title: Text(
            productModel.title,
            // productModel.title,
            style: AppTheme.TextTheme.smallboldText,
          ),
          actions: <Widget>[CartIconWidget()],
        ),
        body: Center(
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: <Widget>[
                  Stack(
                    children: [
                      Align(
                        alignment: FractionalOffset.topCenter,
                        child: ListView(
                          controller: scrollController,
                          shrinkWrap: true,
                          children: [
                            Container(
                              height: (MediaQuery.of(context).size.height -
                                      kToolbarHeight) *
                                  0.75,
                              width: MediaQuery.of(context).size.width,
                              child: Swiper(
                                itemBuilder:
                                    (BuildContext context, int position) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  GalleryExample(
                                                    imagesList: imgList,
                                                  ),
                                              settings: RouteSettings(
                                                  name: 'Zoom Images List')));
                                    },
                                    child:
                                        PhotoItem2(imageUrl: imgList[position]),
                                  );
                                },
                                autoplay: false,
                                itemCount: imgList.length,
                                loop: false,
                                physics: scroll,
                                onIndexChanged: (v) {
                                  if (v == imgList.length - 1) {
                                    scrollController.jumpTo(scrollController
                                        .position.maxScrollExtent);
                                    setState(() {
                                      isScroll = true;
                                    });
                                  } else {
                                    scrollController.jumpTo(scrollController
                                        .position.minScrollExtent);
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
                                        activeColor: Colors.grey[400],
                                        color: Colors.black38)),
                              ),
                            ),
                            productModel.tags != null &&
                                    productModel.tags.contains('Ritem')
                                ? WearWithProducts(taglist: productModel.tags)
                                : SizedBox()
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 0,
                        left: 0,
                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Center(
                            child: iscartShow
                                ? Column(
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
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 12,
                                                              horizontal: 10),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(0.5),
                                                          border: Border(
                                                              bottom: BorderSide(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 1))),
                                                      child: Text(
                                                          // "$indexItem --- $sizesL ---$cValue ---${variantnode.length} --- ${indexItem + (sizesL * cValue)}"
                                                          variantnode[indexItem]
                                                                          .selectedOptions[
                                                                              1]
                                                                          .value ==
                                                                      "WS-20" ||
                                                                  variantnode[indexItem]
                                                                          .selectedOptions[1]
                                                                          .name ==
                                                                      "Season"
                                                              ? '${variantnode[indexItem].selectedOptions[2].value}'
                                                              : '${variantnode[indexItem].selectedOptions[1].value}')),
                                                ),
                                                selectedIndex == indexItem
                                                    ? Container(
                                                        width: double.infinity,
                                                        child: SlideTransition(
                                                          position:
                                                              _itemAnimation,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: <Widget>[
                                                              InkWell(
                                                                onTap: () {
                                                                  addtoCartItem(
                                                                      productModel,
                                                                      0,
                                                                      variantnode[
                                                                          indexItem]);
                                                                },
                                                                child:
                                                                    Container(
                                                                        width: MediaQuery.of(context).size.width /
                                                                            2,
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                12,
                                                                            horizontal:
                                                                                10),
                                                                        decoration: BoxDecoration(
                                                                            color: Colors
                                                                                .black),
                                                                        child:
                                                                            Text(
                                                                          'Add To Cart',
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        )),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox(),
                                              ],
                                            )))
                                : Container(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 50, left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            WishHeart(
                                graphid: productModel.id,
                                image: imgList.first,
                                name: productModel.title,
                                price: productModel.variants.variantedges.first
                                    .variantnode.price,
                                value: cValue.toString(),
                                onlinestoreUrl: productModel.onlineStoreUrl),
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
                                margin: EdgeInsets.only(
                                    bottom: 10, top: 10, left: 3, right: 3),
                                padding: EdgeInsets.only(
                                    bottom: 2, top: 2, left: 3, right: 3),
                                decoration: BoxDecoration(
                                    // color: Colors.tr,
                                    ),
                                child: isshow == false
                                    ? Text('INFO',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          decoration: TextDecoration.underline,
                                        ))
                                    : Container(
                                        child: Text('CLOSE',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                decoration:
                                                    TextDecoration.underline)),
                                      ),
                              ),
                            )
                          ],
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
                                          '${productModel.title}',
                                          style: AppTheme.TextTheme.boldText,
                                        )),
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 1, horizontal: 20),
                                        child: Text(
                                            '${productModel.variants.variantedges[0].variantnode.sku}',
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
                                            //  '${productModel[item].description}',
                                            '${productModel.description}'
                                                    .contains("Size & Fits")
                                                ? '${productModel.description}'
                                                    .split('Size & Fits')[1]
                                                    ?.replaceFirst(
                                                        RegExp(
                                                            r"\Composition[^]*"),
                                                        "")
                                                : '${productModel.description}'
                                                            .contains(
                                                                "(model-data)") ||
                                                        '${productModel.description}'
                                                            .contains(
                                                                "model-data)")
                                                    ? '${productModel.description}'
                                                        .split(
                                                            '(model-data)')[1]
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
                                          // margin: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            productModel
                                                .options.first.values[cValue],
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
                                          itemBuilder:
                                              (BuildContext context, int i) {
                                            return InkWell(
                                              onTap: () => Navigator.of(context)
                                                  .pushReplacement(PageTransition(
                                                      child: ProductDetails(
                                                          productModel:
                                                              productModel,
                                                          item: item,
                                                          cValue: proSold[i],
                                                          sizesL: sizesL,
                                                          leng: leng),
                                                      type: PageTransitionType
                                                          .fade,
                                                      settings: RouteSettings(
                                                          name:
                                                              'Product Details'))),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: cValue ==
                                                                proSold[i]
                                                            ? Colors.black
                                                            : Colors
                                                                .transparent)),
                                                margin: EdgeInsets.only(
                                                    left: 15, top: 5),
                                                height: 70,
                                                width: 70,
                                                child: Image.Image.network(
                                                    productModel
                                                        .images
                                                        .imagesedges[
                                                            proSold2[i]]
                                                        .imagesnode
                                                        .src),
                                              ),
                                            );

                                            // productModel
                                            //         .options[index].values
                                            //         .contains(productModel
                                            //
                                            //             .variants
                                            //             .variantedges[index]
                                            //             .variantnode
                                            //             .selectedOptions[0]
                                            //             .value)
                                            //     ? Container(
                                            //         margin: EdgeInsets.only(
                                            //             right: 10, left: 15),
                                            //         height: 70,
                                            //         width: 70,
                                            //         child: Image.Image.network(
                                            //             productModel
                                            //
                                            //                 .variants
                                            //                 .variantedges[index]
                                            //                 .variantnode
                                            //                 .image
                                            //                 .src
                                            //                 .toString()),
                                            //       )
                                            //     : Container();
                                          }),
                                    ),

                                    // Container(
                                    //   margin:
                                    //       EdgeInsets.only(right: 10, left: 10),
                                    //   height: 70, width: 70,

                                    //   // height: screenHeight*0.14,
                                    //   // width: screenWidth*0.14,
                                    //   child: Image.Image.network(productModel
                                    //
                                    //       .images
                                    //       .imagesedges
                                    //       .last
                                    //       .imagesnode
                                    //       .src),
                                    // ),
                                    //      Padding(
                                    // padding: EdgeInsets.symmetric(
                                    //     vertical: 1, horizontal: 20),
                                    // child:
                                    //                                        Html(
                                    //               data: """
                                    //   ${productModel[item].descriptionHtml}
                                    // """,
                                    //               //Optional parameters:

                                    //               //Optional parameters:

                                    //               linkStyle: const TextStyle(
                                    //                 color: Colors.redAccent,
                                    //                 letterSpacing: 1,
                                    //                 height: 1,
                                    //                 decorationColor: Colors.redAccent,
                                    //                 decoration: TextDecoration.underline,
                                    //               ),
                                    //               onLinkTap: (url) {},
                                    //               onImageTap: (src) {},
                                    //               //Must have useRichText set to false for this to work
                                    //               customRender: (node, children) {
                                    //                 if (node is dom.Element) {
                                    //                   // switch (node.localName) {
                                    //                   //   case "custom_tag":
                                    //                   //     return Column(children: children);
                                    //                   // }
                                    //                 }
                                    //                 return null;
                                    //               },
                                    //               // customTextAlign: (dom.Node node) {
                                    //               //   if (node is dom.Element) {
                                    //               //     // switch (node.localName) {
                                    //               //     //   case "p":
                                    //               //     //     return TextAlign.justify;
                                    //               //     // }
                                    //               //   }
                                    //               //   return null;
                                    //               // },
                                    //               // customTextStyle: (dom.Node node, TextStyle baseStyle) {
                                    //               //   if (node is dom.Element) {
                                    //               //     // switch (node.localName) {
                                    //               //     //   case "p":
                                    //               //     //     return baseStyle.merge(TextStyle(height: 2, fontSize: 20));
                                    //               //     // }
                                    //               //   }
                                    //               //   return baseStyle;
                                    //               // },
                                    //             ),
                                    //                                       // Text(
                                    //     '${productModel[item].description}',
                                    //      textAlign: TextAlign.justify,
                                    //     style: TextStyle(
                                    //       color: Colors.black54,
                                    //       fontFamily: "BentonSans",
                                    //       height: 1.4,
                                    //       fontSize: 12,
                                    //     )
                                    //     )

                                    InkWell(
                                      onTap: () => Navigator.of(context).push(
                                        PageTransition(
                                            child: CompositionAndCare(
                                                descriptionHtml:
                                                    "${productModel.descriptionHtml}"
                                                        .replaceAll(
                                                            "(main-data)", "")
                                                        .replaceAll(
                                                            "(model-data)", "")
                                                        .replaceAll(
                                                            "(model-data-end)",
                                                            "")),
                                            type:
                                                PageTransitionType.bottomToTop,
                                            settings: RouteSettings(
                                                name: 'Composition And Care')),
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(top: 30),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 20),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                                top: BorderSide(
                                                    color: Colors.grey[400],
                                                    width: 3))),
                                        child: Text(
                                          'Composition and Care',
                                          style: TextStyle(letterSpacing: 0.2),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        // String text = "SimplifiedSizechart";
                                        // final tagList = productModel.tags;
                                        // bool tagCheck = false;
                                        // tagList.forEach((item) {
                                        // if (item.contains(text)) {
                                        // setState(() {
                                        //   tagCheck = true;
                                        // });
                                        // print(tagList);
                                        if (tagCheck) {
                                          Navigator.of(context)
                                              .push(
                                                  PageTransition(
                                                      child: SizeChartScreen(
                                                          sizechart: simpleTag),
                                                      type: PageTransitionType
                                                          .bottomToTop,
                                                      settings: RouteSettings(
                                                          name: 'Size Chart')));
                                          //}
                                          //});
                                        } else {
                                          Navigator.of(context).push(
                                              PageTransition(
                                                  child:
                                                      SizeChartImages(
                                                          sizechart:
                                                              productModel
                                                                  .tags),
                                                  type: PageTransitionType
                                                      .bottomToTop,
                                                  settings: RouteSettings(
                                                      name: 'Size Chart')));
                                        }
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 20),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                                top: BorderSide(
                                                    color: Colors.grey[400],
                                                    width: 1))),
                                        child: Text('Size Guide',
                                            style:
                                                TextStyle(letterSpacing: 0.2)),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AboutOutfitters(
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
                                                    color: Colors.grey[400],
                                                    width: 1),
                                                bottom: BorderSide(
                                                    color: Colors.grey[400],
                                                    width: 1))),
                                        child: Text('Privacy Policy',
                                            style:
                                                TextStyle(letterSpacing: 0.2)),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.of(context).push(
                                          PageTransition(
                                              child: BuyingGuide(),
                                              type: PageTransitionType
                                                  .bottomToTop,
                                              settings: RouteSettings(
                                                  name:
                                                      'Buying Guide Screen'))),
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 20),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey[400],
                                                    width: 3))),
                                        child: Text('Buying Guide',
                                            style:
                                                TextStyle(letterSpacing: 0.2)),
                                      ),
                                    ),
                                  ],
                                ),
                              )))
                      : SizedBox(),
                ],
              ),
              // Spacer(),
              // S.sDivider(height: 16),
              // Container(
              //   margin: EdgeInsets.only(left: 20),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     // mainAxisAlignment: MainAxisAlignment.end,
              //     children: <Widget>[
              //       Container(
              //         width: MediaQuery.of(context).size.width,
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Expanded(
              //               flex: 7,
              //               child: Column(
              //                 crossAxisAlignment:
              //                     CrossAxisAlignment.start,
              //                 children: <Widget>[
              //                   Text(
              //                     "Rs. " +
              //                         formatter.format(double.parse(
              //                           productModel
              //
              //                                 .variants
              //                                 .variantedges
              //                                 .first
              //                                 .variantnode
              //                                 .price
              //                                 .toString())),
              //                     style: TextStyle(
              //                         fontSize: 12,
              //                         color: productModel
              //
              //                                     .variants
              //                                     .variantedges
              //                                     .first
              //                                     .variantnode
              //                                     .price !=
              //                               productModel
              //
              //                                     .variants
              //                                     .variantedges
              //                                     .first
              //                                     .variantnode
              //                                     .compareAtPrice
              //                             ? Colors.red
              //                             : Colors.black),
              //                   ),
              //                 productModel
              //
              //                               .variants
              //                               .variantedges
              //                               .first
              //                               .variantnode
              //                               .price !=
              //                         productModel
              //
              //                               .variants
              //                               .variantedges
              //                               .first
              //                               .variantnode
              //                               .compareAtPrice
              //                       ? Row(
              //                           mainAxisAlignment:
              //                               MainAxisAlignment.start,
              //                           crossAxisAlignment:
              //                               CrossAxisAlignment.start,
              //                           children: [
              //                             Text(
              //                               formatter.format(double.parse(
              //                                 productModel
              //
              //                                       .variants
              //                                       .variantedges
              //                                       .first
              //                                       .variantnode
              //                                       .compareAtPrice
              //                                       .toString())),
              //                               style: TextStyle(
              //                                   fontSize: 16,
              //                                   color: Colors.black,
              //                                   decoration: TextDecoration
              //                                       .lineThrough),
              //                             ),
              //                             Container(
              //                               margin:
              //                                   EdgeInsets.only(left: 5),
              //                               decoration: BoxDecoration(
              //                                 color: Colors.red
              //                                     .withOpacity(0.8),
              //                                 borderRadius:
              //                                     BorderRadius.circular(
              //                                         3),
              //                               ),
              //                               child: Padding(
              //                                 padding: EdgeInsets.only(
              //                                     left: 2,
              //                                     right: 2,
              //                                     bottom: 2,
              //                                     top: 3),
              //                                 child: Text(
              //                                   '${Helper.getdiscountpercentage(int.parse((productModel.variants.variantedges.first.variantnode.price).toString().split('.')[0]), int.parse((productModel.variants.variantedges.first.variantnode.compareAtPrice).toString().split('.')[0])).toString()} %',
              //                                   style: TextStyle(
              //                                       color: Colors.white,
              //                                       fontSize: 11.0),
              //                                 ),
              //                               ),
              //                             )
              //                           ],
              //                         )
              //                       : SizedBox()
              //                 ],
              //               ),
              //             ),
              //             Expanded(
              //               flex: 4,
              //               child: showSizes == true
              //                   ? Container()
              //                   : Container(
              //                       width: 120,
              //                       margin: EdgeInsets.only(right: 20),
              //                       alignment: Alignment.centerRight,
              //                       // child: SlideTransition(
              //                       // position: _itemAnimation,
              //                       child: InkWell(
              //                         onTap: () {
              //                           setState(() {
              //                             showSizes = true;
              //                           });
              //                         },
              //                         child: Container(
              //                             padding: EdgeInsets.symmetric(
              //                                 vertical: 12),
              //                             alignment: Alignment.center,
              //                             decoration: BoxDecoration(
              //                                 color: Colors.black),
              //                             child: Text(
              //                               'ADD',
              //                               style: TextStyle(
              //                                   color: Colors.white,
              //                                   fontSize: 14),
              //                             )),
              //                       ),
              //                       // ),
              //                     ),
              //             ),
              //             // Spacer(),
              //             isShowAddToCartBtn == false
              //                 ? Container()
              //                 : StreamBuilder<List<Variantnode>>(
              //                     initialData: productDetailBloc.list,
              //                     stream: productDetailBloc
              //                         .getProductVariants,
              //                     builder: (context, snapshot) {
              //                       return Container(
              //                         width: 120,
              //                         child: SlideTransition(
              //                           position: _itemAnimation,
              //                           child: InkWell(
              //                             onTap: () {
              //                               setState(() {
              //                                 isShowAddToCartBtn = false;
              //                               });
              //                               addtoCartItem(
              //                                   productModel,
              //                                   index,
              //                                   snapshot
              //                                       .data[selectedIndex]);
              //                               showSizes = false;
              //                             },
              //                             child: Container(
              //                                 width:
              //                                     MediaQuery.of(context)
              //                                             .size
              //                                             .width /
              //                                         2,
              //                                 padding:
              //                                     EdgeInsets.symmetric(
              //                                         vertical: 12),
              //                                 alignment: Alignment.center,
              //                                 decoration: BoxDecoration(
              //                                     color: Colors.black),
              //                                 child: Text(
              //                                   'Add To Cart',
              //                                   style: TextStyle(
              //                                       color: Colors.white,
              //                                       fontSize: 14),
              //                                 )),
              //                           ),
              //                         ),
              //                       );
              //                     })
              //           ],
              //         ),
              //       ),
              //       S.sDivider(height: 4),
              //       showSizes == false
              //           ? Container()
              //           : StreamBuilder<List<Variantnode>>(
              //               initialData: productDetailBloc.list,
              //               stream: productDetailBloc.getProductVariants,
              //               builder: (context, snapshot) {
              //                 return Wrap(
              //                     crossAxisAlignment:
              //                         WrapCrossAlignment.start,
              //                     spacing: 5,
              //                     runSpacing: 6,
              //                     alignment: WrapAlignment.start,
              //                     children: List.generate(
              //                         snapshot.data.length,
              //                         (indexItem) => InkWell(
              //                               onTap: () {
              //                                 if (!isShowAddToCartBtn) {
              //                                   setState(() {
              //                                     isShowAddToCartBtn =
              //                                         true;
              //                                     selectedIndex =
              //                                         indexItem;
              //                                   });
              //                                   _cartController.reset();
              //                                   _cartController.forward();
              //                                 }

              //                                 setState(() {
              //                                   selectedIndex = indexItem;
              //                                 });
              //                               },
              //                               child: Container(
              //                                 // width: 80,
              //                                 // height: 50,
              //                                 // constraints: BoxConstraints(
              //                                 //   maxWidth: MediaQuery.of(context).size.width * 0.7,
              //                                 // ),
              //                                 padding:
              //                                     const EdgeInsets.all(
              //                                         10.0),
              //                                 constraints: BoxConstraints(
              //                                   maxWidth:
              //                                       MediaQuery.of(context)
              //                                               .size
              //                                               .width *
              //                                           0.7,
              //                                 ),

              //                                 decoration: BoxDecoration(
              //                                   color: Colors.white
              //                                       .withOpacity(0.5),
              //                                   borderRadius:
              //                                       BorderRadius.circular(
              //                                           8),
              //                                   border: Border.all(
              //                                       color: selectedIndex ==
              //                                               indexItem
              //                                           ? Colors.black
              //                                           : Colors
              //                                               .transparent,
              //                                       width: 1.2),
              //                                 ),
              //                                 child: Text(
              //                                   snapshot
              //                                                   .data[
              //                                                       indexItem]
              //                                                   .selectedOptions[
              //                                                       1]
              //                                                   .value ==
              //                                               "WS-20" ||
              //                                           snapshot
              //                                                   .data[
              //                                                       indexItem]
              //                                                   .selectedOptions[
              //                                                       1]
              //                                                   .name ==
              //                                               "Season"
              //                                       ? '${snapshot.data[indexItem].selectedOptions[2].value}'
              //                                       : '${snapshot.data[indexItem].selectedOptions[1].value}',
              //                                   style: TextStyle(
              //                                       fontWeight:
              //                                           selectedIndex ==
              //                                                   indexItem
              //                                               ? FontWeight
              //                                                   .w500
              //                                               : FontWeight
              //                                                   .w400),
              //                                 ),
              //                               ),
              //                             )));
              //               }),
              //       // S.sDivider(height: 14),

              // Spacer(),
              AnimatedContainer(
                duration: Duration(seconds: 1),
                margin: isScroll &&
                        productModel.tags != null &&
                        productModel.tags.contains('Ritem')
                    ? EdgeInsets.only(
                        bottom: (MediaQuery.of(context).size.height -
                                kToolbarHeight) *
                            0.25,
                      )
                    : EdgeInsets.only(
                        bottom: (MediaQuery.of(context).size.height -
                                kToolbarHeight) *
                            0.03,
                      ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 2, left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              color: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () => _shareStoreUrl(
                                        productModel.onlineStoreUrl),
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          bottom: 15, right: 20),
                                      child: Icon(
                                        Feather.share,
                                        size: 26,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      "Rs. " +
                                          formatter.format(double.parse(
                                              productModel.variants.variantedges
                                                  .first.variantnode.price
                                                  .toString())),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black),
                                    ),
                                  ),
                                  productModel.variants.variantedges.first
                                              .variantnode.price !=
                                          productModel.variants.variantedges
                                              .first.variantnode.compareAtPrice
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              formatter.format(double.parse(
                                                  productModel
                                                      .variants
                                                      .variantedges
                                                      .first
                                                      .variantnode
                                                      .compareAtPrice
                                                      .toString())),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.red,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 5),
                                              decoration: BoxDecoration(
                                                color:
                                                    Colors.red.withOpacity(0.8),
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 2,
                                                    right: 2,
                                                    bottom: 2,
                                                    top: 3),
                                                child: Text(
                                                  '${Helper.getdiscountpercentage(int.parse((productModel.variants.variantedges.first.variantnode.price).toString().split('.')[0]), int.parse((productModel.variants.variantedges.first.variantnode.compareAtPrice).toString().split('.')[0])).toString()} %',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11.0),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      : SizedBox()
                                ],
                              )),
                          StreamBuilder<List<Variantnode>>(
                              stream: streamController.stream,
                              initialData: variantnode,
                              builder: (context, snapshot) {
                                if (snapshot.data.length > 0) {
                                  return InkWell(
                                    onTap: () {
                                      if (productModel
                                              .variants.variantedges.length ==
                                          1) {
                                        addtoCartItem(
                                            productModel, 0, variantnode[0]);
                                      } else {
                                        iscartShow = !iscartShow;
                                        isshow = false;
                                        setState(() {});
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 9),
                                      color: Colors.black,
                                      child: iscartShow
                                          ? Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.white,
                                            )
                                          : Text(
                                              'ADD',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                    ),
                                  );
                                } else {
                                  return SoldOut(
                                      productnode: productModel,
                                      horizontalpadding: 12,
                                      verticalpadding: 5,
                                      textSize: 18);
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
              //   ],
              // ),
              // ),
              ),
        ));
    //   },
    // ));
  }

  addtoCartItem(
      Productnode productModel, int productIndex, Variantnode variantnode) {
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
      "p_value": cValue.toString(),
      'p_image': imgList[0],
      'price': variantnode.price,
      'quantity': 1,
      'compare_price': variantnode.compareAtPrice,
      'sku': variantnode.sku,
      'available': variantnode.available.toString()
    };
    database.insert(row,context).then((val) {
      // Toast.showToast(context, 'Added to Cart Successfully!');
      Provider.of<CartNotifier>(context, listen: false).getcart();
    });
  }

  _shareStoreUrl(String storeUrl) {
    final RenderBox box = context.findRenderObject();
    Share.share(storeUrl,
        subject: "Outfitters",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  String sku;

  Future<dynamic> sizesBottomSheet() {
    var apiUrl =
        // productModel[selectedIndex]
        //
        //         .tags
        //         .contains('SimplifiedSizechart')
        //  ? "https://sizechart-revamp-be.alche.cloud/ajax_call_sizechart?shop=outfitterspk.myshopify.com&tags=${(productModel[selectedIndex].tags.where((element) => element.contains(sku)).toString())}"
        //  :
        "https://sizechart-revamp-be.alche.cloud/ajax_call_sizechart?shop=outfitterspk.myshopify.com&tags=F0016/408-SimplifiedSizechart";
  }

  Future fetchSizes() async {
    var result = await http.get(Uri.parse(
        "https://sizechart-revamp-be.alche.cloud/ajax_call_sizechart?shop=outfitterspk.myshopify.com&tags=F0016/408-SimplifiedSizechart"));
    print("::::::::::::::::::${result.body}");

    return json.decode(result.body);
  }

  sizeChartApi(BuildContext context) async {
    var dio = Dio();

    try {
      Response response = await dio.get(
        'https://sizechart-revamp-be.alche.cloud/ajax_call_sizechart?shop=outfitterspk.myshopify.com&tags=F0016/408-SimplifiedSizechart',
      );
      if (response != null) {
        if (response.statusCode == 200) {
          SizeChartModel result =
              sizechartmodelFromMap(jsonEncode(response.data));

          print("results::::${result.sizeChart.created}");
          //  var tagList =
          String text = "SimplifiedSizechart";

          final tagList = productModel.tags;
          tagList.forEach((item) {
            if (item.contains(text)) {
              print(item);
            }
          });
          // productModel.first.tags
          //     .contains('SimplifiedSizechart');

          return result;
        }
      }
    } on DioError catch (e) {
      throw Exception(e.toString());
    }
  }
}
