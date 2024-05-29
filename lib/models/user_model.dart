import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:foodbuds0_1/models/models.dart';

class User extends Equatable {
  final String? id;
  final String name;
  final String surname;
  final String gender;
  final String bio;
  final Diet diet;
  final GenderPreference genderPreference;
  final String? filePath;
  final List<String> cuisine;

  const User({
    this.id,
    required this.name,
    required this.surname,
    required this.gender,
    required this.bio,
    required this.diet,
    required this.genderPreference,
    this.filePath,
    required this.cuisine,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        surname,
        gender,
        bio,
        diet,
        genderPreference,
        filePath,
        cuisine,
      ];

  static User fromSnapshot2(DocumentSnapshot snap) {
    User user = User(
        id: snap.id,
        name: snap['name'],
        surname: snap['surname'],
        gender: snap['gender'],
        bio: snap['bio'],
        diet: Diet.values.firstWhere((e) =>
            e.toString().split('.').last.toLowerCase() ==
            snap['diet'].toString().toLowerCase()),
        genderPreference: GenderPreference.values.firstWhere((e) =>
            e.toString().split('.').last.toLowerCase() ==
            snap['genderPreference'].toString().toLowerCase()),
        filePath: snap['filePath'],
        cuisine: snap['cuisine']);
    return user;
  }

  // firebase holds the data as json objects and this function convert the object to a json object.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'surname': surname,
      'gender': gender,
      'bio': bio,
      'diet': diet.toString().split('.').last,
      'genderPreference': genderPreference.toString().split('.').last,
      'filePath': filePath,
      'cuisine': cuisine,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? surname,
    String? gender,
    String? bio,
    Diet? diet,
    GenderPreference? genderPreference,
    String? filePath,
    List<String>? cuisine,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      gender: gender ?? this.gender,
      bio: bio ?? this.bio,
      diet: diet ?? this.diet,
      genderPreference: genderPreference ?? this.genderPreference,
      filePath: filePath ?? this.filePath,
      cuisine: cuisine ?? this.cuisine,
    );
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      surname: map['surname'],
      gender: map['gender'],
      bio: map['aboutme'],
      diet: Diet.values.firstWhere((e) =>
          e.toString().split('.').last.toLowerCase() ==
          map['diet'].toString().toLowerCase()),
      genderPreference: GenderPreference.values.firstWhere((e) =>
          e.toString().split('.').last.toLowerCase() ==
          map['show_me_gender'].toString().toLowerCase()),
      filePath: map['filePath'],
      cuisine: List<String>.from(map['cuisine']),
    );
  }

  static User fromSnapshot(DocumentSnapshot snap) {
    return User(
      id: snap.id,
      name: snap['name'],
      surname: snap['surname'],
      gender: snap['gender'],
      bio: snap['bio'],
      diet: Diet.values.firstWhere((e) =>
          e.toString().split('.').last.toLowerCase() ==
          snap['diet'].toString().toLowerCase()),
      genderPreference: GenderPreference.values.firstWhere((e) =>
          e.toString().split('.').last.toLowerCase() ==
          snap['genderPreference'].toString().toLowerCase()),
      filePath: snap['filePath'],
      cuisine: List<String>.from(snap['cuisine']),
    );
  }
}
