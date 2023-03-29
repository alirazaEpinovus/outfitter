// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:outfitters/Models/FiltersModel.dart';
// import 'package:outfitters/Models/homeScreenModel.dart';
// import 'package:outfitters/UI/Resources/Repository.dart';

// class HomeScreenNotifier with ChangeNotifier {
//   final repository = Repository();
//   DataSnapshot dataSnapshot;
//   Announcement ann;
//   Filterx filtersModel;
//   List<SliderDetails> sliders = [];
//   List<CollectionsDetails> collectionDetails = [];
//   List<SubCollections> subCollections = [];
//   List<NestedSubCollections> nestedsub = [];

//   HomeScreenNotifier() {
//     getDatabase();
//   }
//   Announcement get sss => ann;
//   Filterx get filterx => filtersModel;
//   List<SliderDetails> get slidersData => sliders;
//   List<CollectionsDetails> get collections => collectionDetails;
//   List<SubCollections> get subCollection => subCollections;
//   List<NestedSubCollections> get nestedsubColl => nestedsub;

//   getDatabase() async {
//     CollectionsList collectionsList;
//     Sliders sliderlist;
//     Announcement announcement;
//     Filterx allFiltersModel;
//     CollectionsDetails collectionsDetails;
//     SubCollections subCollection;
//     dataSnapshot = await repository.getDatabase();
//     if (dataSnapshot != null) {
//       Map<dynamic, dynamic> jsonResponse =
//           dataSnapshot.value['custom_collections'];
//       Map<dynamic, dynamic> jsonPages = dataSnapshot.value['custom_pages'];
//       Map<dynamic, dynamic> jsonAnnounce = dataSnapshot.value['announcement'];
//       Map<dynamic, dynamic> jsonFilters =
//           dataSnapshot.value['new_filters_1']['filters'];
//       announcement = new Announcement.fromJson(jsonAnnounce);
//       ann = announcement;
//       allFiltersModel = new Filterx.fromJson(jsonFilters);
//       filtersModel = allFiltersModel;
//       sliderlist = new Sliders.fromJSON(jsonPages);
//       sliders = sliderlist.sliders;
//       collectionsList = new CollectionsList.fromJSON(jsonResponse);
//       collectionDetails = collectionsList.collectionsList;
//       collectionsDetails = new CollectionsDetails.fromJSON(jsonResponse);
//       subCollections = collectionsDetails.subCollection;
//       subCollection = new SubCollections.fromJSON(jsonResponse);
//       nestedsub = subCollection.nestedSubCollection;
//       notifyListeners();
//     }
//   }
// }
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:outfitters/Models/FiltersModel.dart';
import 'package:outfitters/Models/homeScreenModel.dart';
import 'package:outfitters/UI/Resources/Repository.dart';

class HomeScreenNotifier with ChangeNotifier {
  final repository = Repository();
  DatabaseEvent dataSnapshot;
  Announcement ann;
  Filterx filtersModel;
  List<SliderDetails> sliders = [];
  List<CollectionsDetails> collectionDetails = [];
  List<SubCollections> subCollections = [];
  List<NestedSubCollections> nestedsub = [];

  HomeScreenNotifier() {
    getDatabase();
  }
  Announcement get sss => ann;
  bool isann;

  Filterx get filterx => filtersModel;
  List<SliderDetails> get slidersData => sliders;
  List<CollectionsDetails> get collections => collectionDetails;
  List<SubCollections> get subCollection => subCollections;
  List<NestedSubCollections> get nestedsubColl => nestedsub;

  getDatabase() async {
    CollectionsList collectionsList;
    Sliders sliderlist;
    Announcement announcement;
    Filterx allFiltersModel;
    CollectionsDetails collectionsDetails;
    SubCollections subCollection;
    dataSnapshot = (await repository.getDatabase());
    if (dataSnapshot != null) {
      // Map<dynamic, dynamic> jsonResponse =
      //     dataSnapshot.snapshot.value['custom_collections'];
      final jsonResponse =
          new Map<String, dynamic>.from(dataSnapshot.snapshot.value);
      //announcements
      DatabaseReference _databaseReference =
          FirebaseDatabase.instance.ref("announcement");
      final snapshot = await _databaseReference.get();
      if (snapshot.exists) {
        Map<String, dynamic> snapshotValue =
            Map<String, dynamic>.from(snapshot.value as Map);
        announcement = Announcement.fromJson((snapshotValue));
        ann = announcement;

        isann = announcement.isAnnounce;
        notifyListeners();
        print("ann:::::::::::::::::::::::::::::::::::::::${ann}");
      }
      // Map<dynamic, dynamic> jsonPages = dataSnapshot.value['custom_pages'];

      //custom collection

      DatabaseReference databaseReference1 =
          FirebaseDatabase.instance.ref("custom_pages");
      final snapshotCustomPages = await databaseReference1.get();
      if (snapshotCustomPages.exists) {
        Map<String, dynamic> snapshotValuePages =
            Map<String, dynamic>.from(snapshotCustomPages.value as Map);
        sliderlist = new Sliders.fromJSON(snapshotValuePages);
        sliders = sliderlist.sliders;
        // Map<dynamic, dynamic> jsonAnnounce = dataSnapshot.value['announcement'];
        // Map<dynamic, dynamic> jsonFilters =
        //     dataSnapshot.snapshot.value['new_filters_1']['filters'];
        DatabaseReference _databaseReferenceFilter =
            FirebaseDatabase.instance.ref("new_filters_1");
        final snapshotFilters = await _databaseReferenceFilter.get();
        if (snapshotFilters.exists) {
          Map<String, dynamic> snapshotValueFiltes =
              Map<String, dynamic>.from(snapshotFilters.value as Map);

          allFiltersModel = Filterx.fromJson((snapshotValueFiltes["filters"]));
          filtersModel = allFiltersModel;
        }
        print(
            "filters::::::::::::::::::::::::::::::::::::::::::::::::::::::::$filterx");
        notifyListeners();
      }

      // announcement = new Announcement.fromJson(jsonAnnounce);
      // ann = announcement;
      // allFiltersModel = new Filterx.fromJson(jsonFilters);
      // filtersModel = allFiltersModel;
      // sliderlist = new Sliders.fromJSON(jsonPages);
      // sliders = sliderlist.sliders;

      DatabaseReference dbCollection =
          FirebaseDatabase.instance.ref("custom_collections");
      final snapshotCollectionPages = await dbCollection.get();

      if (snapshotCollectionPages.exists) {
        Map<String, dynamic> snapshotValueCollection =
            Map<String, dynamic>.from(snapshotCollectionPages.value as Map);
        collectionsList = new CollectionsList.fromJSON(snapshotValueCollection);
        collectionDetails = collectionsList.collectionsList;

        collectionsList = new CollectionsList.fromJSON(snapshotValueCollection);
        collectionDetails = collectionsList.collectionsList;

        subCollection = SubCollections.fromJSON(snapshotValueCollection);
        nestedsub = subCollection.nestedSubCollection;

        print(
            "collections::::::::::::::::::::::::::::::::::::::::::::::::::::::::$snapshotValueCollection");
        notifyListeners();
      }
      notifyListeners();
    }
  }
}
