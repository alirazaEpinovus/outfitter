import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:outfitters/Models/OrderTrackingModel.dart';
import 'package:outfitters/Models/OrdersModel.dart';
import 'package:outfitters/UI/Resources/OrderstatusBloc.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;

class OrderDetail extends StatefulWidget {
  final Edges orderdetail;
  final customerName;
  OrderDetail({@required this.orderdetail, @required this.customerName})
      : assert(orderdetail != null),
        assert(customerName != null);
  @override
  _OrderDetailState createState() =>
      _OrderDetailState(this.orderdetail, this.customerName);
}

class _OrderDetailState extends State<OrderDetail> {
  double screenHeight;
  double screenWidth;
  Edges orderdetail;
  String customerName;
  final orderstatusBloc = OrderStatusBloc();
  _OrderDetailState(this.orderdetail, this.customerName);

  Size size;

  @override
  void initState() {
    orderstatusBloc.getstatus(context, orderdetail.node.orderNumber);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        brightness: Brightness.light,
        centerTitle: false,
        title: Text(
          'Order Details',
          style: AppTheme.TextTheme.titlebold,
        ),
        leading: Material(
          color: Colors.transparent,
          child: InkWell(
              splashColor: Colors.grey.withOpacity(0.7),
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back, size: 28, color: Colors.black)),
        ),
      ),
      body: Container(
        color: Colors.grey.withOpacity(0.2),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.white,
                width: screenWidth,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          child: Text(
                        'Ship & Bill to',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      )),
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            '${widget.customerName}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          )),
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            '${widget.orderdetail.node.shippingAddress.address1}',
                            style: TextStyle(
                                color: Colors.grey.withOpacity(0.8),
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          )),
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                margin: EdgeInsets.only(top: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: screenWidth,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Icon(
                                  Feather.shopping_cart,
                                  size: 18,
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text('Package 1',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500)))
                              ],
                            ),
                          ),
                          StreamBuilder<OrderTrackingModel>(
                              stream: orderstatusBloc.fetchstatus,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 7),
                                    child: Text(
                                      snapshot.data.status,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          color: Colors.red,
                                          fontSize: 12),
                                    ),
                                  );
                                } else {
                                  return Text(
                                    'Loading...',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w200,
                                        color: Color(0xFF19AE97),
                                        fontSize: 12),
                                  );
                                }
                              })
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15, top: 5),
                      child: Text('Order detail',
                          style: TextStyle(
                              color: Colors.grey.withOpacity(0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: orderdetail.node.lineItems.edges.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          if (orderdetail
                                  .node.lineItems.edges[index].node.variant ==
                              null) {
                            return SizedBox();
                          }
                          return _orderLineItems(context,
                              orderdetail.node.lineItems.edges[index].node);
                        }),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                color: Colors.white,
                width: screenWidth,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 7, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Order # ${orderdetail.node.orderNumber}',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF19AE97),
                            fontSize: 14),
                      ),
                      Text(
                        'Place on ' +
                            getordertime(orderdetail
                                .node.lineItems.edges.first.node.variant),
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                color: Colors.white,
                width: screenWidth,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 7, vertical: 8),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Subtotal',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            Text(
                              'Rs. ${orderdetail.node.subtotalPrice}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Shipping Fee',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            Text(
                              'Rs. ${orderdetail.node.totalShippingPrice}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Divider(
                          height: 2,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                    child: Text(
                                  '${_getquantityCount(orderdetail)} item, 1 Pakage',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                )),
                                Container(
                                    padding: EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'Total:',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                        ),
                                        Text(
                                          '  Rs. ${orderdetail.node.totalPrice}',
                                          style: TextStyle(
                                              color: Colors.orange,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                        ),
                                      ],
                                    )),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String getordertime(Variant variant) {
    String formatted = '';
    if (variant != null) {
      var parsedDate = DateTime.parse(variant.product.createdAt);
      var formatter = new DateFormat('HH:mm:ss dd-MM-yyyy');
      formatted = formatter.format(parsedDate);
    }
    return formatted;
  }

  Widget _orderLineItems(BuildContext context, NodeLineItem nodeLineItem) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: 60,
            child: Image.network(
              '${nodeLineItem.variant.image.src}',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  child: Text(
                    '${nodeLineItem.variant.product.title}',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  child: Text(
                    'Rs. ${nodeLineItem.variant.price}',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 7),
                      child: Text(
                        'x ${nodeLineItem.quantity}',
                        style: TextStyle(
                            fontWeight: FontWeight.w200,
                            color: Colors.grey,
                            fontSize: 12),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _getquantityCount(Edges edges) {
    int count = 0;
    edges.node.lineItems.edges.forEach((data) {
      count = count + data.node.quantity;
    });
    return count;
  }
}
