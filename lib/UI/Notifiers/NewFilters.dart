import 'package:flutter/material.dart';
import 'package:outfitters/Models/homeScreenModel.dart';
import 'package:outfitters/UI/Resources/Repository.dart';

class FilterNotifier with ChangeNotifier {
  SubCollections filtersModel;
  final _repository = Repository();

  bool isfiltersapply = false;
  bool get applufilters => isfiltersapply;

  List<Item> colors = [];
  List<Item> size = [];
  List<Item> price = [];
  int sortingIndex = 0;

  int get indexSelect => sortingIndex;

  indexUpdate(int index) {
    sortingIndex = index;
    notifyListeners();
  }

  SubCollections get getfiletrs => filtersModel;

  List<Item> get colorsfilters => colors;
  List<Item> get sizefilters => size;
  List<Item> get typefilters => price;

  setFiltersStatus(bool isapply) {
    isfiltersapply = isapply;
    if (!isapply) {
      resetfilters();
    }
    notifyListeners();
  }

  setIndex(index) {
    sortingIndex = index;
  }

  FilterNotifier() {
    //filetrsData();
  }
  filetrsData() async {
    SubCollections data = await _repository.getfilters();
    filtersModel = data;
    colors = filtersModel.filters.colors;
    size = filtersModel.filters.size;
    price = filtersModel.filters.price;
    notifyListeners();
  }

  void resetfilters() {
    colors.forEach((data) {
      data.setSelected(false);
    });
    size.forEach((data) {
      data.setSelected(false);
    });
    price.forEach((data) {
      data.setSelected(false);
    });

    notifyListeners();
  }
}
