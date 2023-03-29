import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outfitters/Models/ProductsModel.dart';
import 'package:outfitters/UI/Screens/ProductDetails.dart';
import 'package:outfitters/UI/Widgets/Activewear.dart';
import 'package:outfitters/UI/Widgets/PhotoItem.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:outfitters/UI/Widgets/SoldOutTag.dart';
import 'package:outfitters/UI/Widgets/WishHeart.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;
import 'package:page_transition/page_transition.dart';
import 'package:outfitters/Database/DatabaseHelper.dart';
import 'package:outfitters/UI/Notifiers/CartNotifier.dart';
import 'package:outfitters/UI/Widgets/ToastClass.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatefulWidget {
  final Productedges filterProducts;
  final int index, cValue, leng, sizesL;
  final bool grid;
  ProductWidget(
      {@required this.filterProducts,
      @required this.index,
      @required this.cValue,
      @required this.sizesL,
      @required this.leng,
      this.grid})
      : assert(filterProducts != null),
        assert(index != null);
  @override
  _ProductWidgetState createState() => _ProductWidgetState(this.filterProducts,
      this.index, this.cValue, this.grid, this.leng, this.sizesL);
}

class _ProductWidgetState extends State<ProductWidget>
    with TickerProviderStateMixin {
  _ProductWidgetState(this.filterProducts, this.index, this.cValue, this.grid,
      this.leng, this.sizesL);
  final Productedges filterProducts;
  Animation<Offset> _offsetAnimation, _itemAnimation;
  final database = DatabaseHelper.instance;
  var selectedIndex = -1;
  final int index, cValue, leng, sizesL;
  List proSold2 = [];
  AnimationController _controller, _cartController;
  final bool grid;
  bool isShowAddToCartBtn = false;
  bool isScroll = false;
  var swiperControl = new SwiperController();

  final formatter = new NumberFormat("#,###,###");
  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    _cartController =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    _offsetAnimation = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
        .animate(_controller);
    _itemAnimation = Tween<Offset>(begin: Offset(10, 0), end: Offset(0, 0))
        .animate(_cartController);
    if (leng == 1) {
      proSold2.add(0);
    } else {
      // for (int i = 0; i < leng; i++) {
      //   for (int j = 0; j < sizesL; j++) {
      //     if (filterProducts.productnode.variants.variantedges[j + (sizesL * i)]
      //         .variantnode.available) {
      for (int k = 0;
          k < filterProducts.productnode.images.imagesedges.length;
          k++) {
        if (filterProducts
                .productnode.images.imagesedges[k].imagesnode.altText ==
            filterProducts.productnode.options.first.values[cValue]) {
          proSold2.add(k);
          break;
          // } else if (filterProducts
          //         .productnode.images.imagesedges[k].imagesnode.altText ==
          //     null) {
          //   proSold2.add(k);
          //   break;
          // }
          // }
          // break;
          // }
        }
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _itemAnimation = Tween<Offset>(begin: Offset(2, 0), end: Offset(0, 0))
        .animate(_cartController);
    Productnode productnode = filterProducts.productnode;
    return Container(
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: InkWell(
                onTap: () => Navigator.of(context).push(PageTransition(
                    child: ProductDetails(
                        productModel: filterProducts.productnode,
                        item: index,
                        cValue: cValue,
                        sizesL: sizesL,
                        leng: leng),
                    type: PageTransitionType.fade,
                    settings: RouteSettings(name: 'Product Details'))),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: PhotoItem(
                      imageUrl: productnode
                          .images.imagesedges[proSold2[0]].imagesnode.src),
                ),
              )),
              Container(
                padding: EdgeInsets.only(left: 5, right: 2, top: 7, bottom: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: grid
                          ? MediaQuery.of(context).size.width * 0.37
                          : index % 3 == 0
                              ? MediaQuery.of(context).size.width * 0.37
                              : MediaQuery.of(context).size.width * 0.37,
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        strutStyle: StrutStyle(fontSize: 12.0),
                        text: TextSpan(
                            style: AppTheme.TextTheme.smallgreyText,
                            text: productnode.title.toString()),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      child: WishHeart(
                        graphid: productnode.id,
                        image: productnode
                            .images
                            .imagesedges[cValue *
                                productnode.images.imagesedges.length ~/
                                leng]
                            .imagesnode
                            .src,
                        value: cValue.toString(),
                        price: productnode.variants.variantedges.first
                            .variantnode.compareAtPrice,
                        name: productnode.title,
                        onlinestoreUrl: productnode.onlineStoreUrl,
                        // available: productnode.variants.variantedges.first.variantnode.available.toString(),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 5, bottom: 5, top: 4),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Rs. ' +
                          formatter.format(double.parse(productnode
                              .variants.variantedges.first.variantnode.price
                              .toString())),
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: productnode.variants.variantedges.first
                                      .variantnode.compareAtPrice
                                      .toString() !=
                                  productnode.variants.variantedges.first
                                      .variantnode.price
                                      .toString()
                              ? Colors.red
                              : Colors.black),
                      // style: AppTheme.TextTheme.smallboldText,
                    ),
                    productnode.variants.variantedges.first.variantnode
                                .compareAtPrice
                                .toString() !=
                            productnode
                                .variants.variantedges.first.variantnode.price
                                .toString()
                        ? Row(
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 6, right: 10, bottom: 2, top: 1.5),
                                  child: Text(
                                      'Rs. ' +
                                          formatter.format(double.parse(
                                              productnode
                                                  .variants
                                                  .variantedges
                                                  .first
                                                  .variantnode
                                                  .compareAtPrice
                                                  .toString())),
                                      style: TextStyle(
                                          color: Colors.black,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontSize: 10))),
                            ],
                          )
                        : SizedBox(),
                  ],
                ),
              ),
              // isShowAddToCartBtn == true
              //     ? Container()
              //     : Container(
              //         height: 23,
              //         margin: EdgeInsets.only(bottom: 5, left: 2, right: 2),
              //         child: Row(
              //           children: [
              //             Expanded(
              //                 flex: index % 3 == 0 ? 7 : 10,
              //                 child: ListView.builder(
              //                     scrollDirection: Axis.horizontal,
              //                     itemCount:
              //                         productnode.variants.variantedges.length,
              //                     shrinkWrap: true,
              //                     itemBuilder: (BuildContext context, int ind) {
              //                       return InkWell(
              //                         onTap: () {
              //                           if (productnode
              //                                   .variants
              //                                   .variantedges[ind]
              //                                   .variantnode
              //                                   .availableForSale !=
              //                               false) {
              //                             if (!isShowAddToCartBtn) {
              //                               setState(() {
              //                                 isShowAddToCartBtn = true;
              //                                 selectedIndex = ind;
              //                               });
              //                               _cartController.reset();
              //                               _cartController.forward();
              //                             }
              //                             setState(() {
              //                               selectedIndex = ind;
              //                             });
              //                           }
              //                         },
              //                         child: Stack(
              //                           children: [
              //                             Container(
              //                               width: !productnode
              //                                       .variants
              //                                       .variantedges[ind]
              //                                       .variantnode
              //                                       .selectedOptions
              //                                       .contains("Size")
              //                                   ? (productnode
              //                                                   .variants
              //                                                   .variantedges[
              //                                                       ind]
              //                                                   .variantnode
              //                                                   .selectedOptions[
              //                                                       1]
              //                                                   .value ==
              //                                               "WS-20" ||
              //                                           productnode
              //                                                   .variants
              //                                                   .variantedges[
              //                                                       ind]
              //                                                   .variantnode
              //                                                   .selectedOptions[
              //                                                       1]
              //                                                   .value ==
              //                                               "Summer-20" ||
              //                                           productnode
              //                                                   .variants
              //                                                   .variantedges[
              //                                                       ind]
              //                                                   .variantnode
              //                                                   .selectedOptions[
              //                                                       1]
              //                                                   .value ==
              //                                               "Summer-19"
              //                                       ? productnode
              //                                                   .variants
              //                                                   .variantedges[
              //                                                       ind]
              //                                                   .variantnode
              //                                                   .selectedOptions[
              //                                                       2]
              //                                                   .value
              //                                                   .length <=
              //                                               2
              //                                           ? 28
              //                                           : 60
              //                                       : productnode
              //                                                   .variants
              //                                                   .variantedges[
              //                                                       ind]
              //                                                   .variantnode
              //                                                   .selectedOptions[
              //                                                       1]
              //                                                   .value
              //                                                   .length <=
              //                                               2
              //                                           ? 28
              //                                           : 60)
              //                                   : productnode
              //                                               .variants
              //                                               .variantedges[ind]
              //                                               .variantnode
              //                                               .selectedOptions[0]
              //                                               .value
              //                                               .length <=
              //                                           2
              //                                       ? 28
              //                                       : 60,
              //                               margin: EdgeInsets.only(
              //                                   left: 5, right: 5),
              //                               padding: EdgeInsets.all(3),
              //                               decoration: BoxDecoration(
              //                                   color: selectedIndex == ind
              //                                       ? Colors.grey[200]
              //                                       : Colors.transparent,
              //                                   border: Border.all(
              //                                     color: Colors.grey[500],
              //                                   ),
              //                                   borderRadius: BorderRadius.all(
              //                                       Radius.circular(15))),
              //                               child: Center(
              //                                 child: Text(
              //                                   !productnode
              //                                           .variants
              //                                           .variantedges[ind]
              //                                           .variantnode
              //                                           .selectedOptions
              //                                           .contains("Size")
              //                                       ? (productnode
              //                                                       .variants
              //                                                       .variantedges[
              //                                                           ind]
              //                                                       .variantnode
              //                                                       .selectedOptions[
              //                                                           1]
              //                                                       .value ==
              //                                                   "WS-20" ||
              //                                               productnode
              //                                                       .variants
              //                                                       .variantedges[
              //                                                           ind]
              //                                                       .variantnode
              //                                                       .selectedOptions[
              //                                                           1]
              //                                                       .value ==
              //                                                   "Summer-20" ||
              //                                               productnode
              //                                                       .variants
              //                                                       .variantedges[
              //                                                           ind]
              //                                                       .variantnode
              //                                                       .selectedOptions[
              //                                                           1]
              //                                                       .value ==
              //                                                   "Summer-19"
              //                                           ? productnode
              //                                               .variants
              //                                               .variantedges[ind]
              //                                               .variantnode
              //                                               .selectedOptions[2]
              //                                               .value
              //                                           : productnode
              //                                               .variants
              //                                               .variantedges[ind]
              //                                               .variantnode
              //                                               .selectedOptions[1]
              //                                               .value)
              //                                       : productnode
              //                                           .variants
              //                                           .variantedges[ind]
              //                                           .variantnode
              //                                           .selectedOptions[0]
              //                                           .value,
              //                                   style: TextStyle(
              //                                     color: selectedIndex == ind
              //                                         ? Colors.black
              //                                         : Colors.grey[800],
              //                                   ),
              //                                 ),
              //                               ),
              //                             ),
              //                             Positioned(
              //                                 top: -6,
              //                                 right: 2,
              //                                 left: 2,
              //                                 bottom: 2,
              //                                 child: productnode
              //                                             .variants
              //                                             .variantedges[ind]
              //                                             .variantnode
              //                                             .availableForSale ==
              //                                         false
              //                                     ? Container(
              //                                         alignment:
              //                                             Alignment.center,
              //                                         child: Icon(
              //                                           Icons.close,
              //                                           color: Colors.grey[600],
              //                                           size: 35,
              //                                         ))
              //                                     : Container())
              //                           ],
              //                         ),
              //                       );
              //                     })),
              //           ],
              //         ),
              //       ),
              // isShowAddToCartBtn == true && selectedIndex != -1
              //     ? Container(
              //         width: 120,
              //         child: SlideTransition(
              //           position: _itemAnimation,
              //           child: InkWell(
              //             onTap: () {
              //               setState(() {
              //                 isShowAddToCartBtn = false;
              //               });
              //               addtoCartItem(
              //                   filterProducts,
              //                   index,
              //                   productnode.variants.variantedges[selectedIndex]
              //                       .variantnode);
              //             },
              //             child: Container(
              //                 width: MediaQuery.of(context).size.width / 2,
              //                 padding: EdgeInsets.symmetric(vertical: 8),
              //                 alignment: Alignment.center,
              //                 decoration: BoxDecoration(color: Colors.black),
              //                 child: Text(
              //                   'Add To Cart',
              //                   style: TextStyle(
              //                       color: Colors.white, fontSize: 14),
              //                 )),
              //           ),
              //         ),
              //       )
              //     : Container()
            ],
          ),
          Container(
            margin: grid ? EdgeInsets.only(left: 5) : EdgeInsets.only(left: 3),
            child: SoldOut(
              productnode: filterProducts.productnode,
              horizontalpadding: 6,
              verticalpadding: 1,
              textSize: 10,
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            margin:
                grid ? EdgeInsets.only(right: 3) : EdgeInsets.only(right: 0),
            child: ActiveWear(
              productnode: filterProducts.productnode,
              horizontalpadding: 6,
              verticalpadding: 1,
              textSize: 10,
            ),
          )
        ],
      ),
    );
  }

  addtoCartItem(Productedges productModel, int productIndex, variantnode) {
    Map<String, dynamic> row = {
      'graphid': variantnode.id,
      'p_name': productModel.productnode.title,
      'p_id': productModel.productnode.id,
      'p_color': variantnode.selectedOptions[0].value,
      'p_size': !variantnode.selectedOptions.contains("Size")
          ? (variantnode.selectedOptions[1].value == "WS-20" ||
                  variantnode.selectedOptions[1].value == "Summer-20" ||
                  variantnode.selectedOptions[1].value == "Summer-19"
              ? variantnode.selectedOptions[2].value
              : variantnode.selectedOptions[1].value)
          : variantnode.selectedOptions[0].value,
      'varient_id': variantnode.id,
      'p_image':
          productModel.productnode.images.imagesedges.first.imagesnode.src,
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
