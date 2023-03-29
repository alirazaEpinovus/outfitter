import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:outfitters/Models/SizeChartModel.dart';
import 'package:outfitters/UI/Widgets/LoadingAnimation.dart';

class SizeChartScreen extends StatefulWidget {
  final sizechart;

  const SizeChartScreen({this.sizechart, Key key}) : super(key: key);

  @override
  State<SizeChartScreen> createState() => _SizeChartScreenState();
}

class _SizeChartScreenState extends State<SizeChartScreen> {
  SizeChartModel result;
  @override
  void initState() {
    sizeChartApi();
    super.initState();
  }

  int selectedInd = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          automaticallyImplyLeading: false,
          actions: [
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    padding: EdgeInsets.all(15),
                    child: Icon(
                      Icons.close,
                      size: 22,
                    )))
          ]),
      body: result == null
          ? Center(child: LoadingAnimation())
          : Container(
              margin: EdgeInsets.all(10),
              child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Size Help",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                      SizedBox(height: 30),
                      Text("Select Size",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            itemCount:
                                result.sizeChart.gridSizechart[0].length - 1,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedInd = index + 1;
                                      });
                                    },
                                    child: Container(
                                      width: result
                                                  .sizeChart
                                                  .gridSizechart[0][index + 1]
                                                  .length <
                                              3
                                          ? 50
                                          : 65,
                                      height: 50,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
                                        border: Border.all(
                                          width: 1,
                                          color: selectedInd == index + 1
                                              ? Colors.black
                                              : Colors.grey,
                                        ),
                                        color: selectedInd == index + 1
                                            ? Colors.black
                                            : Colors.transparent,
                                      ),
                                      child: Text(
                                          result.sizeChart.gridSizechart[0]
                                              [index + 1],
                                          style: TextStyle(
                                              color: selectedInd == index + 1
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: result
                                                          .sizeChart
                                                          .gridSizechart[0]
                                                              [index + 1]
                                                          .length <
                                                      3
                                                  ? 20
                                                  : 17,
                                              fontWeight: FontWeight.normal)),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                ],
                              );
                            }),
                      ),
                      SizedBox(
                          height:
                              result.sizeChart.topDescription == "" ? 0 : 30),
                      Text(result.sizeChart.topDescription,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      SizedBox(height: 25),
                      Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: Text("MEASURMENTS",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal)),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text("CM",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal)),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text("INCH",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal)),
                          )
                        ],
                      ),
                      SizedBox(height: 17),
                      ListView.builder(
                          itemCount: result.sizeChart.gridSizechart.length - 1,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int ind) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Text(
                                        result.sizeChart.gridSizechart[ind + 1]
                                            [0],
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                        result.sizeChart.gridSizechart[ind + 1]
                                            [selectedInd],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                        "${(double.parse(result.sizeChart.gridSizechart[ind + 1][selectedInd]) * 0.393701).round()}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500)),
                                  )
                                ],
                              ),
                            );
                          }),
                      SizedBox(height: 12),
                      CachedNetworkImage(
                          imageUrl: result.sizeChart.bottomDescription)
                    ],
                  )),
            ),
    );
  }

  sizeChartApi() async {
    var dio = Dio();

    try {
      Response response = await dio.get(
        'https://sizechart-revamp-be.alche.cloud/ajax_call_sizechart?shop=outfitterspk.myshopify.com&tags=${widget.sizechart}',
      );
      if (response != null) {
        if (response.statusCode == 200) {
          result = sizechartmodelFromMap(jsonEncode(response.data));
          setState(() {});

          return result;
        }
      }
    } on DioError catch (e) {
      throw Exception(e.toString());
    }
  }
}
