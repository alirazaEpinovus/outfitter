import 'package:flutter/material.dart';
import 'package:outfitters/Database/DatabaseHelper.dart';
import 'package:outfitters/Models/CartModel.dart';

class CartNotifier with ChangeNotifier {
  bool isEdit = false;
  bool get iseditcart => isEdit;
  List<CartModel> cartList = [];
  final database = DatabaseHelper.instance;

  int get totalItems => cartList.length;
  int totalQuantity() {
    int total = 0;
    cartList.forEach((data) {
      total += data.quantity;
    });
    return total;
  }

  int get totals => totalQuantity();

  CartNotifier() {
    getcart();
  }

  isclickEdit(bool edit) {
    this.isEdit = edit;
    notifyListeners();
  }

  getcart() async {
    var list = await database.queryAllRows();
    debugPrint('list: ${list}');
    if (list.isNotEmpty) {
      cartList = list;
    } else {
      cartList.clear();
    }

    notifyListeners();
  }
}
