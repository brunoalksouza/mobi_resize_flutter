import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobi_resize_flutter/data/models/user/user_model.dart';

class UserProvider {
  static final _userCollection =
      FirebaseFirestore.instanceFor(app: Firebase.app("accounts"))
          .collection("Users");

  static Future<UserModel> get({required String uid}) async {
    QuerySnapshot _doc =
        await _userCollection.where("uid", isEqualTo: uid).get();
    return UserModel.fromMap(_doc.docs.single.data() as Map<String, dynamic>);
  }

  static Future<void> updateUserFirstLogin(
      String userDocId, bool firstLogin) async {
    await _userCollection.doc(userDocId).update({"firstLogin": firstLogin});
  }

  static Future<void> createDeletedField() async {
    final _usersWithDeletedField =
        await _userCollection.where('deleted', isNull: false).get();

    final _usersId = _usersWithDeletedField.docs.map((e) => e.id).toList();
    print(_usersId);

    final _users = _usersId.isEmpty
        ? await _userCollection.get()
        : await _userCollection
            .where(FieldPath.documentId, whereNotIn: _usersId)
            .get();

    for (var id in _users.docs.map((e) => e.id).toList()) {
      await _userCollection.doc(id).update({'deleted': false});
    }
  }
}
