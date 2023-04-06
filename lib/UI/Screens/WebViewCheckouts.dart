import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:outfitters/Database/DatabaseHelper.dart';
import 'package:outfitters/UI/Notifiers/CartNotifier.dart';
import 'package:outfitters/UI/Widgets/LoadingAnimation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewCheckouts extends StatefulWidget {
  final weburl;

  WebViewCheckouts({@required this.weburl}) : assert(weburl != null);
  @override
  _WebViewCheckoutsState createState() => _WebViewCheckoutsState();
}

class _WebViewCheckoutsState extends State<WebViewCheckouts> {
  final databasehelper = DatabaseHelper.instance;

  double progress = 0;

  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    // final flutterWebviewPlugin = new FlutterWebviewPlugin();
    // flutterWebviewPlugin.onUrlChanged.listen((String url) {
    //   if (url.indexOf('thank_you') > 0) {
    //     Provider.of<CartNotifier>(context, listen: false).getcart();
    //     _deleteItem();
    //   }
    // });
    // WebviewScaffold(
    //   url: "${widget.weburl}",
    //   mediaPlaybackRequiresUserGesture: false,
    // appBar: AppBar(
    //   backgroundColor: Colors.white,
    //   foregroundColor: Colors.black,
    //   automaticallyImplyLeading: true,
    //   iconTheme: IconThemeData(
    //     color: Colors.black, //change your color here
    //   ),
    //   title: const Text(
    //     'Checkout',
    //     style: TextStyle(color: Colors.black),
    //   ),
    // ),
    //   hidden: true,
    //   initialChild: Container(
    //     height: MediaQuery.of(context).size.height * 0.8,
    //     child: Center(child: LoadingAnimation()),
    //   ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
                // padding: EdgeInsets.all(10.0),
                child: progress < 1.0
                    ? LinearProgressIndicator(value: progress)
                    : Container()),
            Container(
              //  height: MediaQuery.of(context).size.height,
              child: Expanded(
                child: Container(
                  //  height: MediaQuery.of(context).size.height,
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(
                        url: Uri.parse(
                      "${widget.weburl}",
                    )),
                    onLoadStart: (controller, urlx) async {
                      print("urlx: ${urlx}");
                      String lastWord = urlx.toString().split('/').last;
                      print(lastWord);
                      if (urlx.toString().contains('thank_you')) {
                        _deleteItem();
                        // Future.delayed(Duration(seconds: 1), ()=> );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _deleteItem() {
    databasehelper.delete().whenComplete(() {
      Provider.of<CartNotifier>(context, listen: false).getcart();
    });
  }
}
