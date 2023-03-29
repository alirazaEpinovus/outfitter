import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InternetError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset('assets/images/connection.svg'),
          Text('No Connection',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
          Padding(
             padding: EdgeInsets.symmetric(vertical: 5),
            child: Text('Slow or not internet connection.')),
          Text('Please check your internet settings.')
        ],
      ),
    );
  }
}