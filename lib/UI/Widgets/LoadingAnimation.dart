import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  SpinKitCircle(
        itemBuilder: (_, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: index.isEven ? Colors.black : Colors.white,
            ),
          );
        },
        size: 30.0,
      
    );
  }
}