import 'package:firebase_database/firebase_database.dart';
import 'package:outfitters/Models/homeScreenModel.dart';

class NewFirebaseProvider {
  final databaseReference = FirebaseDatabase.instance.ref();

  Future<SubCollections> fetchFilters() async {
    DatabaseEvent snapshot = await databaseReference.once();

    return SubCollections.fromJSON(snapshot.snapshot.value);
  }
}
