import 'package:firebase_database/firebase_database.dart';
import 'dart:async' show Future;
import 'package:outfitters/Models/homeScreenModel.dart';

class MakeCall {
  final databaseReference = FirebaseDatabase.instance.ref();

  Future<DatabaseEvent> getDatabase() async {
    DatabaseEvent dataSnapshot = await databaseReference.once();
    return dataSnapshot;
  }
}
