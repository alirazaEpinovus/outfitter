import 'package:flutter/material.dart';
import 'package:outfitters/Utils/AppThemeData.dart' as AppTheme;

class SizeChartImages extends StatefulWidget {
  final List<dynamic> sizechart;
  SizeChartImages({@required this.sizechart}) : assert(sizechart != null);
  @override
  _SizeChartState createState() => _SizeChartState(this.sizechart);
}

class _SizeChartState extends State<SizeChartImages> {
  final List<dynamic> sizechart;
  _SizeChartState(this.sizechart);
  int selectsize = -1;
  List<String> sizes = [
    'men-size-chart',
    'women-size-chart',
    'JuniorsGirlsSize-chart',
    'JuniorsBoys-size-chart',
    'ToddlerGirlsSize-chart',
    'ToddlerBoysSize-chart'
  ];

  @override
  void initState() {
    if (sizechart.contains(sizes[0])) {
      setState(() {
        selectsize = 0;
      });
    } else if (sizechart.contains(sizes[1])) {
      setState(() {
        selectsize = 1;
      });
    } else if (sizechart.contains(sizes[2])) {
      setState(() {
        selectsize = 2;
      });
    } else if (sizechart.contains(sizes[3])) {
      setState(() {
        selectsize = 3;
      });
    } else if (sizechart.contains(sizes[4])) {
      setState(() {
        selectsize = 4;
      });
    } else if (sizechart.contains(sizes[5])) {
      setState(() {
        selectsize = 5;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            'Size Chart',
            style: AppTheme.TextTheme.titlebold,
          ),
          elevation: 1,
          leading: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(Icons.clear)),
        ),
        body: selectsize == -1
            ? Container(
                child: Center(
                  child: Text('No Size Chart Available'),
                ),
              )
            : SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height,
                  child: Image.asset(
                    'assets/sizecharts/${sizes[selectsize]}.jpg',
                  ),
                ),
              ));
  }
}
