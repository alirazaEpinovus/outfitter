import 'package:flutter/material.dart';
import 'package:outfitters/Models/ProductsModel.dart';

class ActiveWear extends StatefulWidget {
  final Productnode productnode;
  final double verticalpadding;
  final double horizontalpadding;
  final double textSize;
  ActiveWear(
      {@required this.productnode,
      @required this.horizontalpadding,
      @required this.verticalpadding,
      @required this.textSize})
      : assert(productnode != null),
        assert(horizontalpadding != null),
        assert(verticalpadding != null),
        assert(textSize != null);
  @override
  _ActiveWearState createState() => _ActiveWearState(this.productnode,
      this.horizontalpadding, this.verticalpadding, this.textSize);
}

class _ActiveWearState extends State<ActiveWear> {
  final Productnode productnode;
  final double verticalpadding;
  final double horizontalpadding;
  final double textSize;
  _ActiveWearState(this.productnode, this.horizontalpadding, this.verticalpadding,
      this.textSize);
  int findout = 0;

  @override
  void initState() {
    productnode.tags.forEach((data) {
      if (data.contains("Activewear")) {
        setState(() {
          findout++;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return findout != 0
        ? Container(
            // margin: edgesInsets.only(left:3),
            padding: EdgeInsets.symmetric(
                vertical: verticalpadding, horizontal: horizontalpadding),
            color: Colors.green,
            child: Text(
              'Activewear',
              style: TextStyle(color: Colors.white),
            ))
        : SizedBox();
  }
}
