import 'package:flutter/material.dart';
import 'package:outfitters/Database/DatabaseHelper.dart';
import 'package:outfitters/Models/CartModel.dart';
import 'package:outfitters/UI/Notifiers/CartNotifier.dart';
import 'package:outfitters/UI/Screens/ProductDetailCart.dart';
import 'package:outfitters/UI/Widgets/PhotoItem.dart';
import 'package:outfitters/UI/Widgets/ToastClass.dart';
import 'package:outfitters/UI/Widgets/WishHeart.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'Swipe.dart';

class CartWidget extends StatefulWidget {
  final CartModel cartModel;
  final Animation<double> animation;
  final Function removeCartItem;
  final Function minusItem;
  final Function addItem;

  CartWidget(
      {@required this.cartModel,
      this.animation,
      this.removeCartItem,
      this.addItem,
      this.minusItem})
      : assert(cartModel != null);
  @override
  _CartWidgetState createState() => _CartWidgetState(this.cartModel);
}

class _CartWidgetState extends State<CartWidget> {
  final CartModel cartModel;
  _CartWidgetState(this.cartModel);
  final database = DatabaseHelper.instance;
  int item;
  @override
  Widget build(BuildContext context) {
    item = widget.cartModel.quantity;
    return InkWell(
      onTap: () {
        print(cartModel.productId);
        Navigator.of(context).pushReplacement(PageTransition(
            child: ProductDetailsCart(
                productId: cartModel.productId, cValue: cartModel.value),
            type: PageTransitionType.fade,
            settings: RouteSettings(name: 'Product Details Cart')));
      },
      child: SizeTransition(
        sizeFactor: widget.animation,
        child: Column(
          children: <Widget>[
            Container(
              height: 119,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: <Widget>[
                  Provider.of<CartNotifier>(context, listen: false).iseditcart
                      ? Container(
                          height: 110,
                          child: Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: InkWell(
                                  onTap: () {
                                    database
                                        .deleteItem(widget.cartModel.orderId)
                                        .then((onValue) {
                                      widget.removeCartItem(widget.cartModel);
                                      Provider.of<CartNotifier>(context,
                                              listen: false)
                                          .getcart();
                                    });
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey[400]),
                                      child: Icon(
                                        Icons.clear,
                                        size: 20,
                                      )))),
                        )
                      : SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 120,
                        width: 75,
                        child: PhotoItem(imageUrl: cartModel.productImage),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 120,
                        padding: EdgeInsets.only(left: 11, top: 5, bottom: 3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(bottom: 2),
                                    child: Text(
                                      cartModel.productName,
                                      style: AppTheme.TextTheme.smallboldText,
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(bottom: 2, top: 3),
                                    child: Text(
                                        'Color - ${cartModel.productColor}',
                                        style: TextStyle(
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.w500))),
                                Container(
                                  margin: EdgeInsets.only(bottom: 2, top: 3),
                                  child: Text(
                                    cartModel.productSize == "Color" ||
                                            cartModel.productSize == "HS-20"
                                        ? "FREE"
                                        : cartModel.productSize,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Provider.of<CartNotifier>(context,
                                            listen: false)
                                        .iseditcart
                                    ? Row(
                                        children: <Widget>[
                                          InkWell(
                                              onTap: () {
                                                if (cartModel.quantity == 1) {
                                                  database
                                                      .deleteItem(widget
                                                          .cartModel.orderId)
                                                      .then((onValue) {
                                                    widget.removeCartItem(
                                                        widget.cartModel);
                                                    Provider.of<CartNotifier>(
                                                            context)
                                                        .getcart();
                                                  });
                                                }
                                                if (cartModel.quantity > 1) {
                                                  database
                                                      .update(
                                                          cartModel.orderId,
                                                          cartModel.quantity -
                                                              1)
                                                      .then((onValue) {
                                                    if (onValue == 1) {
                                                      setState(() {
                                                        item = item - 1;
                                                        widget.minusItem(
                                                            cartModel);
                                                      });
                                                      Provider.of<CartNotifier>(
                                                              context)
                                                          .getcart();
                                                    }
                                                  });
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                child: Icon(
                                                  Icons.remove,
                                                  size: 19,
                                                ),
                                              )),
                                          Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Text(item.toString(),
                                                  style: AppTheme
                                                      .TextTheme.boldText)),
                                          InkWell(
                                              onTap: () {
                                                if (item < 5) {
                                                  database
                                                      .update(
                                                          cartModel.orderId,
                                                          cartModel.quantity +
                                                              1)
                                                      .then((onValue) {
                                                    if (onValue == 1) {
                                                      setState(() {
                                                        item = item + 1;
                                                        widget
                                                            .addItem(cartModel);
                                                      });
                                                    }
                                                    Provider.of<CartNotifier>(
                                                            context)
                                                        .getcart();
                                                  });
                                                } else {
                                                  Toast.showToast(context,
                                                      'You can not add more than 5 items');
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                child: Icon(
                                                  Icons.add,
                                                  size: 19,
                                                ),
                                              ))
                                        ],
                                      )
                                    : Row(
                                        children: <Widget>[],
                                      )
                              ],
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(bottom: 2),
                                        child: WishHeart(
                                            graphid: cartModel.productId,
                                            image: cartModel.productImage,
                                            name: cartModel.productName,
                                            value: cartModel.value,
                                            price: cartModel.price,
                                            onlinestoreUrl: cartModel.orderId),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(bottom: 7),
                                          child: Text(
                                            'Save',
                                          ))
                                    ],
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        item == 1
                                            ? Container()
                                            : Container(
                                                margin: EdgeInsets.only(
                                                  right: 10,
                                                ),
                                                child: Text(
                                                  item.toString() +
                                                      " x "
                                                          '${cartModel.price}',
                                                  textAlign: TextAlign.right,
                                                  style: AppTheme
                                                      .TextTheme.smallgreyText,
                                                )),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 2, right: 10),
                                          child: Text(
                                            'PKR ${(item * cartModel.price)}',
                                            style: AppTheme
                                                .TextTheme.regulartext16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
