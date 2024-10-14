import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreDatabase {
  FirebaseFirestore get();
  CollectionReference<Map<String, dynamic>> getCollection(
      {required String collection});
}
