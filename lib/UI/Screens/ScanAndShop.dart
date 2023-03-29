import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:outfitters/Database/DatabaseHelper.dart';
import 'package:outfitters/Models/ProductsModel.dart';
import 'package:outfitters/UI/GraphQL/Query/GraphQlQueries.dart';
import 'package:outfitters/UI/Notifiers/ConnectionNotifier.dart';
import 'package:outfitters/UI/Screens/ProductDetails.dart';
import 'package:outfitters/UI/Screens/ScanHistroy.dart';
import 'package:outfitters/UI/Screens/ScanInfo.dart';
import 'package:outfitters/UI/Widgets/LoadingAnimation.dart';
import "package:flutter/src/widgets/image.dart" as Image;
import 'package:outfitters/UI/Widgets/ToastClass.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;
import 'dart:async';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ScanAndShop extends StatefulWidget {
  @override
  _ScanAndShopState createState() => _ScanAndShopState();
}

class _ScanAndShopState extends State<ScanAndShop> {
  SharedPreferences sharedPreferences;
  dynamic labels;
  final String key = "scanhistroy";
  final databaseHelper = DatabaseHelper.instance;

  loadValues() async {
    sharedPreferences = await SharedPreferences.getInstance();
    labels = json.decode(sharedPreferences.getString("labels"));

    setState(() {});
  }

  String _scanBarcode = '';

  @override
  void initState() {
    super.initState();
    loadValues();
  }

  startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            "#ff6666", "Cancel", true, ScanMode.BARCODE)
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      print('scan code is $barcodeScanRes');
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    //If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      print('scan code is $barcodeScanRes');
    });
  }

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    return sharedPreferences == null
        ? Container()
        : _scanBarcode == "" || _scanBarcode == "-1"
            ? Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  elevation: 3,
                  title: Text(
                    labels["scan_shop"],
                    style: AppTheme.TextTheme.titlebold,
                  ),
                  actions: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(PageTransition(
                            child: ScanInfo(),
                            type: PageTransitionType.topToBottom));
                      },
                      child: Container(
                          margin: EdgeInsets.only(right: 15),
                          child: Icon(Feather.alert_circle)),
                    )
                  ],
                ),
                body: Container(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 50),
                          child: Flex(
                              direction: Axis.vertical,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: Image.Image.asset(
                                        "assets/images/scans.png")),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        color: Colors.black,
                                        height: 40,
                                        margin: EdgeInsets.only(
                                            left: 20, right: 20, top: 20),
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black,
                                            ),
                                            onPressed: () => connectionStatus !=
                                                    ConnectivityStatus.Offline
                                                ? scanBarcodeNormal()
                                                : Toast.showToast(context,
                                                    'No internet connection available'),
                                            child: Text(
                                              labels["barcode"],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                      ),
                                    ),
                                    // Expanded(
                                    //   child: Container(
                                    //     height: 40,
                                    //     margin: EdgeInsets.only(
                                    //         left: 10, right: 20, top: 20),
                                    //     child: RaisedButton(
                                    //         onPressed: () => scanQR(),
                                    //         child: Text(labels["qr"])),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ]),
                        ),
                        Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: InkWell(
                            onTap: () {
                              setState(() {});
                              Navigator.of(context)
                                  .push(PageTransition(
                                      child: ScanHistroy(),
                                      type: PageTransitionType.rightToLeft))
                                  .then((value) =>
                                      value ? setState(() {}) : null);
                            },
                            child: Container(
                              height: 55,
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Colors.grey[400], width: 1))),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 25),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            child: Icon(
                                              Icons.access_time,
                                              size: 20,
                                              color: Colors.grey[500],
                                            )),
                                        Container(
                                          child: Text('Scan Histroy'),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          child: FutureBuilder<int>(
                                              future: databaseHelper
                                                  .scanhistroyCount(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return Text(
                                                      '${snapshot.data}');
                                                } else {
                                                  return SizedBox();
                                                }
                                              }),
                                        ),
                                        Container(
                                          child: Text(' product(s)'),
                                        ),
                                        Container(
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 18,
                                              color: Colors.grey[500],
                                            )),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )))
            : Query(
                options: QueryOptions(
                    document: gql(scanAndShopProduct),
                    variables: {"sku": "${_scanBarcode.toString()}"}),
                builder: (QueryResult result, {refetch, FetchMore fetchMore}) {
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
                  ProductModel productModel =
                      ProductModel.fromJson(result.data);
                  if (productModel.products.productedges.isEmpty) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          Column(
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
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: EdgeInsets.only(top: kToolbarHeight + 20),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _scanBarcode = "-1";
                                  });
                                },
                                child: Container(
                                    margin: EdgeInsets.only(top: 8, right: 5),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.black,
                                      size: 40,
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    databaseHelper.insertRecentScan(_scanBarcode);

                    //   .then((v) {
                    // Navigator.of(context).push(
                    //     PageTransition(
                    //         child: ProductDetails(
                    //             productModel:
                    //                 productModel,
                    //             item: 0),
                    //         type: PageTransitionType
                    //             .bottomToTop)
                    //             );
                    // });
                    return Stack(
                      children: [
                        ProductDetails(
                            productModel: productModel
                                .products.productedges.first.productnode,
                            item: 0,
                            cValue: 0,
                            sizesL: productModel.products.productedges.first
                                .productnode.options[1].values.length,
                            leng: productModel.products.productedges.first
                                .productnode.options[0].values.length),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            margin: EdgeInsets.only(top: kToolbarHeight + 20),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _scanBarcode = "-1";
                                });
                              },
                              child: Container(
                                  margin: EdgeInsets.only(top: 8, right: 5),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.black,
                                    size: 40,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                });
  }
}
