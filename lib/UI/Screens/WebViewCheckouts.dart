import 'package:flutter/material.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:outfitters/Database/DatabaseHelper.dart';
import 'package:outfitters/UI/Notifiers/CartNotifier.dart';
import 'package:outfitters/UI/Widgets/LoadingAnimation.dart';
import 'package:provider/provider.dart';

class WebViewCheckouts extends StatefulWidget {
  final weburl;

  WebViewCheckouts({@required this.weburl}) : assert(weburl != null);
  @override
  _WebViewCheckoutsState createState() => _WebViewCheckoutsState();
}

class _WebViewCheckoutsState extends State<WebViewCheckouts> {
  final databasehelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    // final flutterWebviewPlugin = new FlutterWebviewPlugin();
    // flutterWebviewPlugin.onUrlChanged.listen((String url) {
    //   if (url.indexOf('thank_you') > 0) {
    //     Provider.of<CartNotifier>(context, listen: false).getcart();
    //     _deleteItem();
    //   }
    // });

    return Text("data");
      // WebviewScaffold(
      //   url: "${widget.weburl}",
      //   mediaPlaybackRequiresUserGesture: false,
      //   appBar: AppBar(
      //     backgroundColor: Colors.white,
      //     foregroundColor: Colors.black,
      //     automaticallyImplyLeading: true,
      //     iconTheme: IconThemeData(
      //       color: Colors.black, //change your color here
      //     ),
      //     title: const Text(
      //       'Checkout',
      //       style: TextStyle(color: Colors.black),
      //     ),
      //   ),
      //   hidden: true,
      //   initialChild: Container(
      //     height: MediaQuery.of(context).size.height * 0.8,
      //     child: Center(child: LoadingAnimation()),
      //   ));
  }

  _deleteItem() {
    databasehelper.delete().whenComplete(() {
      setState(() {});
    });
  }
}
