import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:foodbuds0_1/models/user_model.dart';

class DatabaseRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> createUser(User user) async {
    await _firebaseFirestore.collection('users').doc(user.id).set(user.toMap());
  }

  Stream<User> getUser(String userId) {
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snap) => User.fromSnapshot(snap));
  }

  Future<void> updateUser(String userId, Map<String, dynamic> updatedData) {
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .update(updatedData);
  }
}
