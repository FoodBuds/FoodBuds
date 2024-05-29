import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:foodbuds0_1/models/user_model.dart';
import 'package:foodbuds0_1/repositories/authentication_repository.dart';

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

  Future<void> updateUser(Map<String, dynamic> updatedData) async {
    String? userId = await AuthenticationRepository().getUserId();
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .update(updatedData);
  }

  Future<void> deleteUser(String userId) {
    return _firebaseFirestore.collection('users').doc(userId).delete();
  }
  
}
