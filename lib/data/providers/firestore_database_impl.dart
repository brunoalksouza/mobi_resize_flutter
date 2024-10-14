import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobi_resize_flutter/data/providers/interfaces/firestore_database.dart';

class FirestoreDatabaseImpl implements FirestoreDatabase {
  String appName;

  FirestoreDatabaseImpl({
    required this.appName,
  });

  @override
  FirebaseFirestore get() {
    return FirebaseFirestore.instanceFor(app: Firebase.app(appName));
  }

  @override
  CollectionReference<Map<String, dynamic>> getCollection(
      {required String collection}) {
    return get().collection(collection);
  }
}
