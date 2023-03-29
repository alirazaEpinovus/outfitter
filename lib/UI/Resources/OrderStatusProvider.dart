import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:outfitters/Models/OrderTrackingModel.dart';

class OrderStatusProvider {
  Future<OrderTrackingModel> getOrderStatus(
      BuildContext context, int orderID) async {
    String order = "LL" + orderID.toString();
    OrderTrackingModel orderTrackingModel;

    var graphResponse = await http.get(Uri.parse(
        'https://spiaunified.alchemative.net/api/courierStatus/CourierStatus?OrderName=$order'));

    if (graphResponse.body != null) {
      var jsonData = json.decode(graphResponse.body);

      orderTrackingModel = OrderTrackingModel(
          statusCode: jsonData['statusCode'], status: jsonData['status']);
    }

    return orderTrackingModel;
  }
}
