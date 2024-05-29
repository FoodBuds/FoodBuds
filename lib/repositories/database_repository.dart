import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:foodbuds0_1/models/user_model.dart';
import 'package:foodbuds0_1/repositories/authentication_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

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

  Future<String?> uploadFile(File file) async {
    try {
      Reference ref =
          _firebaseStorage.ref().child('uploads/${file.path.split('/').last}');

      await ref.putFile(file);

      String downloadURL = await ref.getDownloadURL();

      return downloadURL;
    } on FirebaseException catch (e) {
      print('Failed to upload file: $e');
      return null;
    }
  }

  Future<List<String>> getUserIds() async {
    List<String> userIds = [];
    try {
      QuerySnapshot querySnapshot = await _firebaseFirestore.collection('users').get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        if (doc.exists) {
          String userId = doc.id; // Belgenin ID'sini alıyoruz
          userIds.add(userId);
        }
      }
    } catch (e) {
      print("Error fetching user IDs: $e");
    }
    return userIds;
  }

  Future<User?> getUserById(String userId) async {
    try {
      DocumentSnapshot doc = await _firebaseFirestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return User.fromSnapshot(doc);
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return null;
  }
}
