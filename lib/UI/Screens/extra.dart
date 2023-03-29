import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PreferredSizeApp extends StatefulWidget {
  @override
  _PreferredSizeAppState createState() => _PreferredSizeAppState();
}

class _PreferredSizeAppState extends State<PreferredSizeApp> {
  PageController _pageController;
  var scrollViewColtroller = ScrollController();
  Duration pageTurnDuration = Duration(milliseconds: 500);
  Curve pageTurnCurve = Curves.ease;

  // @override
  // void initState() {
  //   super.initState();
  //   // The PageController allows us to instruct the PageView to change pages.
  //   _pageController = PageController();
  // }

  // void _goForward() {
  //   _pageController.nextPage(duration: pageTurnDuration, curve: pageTurnCurve);
  // }

  // void _goBack() {
  //   _pageController.previousPage(
  //       duration: pageTurnDuration, curve: pageTurnCurve);
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 22, 22, 22),
          body: NotificationListener<ScrollStartNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              print("scrollInfo up ===== ${scrollInfo.metrics.axisDirection}");
            },
            child: NotificationListener<ScrollStartNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.axisDirection == AxisDirection.down) {
                  print(
                      "scrollViewColtroller down == ${scrollViewColtroller.position.axisDirection}");
                }
              },
              child: NestedScrollView(
                controller: scrollViewColtroller,
                headerSliverBuilder:
                    (BuildContext context, bool boxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      floating: true,
                      snap: true,
                      pinned: false,
                      elevation: 10,
                    )
                  ];
                },
                body: Container(
                  padding: EdgeInsets.all(0.0),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 1,
                        ),
                        Text("ksdufgvjdygfeu")
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
