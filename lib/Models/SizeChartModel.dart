// To parse this JSON data, do
//
//     final sizechartmodel = sizechartmodelFromMap(jsonString);

import 'dart:convert';

SizeChartModel sizechartmodelFromMap(String str) =>
    SizeChartModel.fromMap(json.decode(str));

String sizechartmodelToMap(SizeChartModel data) => json.encode(data.toMap());

class SizeChartModel {
  SizeChartModel({
    this.styleData,
    this.sizeChart,
  });

  StyleData styleData;
  SizeChart sizeChart;

  factory SizeChartModel.fromMap(Map<String, dynamic> json) => SizeChartModel(
        styleData: json["style_data"] == null
            ? null
            : StyleData.fromMap(json["style_data"]),
        sizeChart: json["size_chart"] == null
            ? null
            : SizeChart.fromMap(json["size_chart"]),
      );

  Map<String, dynamic> toMap() => {
        "style_data": styleData == null ? null : styleData.toMap(),
        "size_chart": sizeChart == null ? null : sizeChart.toMap(),
      };
}

class SizeChart {
  SizeChart({
    this.id,
    this.shopId,
    this.title,
    this.topDescription,
    this.bottomDescription,
    this.enable,
    this.gridSizechart,
    this.created,
    this.modified,
    this.tags,
    this.sizechartType,
    this.leftHeader,
    this.rightHeader,
    this.topHeader,
    this.bottomHeader,
    this.delete,
  });

  int id;
  int shopId;
  String title;
  String topDescription;
  String bottomDescription;
  bool enable;
  List<List<String>> gridSizechart;
  DateTime created;
  DateTime modified;
  String tags;
  String sizechartType;
  bool leftHeader;
  bool rightHeader;
  bool topHeader;
  bool bottomHeader;
  bool delete;

  factory SizeChart.fromMap(Map<String, dynamic> json) => SizeChart(
        id: json["id"] == null ? null : json["id"],
        shopId: json["shop_id"] == null ? null : json["shop_id"],
        title: json["title"] == null ? null : json["title"],
        topDescription:
            json["top_description"] == null ? null : json["top_description"],
        bottomDescription: json["bottom_description"] == null
            ? null
            : json["bottom_description"],
        enable: json["enable"] == null ? null : json["enable"],
        gridSizechart: json["grid_sizechart"] == null
            ? null
            : List<List<String>>.from(json["grid_sizechart"]
                .map((x) => List<String>.from(x.map((x) => x)))),
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        modified:
            json["modified"] == null ? null : DateTime.parse(json["modified"]),
        tags: json["tags"] == null ? null : json["tags"],
        sizechartType:
            json["sizechart_type"] == null ? null : json["sizechart_type"],
        leftHeader: json["left_header"] == null ? null : json["left_header"],
        rightHeader: json["right_header"] == null ? null : json["right_header"],
        topHeader: json["top_header"] == null ? null : json["top_header"],
        bottomHeader:
            json["bottom_header"] == null ? null : json["bottom_header"],
        delete: json["delete"] == null ? null : json["delete"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "shop_id": shopId == null ? null : shopId,
        "title": title == null ? null : title,
        "top_description": topDescription == null ? null : topDescription,
        "bottom_description":
            bottomDescription == null ? null : bottomDescription,
        "enable": enable == null ? null : enable,
        "grid_sizechart": gridSizechart == null
            ? null
            : List<dynamic>.from(
                gridSizechart.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "created": created == null ? null : created.toIso8601String(),
        "modified": modified == null ? null : modified.toIso8601String(),
        "tags": tags == null ? null : tags,
        "sizechart_type": sizechartType == null ? null : sizechartType,
        "left_header": leftHeader == null ? null : leftHeader,
        "right_header": rightHeader == null ? null : rightHeader,
        "top_header": topHeader == null ? null : topHeader,
        "bottom_header": bottomHeader == null ? null : bottomHeader,
        "delete": delete == null ? null : delete,
      };
}

class StyleData {
  StyleData({
    this.id,
    this.gridHeaderColor,
    this.gridBackgroundColor,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.possibleSizes,
    this.shop,
  });

  int id;
  String gridHeaderColor;
  String gridBackgroundColor;
  String backgroundColor;
  String textColor;
  String borderColor;
  String possibleSizes;
  int shop;

  factory StyleData.fromMap(Map<String, dynamic> json) => StyleData(
        id: json["id"] == null ? null : json["id"],
        gridHeaderColor:
            json["gridHeaderColor"] == null ? null : json["gridHeaderColor"],
        gridBackgroundColor: json["gridBackgroundColor"] == null
            ? null
            : json["gridBackgroundColor"],
        backgroundColor:
            json["backgroundColor"] == null ? null : json["backgroundColor"],
        textColor: json["textColor"] == null ? null : json["textColor"],
        borderColor: json["borderColor"] == null ? null : json["borderColor"],
        possibleSizes:
            json["possibleSizes"] == null ? null : json["possibleSizes"],
        shop: json["shop"] == null ? null : json["shop"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "gridHeaderColor": gridHeaderColor == null ? null : gridHeaderColor,
        "gridBackgroundColor":
            gridBackgroundColor == null ? null : gridBackgroundColor,
        "backgroundColor": backgroundColor == null ? null : backgroundColor,
        "textColor": textColor == null ? null : textColor,
        "borderColor": borderColor == null ? null : borderColor,
        "possibleSizes": possibleSizes == null ? null : possibleSizes,
        "shop": shop == null ? null : shop,
      };
}
