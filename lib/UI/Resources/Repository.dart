import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:outfitters/Models/OrderTrackingModel.dart';
import 'package:outfitters/Models/homeScreenModel.dart';
import 'package:outfitters/NetworkUtils/getMainListInformation.dart';
import 'package:outfitters/UI/Resources/NewFirebaseProvider.dart';
import 'package:outfitters/UI/Resources/OrderStatusProvider.dart';

class Repository {
  final firebaseProvider = NewFirebaseProvider();
  final getmainInformation = MakeCall();
  final orderRepository = OrderStatusProvider();

  Future<SubCollections> getfilters() => firebaseProvider.fetchFilters();

  Future<DatabaseEvent> getDatabase() => getmainInformation.getDatabase();

  Future<OrderTrackingModel> getOrderStatus(
          BuildContext context, int orderID) =>
      orderRepository.getOrderStatus(context, orderID);
}
