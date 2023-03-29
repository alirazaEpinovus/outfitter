import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:outfitters/Models/OrderTrackingModel.dart';
import 'package:outfitters/Models/OrdersModel.dart';
import 'package:outfitters/UI/GraphQL/Query/GraphQlQueries.dart';
import 'package:outfitters/UI/Resources/OrderstatusBloc.dart';
import 'package:outfitters/UI/Screens/OrderDetail.dart';
import 'package:outfitters/UI/Widgets/LoadingAnimation.dart';
import 'package:outfitters/UI/Widgets/PhotoItem.dart';
import 'package:outfitters/Utils/GraphQlHelper.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;

class MyOrders extends StatefulWidget {
  final idd;
  MyOrders({Key key, this.idd}) : super(key: key);
  @override
  _MyOrdersState createState() => _MyOrdersState(this.idd);
}

class _MyOrdersState extends State<MyOrders> {
  final graphqlHelper = new GraphQlHelper();
  final orderstatusBloc = OrderStatusBloc();
  String idd;
  _MyOrdersState(this.idd);

  @override
  Widget build(BuildContext context) {
    print('access token $idd ');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'My Orders',
          style: AppTheme.TextTheme.titlebold,
        ),
      ),
      body: Container(
          color: Colors.grey.withOpacity(0.1),
          child: Query(
              options: QueryOptions(
                document: gql(
                    readOrders), // this is the query string you just created
                variables: {'accestoken': idd},
                //pollInterval: 10,
              ),
              builder: (QueryResult result,
                  {VoidCallback refetch, FetchMore fetchMore}) {
                if (result.hasException) {
                  return Text(result.exception.toString());
                }

                if (result.isLoading) {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: LoadingAnimation(),
                    ),
                  );
                }
                GetOrderModel getOrderModel =
                    GetOrderModel.fromJson(result.data);
                if (getOrderModel.customer.orders.edges.isEmpty) {
                  return Center(
                    child: Text('No order place'),
                  );
                } else {
                  return Container(
                    child: ListView.builder(
                      itemCount: getOrderModel.customer.orders.edges.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            margin: EdgeInsets.only(top: 5),
                            child: _orderItems(
                                context,
                                getOrderModel.customer.orders.edges[index],
                                getOrderModel.customer.displayName));
                      },
                    ),
                  );
                }
              })),
    );
  }

  Widget _orderItems(BuildContext context, Edges edges, String customerName) {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              OrderDetail(orderdetail: edges, customerName: customerName),
          settings: RouteSettings(name: 'Order Detail'))),
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      child: Text(
                    'Order',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  )),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        '${edges.node.orderNumber}',
                        style: TextStyle(fontWeight: FontWeight.w400),
                      )),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 8,
                      ))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          child: Text(
                        'Place on',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      )),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            getordertime(
                                edges.node.lineItems.edges.first.node.variant),
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          )),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                            child: Text(
                          'Fulfillment : ',
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        )),
                        Container(
                            child: Text(
                          'un-fullfillment',
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        )),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                            child: Text(
                          'Shipping status : ',
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        )),
                        StreamBuilder<OrderTrackingModel>(
                            stream: orderstatusBloc.fetchstatus,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 7),
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
                                      color: Colors.red,
                                      fontSize: 12),
                                );
                              }
                            }),
                      ],
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: edges.node.lineItems.edges.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  if (edges.node.lineItems.edges[index].node.variant == null) {
                    return SizedBox();
                  }
                  return _lineitemLists(
                      context,
                      edges.node.lineItems.edges[index].node,
                      edges.node.orderNumber);
                },
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: Text(
                      '${_getquantityCount(edges)} item,',
                      style: TextStyle(
                          fontWeight: FontWeight.w200,
                          color: Colors.black,
                          fontSize: 12),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      'Total',
                      style: TextStyle(
                          fontWeight: FontWeight.w200,
                          color: Colors.black,
                          fontSize: 12),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      'Rs. ${edges.node.totalPrice}',
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.orange,
                          fontSize: 14),
                    ),
                  )
                ],
              ),
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

  Widget _lineitemLists(
      BuildContext context, NodeLineItem nodeLineItem, int ordernumber) {
    orderstatusBloc.getstatus(context, ordernumber);
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(left: 10, right: 5),
              height: 60,
              width: 60,
              child: PhotoItem(imageUrl: nodeLineItem.variant.image.src)),
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
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Rs. ${nodeLineItem.variant.price}',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 95,
                  child: Row(
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
                  ),
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
