import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;
import 'package:html/dom.dart' as dom;

class CompositionAndCare extends StatefulWidget {
  final String descriptionHtml;
  CompositionAndCare({@required this.descriptionHtml})
      : assert(descriptionHtml != null);
  @override
  _CompositionAndCareState createState() =>
      _CompositionAndCareState(this.descriptionHtml);
}

class _CompositionAndCareState extends State<CompositionAndCare> {
  final String descriptionHtml;
  _CompositionAndCareState(this.descriptionHtml);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'Composition And Care',
          style: AppTheme.TextTheme.titlebold,
        ),
        elevation: 1,
        leading: InkWell(
            onTap: () => Navigator.of(context).pop(), child: Icon(Icons.clear)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 20, left: 15, right: 15),
          child: Html(
            data: """
    $descriptionHtml
  """,
            //Optional parameters:
            //Optional parameters:
            // linkStyle: const TextStyle(
            //   color: Colors.redAccent,
            //   letterSpacing: 1,
            //   height: 1,
            //   decorationColor: Colors.redAccent,
            //   decoration: TextDecoration.underline,
            // ),
            // onLinkTap: (url) {},
            // onImageTap: (src) {},
            // //Must have useRichText set to false for this to work
            // customRender: (node, children) {
            //   if (node is dom.Element) {
            //     // switch (node.localName) {
            //     //   case "custom_tag":
            //     //     return Column(children: children);
            //     // }
            //   }
            //   return null;
            // },
            // customTextAlign: (dom.Node node) {
            //   if (node is dom.Element) {
            //     // switch (node.localName) {
            //     //   case "p":
            //     //     return TextAlign.justify;
            //     // }
            //   }
            //   return null;
            // },
            // customTextStyle: (dom.Node node, TextStyle baseStyle) {
            //   if (node is dom.Element) {
            //     // switch (node.localName) {
            //     //   case "p":
            //     //     return baseStyle.merge(TextStyle(height: 2, fontSize: 20));
            //     // }
            //   }
            //   return baseStyle;
            // },
          ),
        ),
      ),
    );
  }
}
