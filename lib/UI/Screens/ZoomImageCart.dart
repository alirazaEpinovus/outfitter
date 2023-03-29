import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:photo_view/photo_view.dart';

class GalleryCart extends StatefulWidget {
  final imagesList;

  GalleryCart({Key key, this.imagesList}) : super(key: key);
  @override
  _GalleryCartState createState() => _GalleryCartState();
}

class _GalleryCartState extends State<GalleryCart> {
  var scrollController = ScrollController();
  bool isScroll = false;
  var scroll;
  @override
  void initState() {
    scroll = BouncingScrollPhysics();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          controller: scrollController,
          shrinkWrap: true,
          children: <Widget>[
            Container(
              height: 550,
              child: Swiper(
                itemCount: widget.imagesList.length,
                autoplay: false,
                loop: false,
                physics: scroll,
                onIndexChanged: (v) {
                  if (v == widget.imagesList.length - 1) {
                    scrollController
                        .jumpTo(scrollController.position.maxScrollExtent);
                    setState(() {
                      isScroll = true;
                    });
                  } else {
                    scrollController
                        .jumpTo(scrollController.position.minScrollExtent);
                    setState(() {
                      isScroll = false;
                    });
                  }
                },
                scrollDirection: Axis.vertical,
                pagination: new SwiperPagination(
                    alignment: FractionalOffset.centerLeft,
                    margin: EdgeInsets.only(left: 20),
                    builder: DotSwiperPaginationBuilder(
                        activeColor: Colors.black, color: Colors.grey[700])),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      color: Colors.white,
                      // height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        child: PhotoView(
                          backgroundDecoration:
                              BoxDecoration(color: Colors.white),
                          imageProvider: CachedNetworkImageProvider(
                            widget.imagesList[index].img.src,
                          ),
                          maxScale: PhotoViewComputedScale.covered * 10.0,
                          minScale: PhotoViewComputedScale.covered,
                          // initialScale: PhotoViewComputedScale.covered ,
                        ),
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
    // }));
  }
}
