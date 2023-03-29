// import 'package:flutter/material.dart';
// import 'package:outfitters/Models/FiltersModel.dart';
// import 'package:outfitters/UI/Resources/Repository.dart';

// class FilterNotifier with ChangeNotifier {
//   FiltersModel filtersModel;
//   final _repository = Repository();

//   bool isfiltersapply = false;
//   bool get applufilters => isfiltersapply;
//   Price pricefilters = Price(max: "1000", min: "0");

//   List<Item> colors = [];
//   List<Item> size = [];
//   List<Item> productType = [];
//   int sortingIndex = 0;

//   int get indexSelect => sortingIndex;

//   indexUpdate(int index) {
//     sortingIndex = index;
//     notifyListeners();
//   }

//   FiltersModel get getfiletrs => filtersModel;

//   List<Item> get colorsfilters => colors;
//   List<Item> get sizefilters => size;
//   List<Item> get typefilters => productType;
//   Price get priceRange => pricefilters;

//   setFiltersStatus(bool isapply) {
//     isfiltersapply = isapply;
//     if (!isapply) {
//       resetfilters();
//     }
//     notifyListeners();
//   }

//   FilterNotifier() {
//     filetrsData();
//   }
//   filetrsData() async {
//     FiltersModel data = await _repository.getfilters();
//     //if(data!=null)
//     filtersModel = data;
//     colors = filtersModel.filters.first.colors;
//     size = filtersModel.filters.first.size;
//     productType = filtersModel.filters.first.productType;
//     // pricefilters = filtersModel.filters.first.price.first;
//     notifyListeners();
//   }

//   void resetfilters() {
//     colors.forEach((data) {
//       data.setSelected(false);
//     });
//     size.forEach((data) {
//       data.setSelected(false);
//     });
//     productType.forEach((data) {
//       data.setSelected(false);
//     });

//     notifyListeners();
//   }

//   updatepricefilter(double minimum, double maximum) {
//     pricefilters.min = '$minimum';
//     pricefilters.max = '$maximum';
//     print('mini ====== ${pricefilters.min}');
//     print('max ====== ${pricefilters.max}');
// //notifyListeners();
//   }
// }
