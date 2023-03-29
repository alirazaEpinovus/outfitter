import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:outfitters/Database/DatabaseHelper.dart';
import 'package:outfitters/Models/ProductsModel.dart';
import 'package:outfitters/Models/ScanHistroyModel.dart';
import 'package:outfitters/UI/GraphQL/Query/GraphQlQueries.dart';
import 'package:outfitters/UI/Notifiers/ConnectionNotifier.dart';
import 'package:outfitters/UI/Screens/ProductDetails.dart';
import 'package:outfitters/UI/Screens/ScanInfo.dart';
import 'package:outfitters/UI/Widgets/InternetError.dart';
import 'package:outfitters/UI/Widgets/LoadingAnimation.dart';
import 'package:outfitters/UI/Widgets/PhotoItem.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ScanHistroy extends StatefulWidget {
  @override
  _ScanHistroyState createState() => _ScanHistroyState();
}

class _ScanHistroyState extends State<ScanHistroy> {
  final database = DatabaseHelper.instance;
  StreamController<bool> isShowStream;

  @override
  void initState() {
    isShowStream = new StreamController<bool>();
    isShowStream.sink.add(false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        automaticallyImplyLeading: true,
        elevation: 1,
        title: Text(
          'Scan & Shop',
          style: AppTheme.TextTheme.titlebold,
        ),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).push(PageTransition(
                  child: ScanInfo(),
                  type: PageTransitionType.rightToLeftWithFade,
                  settings: RouteSettings(name: 'Scan Info')));
            },
            child: Container(
                margin: EdgeInsets.only(right: 15),
                child: Icon(Feather.alert_circle)),
          ),
          StreamBuilder<bool>(
              stream: isShowStream.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data) {
                  return InkWell(
                    onTap: () {
                      database.deleteScanHistroy().then((value) {
                        isShowStream.add(false);
                        setState(() {
                          database.scanhistroyCount();
                        });
                        setState(() {});
                      });
                    },
                    child: Container(
                        margin: EdgeInsets.only(right: 15, left: 5),
                        child: Center(child: Text('Clear'))),
                  );
                } else {
                  return SizedBox();
                }
              })
        ],
      ),
      body: Container(
        child: FutureBuilder<List<ScanHistroyModel>>(
          future: database.getRecentScan(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data.isNotEmpty) {
              if (connectionStatus != ConnectivityStatus.Offline) {
                isShowStream.add(true);
              }

              if (connectionStatus != ConnectivityStatus.Offline) {
                return Query(
                    options: QueryOptions(
                        document: gql(scanAndShopProduct),
                        variables: {
                          "sku": getquery(snapshot.data).join(' OR ')
                        }),
                    builder: (QueryResult result,
                        {refetch, FetchMore fetchMore}) {
                      if (result.isLoading && result.data == null) {
                        return Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: LoadingAnimation());
                      }
                      if (result.data == null && result.hasException == null) {
                        return const Text('Both data and errors are null');
                      }
                      // List<Productedges> productModel =
                      //     List<Productedges>.from(result.data);
                      var productModel = ProductModel.fromJson(result.data);

                      if (productModel.products.productedges.length == 0) {
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SvgPicture.asset('assets/images/sadface.svg'),
                              Text(
                                'Oops!',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text('No item found.'),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: productModel.products.productedges.length,
                          itemBuilder: (context, index) {
                            return scanItem(
                                productModel
                                    .products.productedges[index].productnode,
                                index,
                                productModel.products.productedges.length);
                          });
                    });
              } else {
                return InternetError();
              }
            } else {
              return Center(child: Text('You have not scan product recently'));
            }
          },
        ),
      ),
    );
  }

  List<String> getquery(List<ScanHistroyModel> scanlist) {
    List<String> data = [];

    scanlist.forEach((element) {
      data.add('${element.scancode}');
    });
    return data;
  }

  Widget scanItem(productnode, int index, int length) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  height: 90,
                  width: 70,
                  child: PhotoItem(
                      imageUrl:
                          productnode.images.imagesedges.first.imagesnode.src)),
              Expanded(
                child: Container(
                  height: 90,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            productnode.title,
                            style: AppTheme.TextTheme.smalltext,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () => Navigator.of(context).push(
                                PageTransition(
                                    child: ProductDetails(
                                        productModel: productnode,
                                        item: index,
                                        cValue: 0,
                                        sizesL: productnode
                                            .options[1].values.length,
                                        leng: productnode
                                            .options[0].values.length),
                                    type: PageTransitionType.topToBottom)),
                            child: Container(
                                alignment: FractionalOffset.bottomRight,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 4),
                                color: Colors.black,
                                child: Text(
                                  'View',
                                  style: TextStyle(color: Colors.white),
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          // Container(
          //   margin: EdgeInsets.symmetric(vertical: 5),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: <Widget>[
          //       InkWell(
          //         onTap: () {

          //          //database.deletescanitem(sna)
          //         },
          //         child: Row(
          //           children: <Widget>[
          //             Container(
          //                 margin: EdgeInsets.only(right: 6),
          //                 child: Icon(
          //                   Icons.clear,
          //                   size: 16,
          //                 )),
          //             Text(
          //             'Delete',
          //               style: TextStyle(fontSize: 12),
          //             )
          //           ],
          //         ),
          //       ),

          //     ],
          //   ),
          // ),
          Divider(
            color: AppTheme.Colors.grey,
          )
        ],
      ),
    );
  }
}
