import 'package:flutter/material.dart';
import 'package:outfitters/Database/DatabaseHelper.dart';
import 'package:outfitters/Models/WishlistModel.dart';

class WishNotifier with ChangeNotifier {
  List<WishListModel> wishlistItems = [];
  final database = DatabaseHelper.instance;

  int get wishlistcount => wishlistItems.length;
  WishNotifier() {
    getWishlistCount();
    notifyListeners();
  }

  getWishlistCount() async {
    var item = await database.wishqueryAllRows();
    wishlistItems = item;
    notifyListeners();
  }
}
