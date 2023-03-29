import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:outfitters/Database/DatabaseHelper.dart';
import 'package:outfitters/NetworkUtils/getMainListInformation.dart';
import 'package:outfitters/UI/Widgets/LoadingAnimation.dart';
import 'package:outfitters/UI/Widgets/RefreshWeb.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;

class StoresLocators extends StatefulWidget {
  @override
  _StoresLocatorsState createState() => _StoresLocatorsState();
}

class _StoresLocatorsState extends State<StoresLocators>
    with WidgetsBindingObserver {
  DragGesturePullToRefresh dragGesturePullToRefresh;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  WebViewController _myController;
  bool loading = true;
  final makecall = new MakeCall();
  final databaseHelper = DatabaseHelper.instance;
  int _activeMeterIndex;
  ScrollController con;

  loadData() async {}

  @override
  void initState() {
    super.initState();
    setState(() {
      con = ScrollController();
      con.addListener(() {
        if (con.offset >= con.position.maxScrollExtent &&
            !con.position.outOfRange) {
          setState(() {});
        } else if (con.offset <= con.position.minScrollExtent &&
            !con.position.outOfRange) {
          setState(() {});
        } else {
          setState(() {});
        }
      });
    });
    dragGesturePullToRefresh = DragGesturePullToRefresh();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // remove listener
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // on portrait / landscape or other change, recalculate height
    dragGesturePullToRefresh.setHeight(MediaQuery.of(context).size.height);
  }

  final _key = UniqueKey();
  WebViewController controller;
  bool isLoading = true;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 3,
        title: Text(
          'Our Stores',
          style: AppTheme.TextTheme.boldText,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          // WebView(
          //   key: _key,
          //   initialUrl:
          //       "https://outfitters.com.pk/pages/simplified-store-locator-for-mobile-app",
          //   javascriptMode: JavascriptMode.unrestricted,
          //   onWebViewCreated: (WebViewController webViewController) {
          //     controller = webViewController;
          //     dragGesturePullToRefresh
          //         .setContext(context)
          //         .setController(controller);
          //   },
          //   onPageStarted: (String url) {
          //     dragGesturePullToRefresh.started();
          //   },
          //   onPageFinished: (finish) {
          //     setState(() {
          //       isLoading = false;
          //     });
          //     dragGesturePullToRefresh.finished();
          //   },
          //   gestureNavigationEnabled: true,
          //   gestureRecognizers: {
          //     Factory(() {
          //       return dragGesturePullToRefresh;
          //     })
          //   },
          //   initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
          //   userAgent: Platform.isIOS
          //       ? 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_1_2 like Mac OS X) AppleWebKit/605.1.15' +
          //           ' (KHTML, like Gecko) Version/13.0.1 Mobile/15E148 Safari/604.1'
          //       : 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) ' +
          //           'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36',
          // ),
          isLoading
              ? Center(
                  child: LoadingAnimation(),
                )
              : Stack(),
        ],
      ),
      // ),
    );
  }
}
