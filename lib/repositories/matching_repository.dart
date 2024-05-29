import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodbuds0_1/models/user_model.dart'; // User modelinizin doğru yolunu burada belirtin

/*
Future<Map<User, int>> matchUsers(User currentUser) async {
  Map<User, int> potentialMatches = {};

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
    // Kendi kendisiyle eşleşmeyi önlemek için kontrol ekle
    if (user.id == currentUser.id) {
      continue;
    }

    int score = 0;

    // Diyet uyumu kontrolü
    if (currentUser.diet == user.diet) {
      score += 50;
    }

    // Mutfak tercihi benzerliği
    List<String> commonCuisines = currentUser.cuisine
        .where((cuisine) => user.cuisine.contains(cuisine))
        .toList();
    double cuisineScore = (commonCuisines.length /
            ((currentUser.cuisine.length + user.cuisine.length) / 2)) *
        50;
    score += cuisineScore.round();

    // Eşleşme adayını Map'e ekle
    potentialMatches[user] = score;
  }

  return potentialMatches;
}
*/

Future<Map<User, int>> matchUsers(User currentUser) async {
  Map<User, int> potentialMatches = {};

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
    // Kendi kendisiyle eşleşmeyi önlemek için kontrol ekle
    if (user.id == currentUser.id) {
      continue;
    }

    int score = 0;

    // Diyet uyumu kontrolü
    if (currentUser.diet == user.diet) {
      score += 50;
    }

    // Mutfak tercihi benzerliği
    List<String> commonCuisines = currentUser.cuisine
        .where((cuisine) => user.cuisine.contains(cuisine))
        .toList();
    double cuisineScore = (commonCuisines.length /
            ((currentUser.cuisine.length + user.cuisine.length) / 2)) *
        50;
    score += cuisineScore.round();

    // Eşleşme adayını Map'e ekle
    potentialMatches[user] = score;
  }

  // Skorlara göre sıralama
  var sortedMatches = potentialMatches.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value)); // Skorları azalan sırada sıralar

  // Sıralanmış eşleşmeleri yeniden bir Map'e dönüştürme
  Map<User, int> sortedPotentialMatches = {
    for (var entry in sortedMatches) entry.key: entry.value
  };

  return sortedPotentialMatches;
}