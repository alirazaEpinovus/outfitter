import 'package:flutter/material.dart';
import 'package:outfitters/Models/ProductsModel.dart';

class SoldOut extends StatefulWidget {
  final Productnode productnode;
  final double verticalpadding;
  final double horizontalpadding;
  final double textSize;
  SoldOut(
      {@required this.productnode,
      @required this.horizontalpadding,
      @required this.verticalpadding,
      @required this.textSize})
      : assert(productnode != null),
        assert(horizontalpadding != null),
        assert(verticalpadding != null),
        assert(textSize != null);
  @override
  _SoldOutState createState() => _SoldOutState(this.productnode,
      this.horizontalpadding, this.verticalpadding, this.textSize);
}

class _SoldOutState extends State<SoldOut> {
  final Productnode productnode;
  final double verticalpadding;
  final double horizontalpadding;
  final double textSize;
  _SoldOutState(this.productnode, this.horizontalpadding, this.verticalpadding,
      this.textSize);
  int findout = 0;

  @override
  void initState() {
    productnode.variants.variantedges.forEach((data) {
      if (data.variantnode.available) {
        setState(() {
          findout++;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return findout == 0
        ? Container(
            // margin: edgesInsets.only(left:3),
            padding: EdgeInsets.symmetric(
                vertical: verticalpadding, horizontal: horizontalpadding),
            color: Colors.grey,
            child: Text(
              'Sold Out',
              style: TextStyle(color: Colors.white),
            ))
        : SizedBox();
  }
}
