import 'package:flutter/material.dart';

class PhotoItem2 extends StatefulWidget {
  final String imageUrl;
  const PhotoItem2({
    @required this.imageUrl,
    Key key,
  }) : super(key: key);
  @override
  _PhotoItem2State createState() => _PhotoItem2State();
}

class _PhotoItem2State extends State<PhotoItem2> {
  @override
  Widget build(BuildContext context) {
    // print("url is  " + widget.imageUrl);
    return
        // productModel.images.imagesedges.where(
        //     (element) =>
        //         element.imagesnode.altText ==
        //         productModel
        //             .options.first.values[cValue])
        //   ..map<Widget>((item) {
        //     return PhotoItem2(
        //         imageUrl: item.imagesnode.src);
        //   });
        Container(
      // width: MediaQuery.of(context).size.width,
      child: Image.network(
        widget.imageUrl,
      ),
    );
  }
}
