import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ErrorState2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset('assets/images/sadface.svg'),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                'Ops!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )),
          Text('No product found'),
        ],
      ),
    );
  }
}
