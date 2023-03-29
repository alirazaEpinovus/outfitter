import 'package:flutter/material.dart';
import 'package:outfitters/UI/Widgets/LoadingAnimation.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutOutfitters extends StatefulWidget {
  final String name, url;
  AboutOutfitters({this.name, this.url});
  @override
  _AboutOutfittersState createState() => _AboutOutfittersState();
}

class _AboutOutfittersState extends State<AboutOutfitters> {
  dynamic labels;
  final _key = UniqueKey();
  WebViewController controller;
  bool loading = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 3,
        centerTitle: true,
        title: Text(
          widget.name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: Stack(
        children: [
          // WebView(
          //   key: _key,
          //   initialUrl: widget.url,
          //   // javascriptMode: JavascriptMode.unrestricted,
          //   onPageFinished: (finish) {
          //     setState(() {
          //       isLoading = false;
          //     });
          //   },
          //   onWebViewCreated: (WebViewController webViewController) {
          //     controller = webViewController;
          //   },
          // ),
          isLoading
              ? Center(
                  child: LoadingAnimation(),
                )
              : Stack(),
        ],
      ),
    );
  }
}
