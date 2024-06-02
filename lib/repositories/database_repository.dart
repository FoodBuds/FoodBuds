import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:foodbuds0_1/models/user_model.dart';
import 'package:foodbuds0_1/repositories/authentication_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<List<User>> getUsersWhoLiked(String currentUserId) async {
    // Query to get users who liked the current user
    QuerySnapshot snapshot = await _firebaseFirestore
        .collection('likes')
        .where('likedUserId', isEqualTo: currentUserId)
        .get();

    List<User> likedUsers = [];
    for (var doc in snapshot.docs) {
      String userId = doc['likerUserId'];
      User? user = await getUserById(userId);
      if (user != null) {
        likedUsers.add(user);
      }
    }
    return likedUsers;
  }

  Future<List<User>> getUsersWhoDisliked(String currentUserId) async {
    // Query to get users who disliked the current user
    QuerySnapshot snapshot = await _firebaseFirestore
        .collection('dislikes')
        .where('dislikedUserId', isEqualTo: currentUserId)
        .get();

    List<User> dislikedUsers = [];
    for (var doc in snapshot.docs) {
      String userId = doc['dislikerUserId'];
      User? user = await getUserById(userId);
      if (user != null) {
        dislikedUsers.add(user);
      }
    }
    return dislikedUsers;
  }

  Future<bool> isPremiumUser(String userId) async {
    // Query to check if the user is premium
    DocumentSnapshot doc = await _firebaseFirestore.collection('users').doc(userId).get();
    return doc['isPremium'] ?? false;
  }



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
          String userId = doc.id; 
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

  Future<void> likeUser(String likerUserId, String likedUserId) async {
    try {

      String docId = '$likerUserId$likedUserId';

      await _firebaseFirestore.collection('likes').doc(docId).set({
        'likerUserId': likerUserId,
        'likedUserId': likedUserId,
      });
      print("User liked successfully: $likerUserId liked $likedUserId");
    } catch (e) {
      print("Error liking user: $e");
      rethrow; 
    }
  }
  
    Future<void> dislikeUser(String dislikerUserId, String dislikedUserId) async {
    try {

      String docId = '$dislikerUserId$dislikedUserId';

      await _firebaseFirestore.collection('dislikes').doc(docId).set({
        'dislikerUserId': dislikerUserId,
        'dislikedUserId': dislikedUserId,
      });
      print("User liked successfully: $dislikerUserId liked $dislikedUserId");
    } catch (e) {
      print("Error liking user: $e");
      rethrow;  // Rethrow the error to be caught by the calling function
    }
  }

  Future<bool> checkForMatch(String userId, String likedUserId) async {
    try {
      DocumentSnapshot doc = await _firebaseFirestore.collection('likes').doc('$userId$likedUserId').get();
      if (doc.exists) {
        DocumentSnapshot reverseDoc = await _firebaseFirestore.collection('likes').doc('$likedUserId$userId').get();
        return reverseDoc.exists;
      }
    } catch (e) {
      print("Error checking for match: $e");
    }
    return false;
  }

Future<List<String>> matchUsers() async {

    String currentUserId = await AuthenticationRepository().getUserId() as String;
    User currentUser = await getUserById(currentUserId) as User;

    List<MapEntry<User, int>> potentialMatches = [];
    
    QuerySnapshot querySnapshot;

    if (currentUser.genderPreference == 'everyone') {
      querySnapshot = await FirebaseFirestore.instance.collection('users').get();
    } else {
      querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('gender', isEqualTo: currentUser.genderPreference)
          .get();
    }

    List<User> allUsers = querySnapshot.docs.map((doc) => User.fromSnapshot(doc)).toList();

    for (User user in allUsers) {
      String? _userId = user.id;
      if (user.id == currentUser.id) {
        continue;
      }
      DocumentSnapshot ifLiked = await _firebaseFirestore.collection('likes').doc('$currentUserId$_userId').get();
      DocumentSnapshot ifDisliked = await _firebaseFirestore.collection('dislikes').doc('$currentUserId$_userId').get();

      if (ifLiked.exists || ifDisliked.exists){
        continue;
      }
      int score = 0;

      if (currentUser.diet == user.diet) {
        score += 50;
      }

      List<String> commonCuisines = currentUser.cuisine
          .where((cuisine) => user.cuisine.contains(cuisine))
          .toList();
      double cuisineScore = (commonCuisines.length /
              ((currentUser.cuisine.length + user.cuisine.length) / 2)) *
          50;
      score += cuisineScore.round();
      potentialMatches.add(MapEntry(user, score));
    }
    potentialMatches.sort((a, b) => b.value.compareTo(a.value));
    List<String> matchedUserIds = potentialMatches
    .map((entry) => entry.key.id) 
    .where((id) => id != null) 
    .map((id) => id!) 
    .toList(); 
    return matchedUserIds;
  }
}

