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
      // Create a reference to the location you want to upload to

      Reference ref =
          _firebaseStorage.ref().child('uploads/${file.path.split('/').last}');

      // Upload the file
      await ref.putFile(file);

      // Get the download URL (optional)
      String downloadURL = await ref.getDownloadURL();

      return downloadURL;
    } on FirebaseException catch (e) {
      // Handle errors
      print('Failed to upload file: $e');
      return null;
    }
  }
}
