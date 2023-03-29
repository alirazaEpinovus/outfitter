import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;

class ScanInfo extends StatefulWidget {
  @override
  _ScanInfoState createState() => _ScanInfoState();
}

class _ScanInfoState extends State<ScanInfo> {
  @override
  Widget build(BuildContext context) {
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
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text(
                'How to Scan ?',
                style: AppTheme.TextTheme.boldText,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 15, left: 30, right: 30),
              child: Text(
                "1- Click on the scan option. \n2- Use your mobile's rear camera.\n3- Hold the tag in the scanning box position(e.g. verticle/horizontal or sqare/rectangle)\n3- Scan the tag.",
                textAlign: TextAlign.left,
                style: TextStyle(letterSpacing: 0.5, height: 1.3),
              ),
            )
          ],
        ),
      ),
    );
  }
}
