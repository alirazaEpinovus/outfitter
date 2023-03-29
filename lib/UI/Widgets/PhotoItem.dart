import 'package:flutter/material.dart';

class PhotoItem extends StatefulWidget {
  final String imageUrl;
  const PhotoItem({
    @required this.imageUrl,
    Key key,
  }) : super(key: key);
  @override
  _PhotoItemState createState() => _PhotoItemState();
}

class _PhotoItemState extends State<PhotoItem> {
  @override
  Widget build(BuildContext context) {
    // print("url is  " + widget.imageUrl);
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Image.network(
          widget.imageUrl,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fill,
        ));
  }
}
