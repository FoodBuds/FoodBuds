import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:foodbuds0_1/models/models.dart';
import 'package:intl/intl.dart';

class User extends Equatable {
  final String? id;
  final String name;
  final String surname;

  final String gender;
  final String bio;
  final Diet diet;
  final GenderPreference genderPreference;

  const User({
    this.id,
    required this.name,
    required this.surname,
    required this.gender,
    required this.bio,
    required this.diet,
    required this.genderPreference,
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
    );
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
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      gender: gender ?? this.gender,
      bio: bio ?? this.bio,
      diet: diet ?? this.diet,
      genderPreference: genderPreference ?? this.genderPreference,
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
    );
  }
}
