import 'package:flutter/material.dart';
import 'package:outfitters/Models/OrderTrackingModel.dart';
import 'package:outfitters/UI/Resources/Repository.dart';

import 'package:rxdart/subjects.dart';

class OrderStatusBloc implements BaseBloc {
  final _repository = Repository();
  final fetchstatus = PublishSubject<OrderTrackingModel>();

  Stream<OrderTrackingModel> get fetchorderData => fetchstatus.stream;

  getstatus(BuildContext context, int orderId) async {
    await _repository.getOrderStatus(context, orderId).then((onValue) {
      if (onValue == null) {
        fetchstatus.sink.addError('not available data');
      } else {
        fetchstatus.sink.add(onValue);
      }
    });
  }

  @override
  void dispose() {
    fetchstatus.close();
  }
}

abstract class BaseBloc {
  void dispose();
}
