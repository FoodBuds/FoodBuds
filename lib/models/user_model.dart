import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? id;
  final String name;
  final String surname;
  final String gender;
  final String bio;
  final String diet;
  final String genderPreference;
  final List<String> cuisine; 
  final String? filePath;

  const User({
    this.id,
    required this.name,
    required this.surname,
    required this.gender,
    required this.bio,
    required this.diet,
    required this.genderPreference,
    required this.cuisine, // Adjusted type
    this.filePath,
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
        cuisine, // This will handle list equality
        filePath,
      ];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'surname': surname,
      'gender': gender,
      'bio': bio,
      'diet': diet,
      'genderPreference': genderPreference,
      'cuisine': cuisine, // No change needed here, List<String> works fine
      'filePath': filePath,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? surname,
    String? gender,
    String? bio,
    String? diet,
    String? genderPreference,
    List<String>? cuisine, // Adjusted type
    String? filePath,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      gender: gender ?? this.gender,
      bio: bio ?? this.bio,
      diet: diet ?? this.diet,
      genderPreference: genderPreference ?? this.genderPreference,
      cuisine: cuisine ?? this.cuisine, // Keep existing list if not updated
      filePath: filePath ?? this.filePath,
    );
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      surname: map['surname'],
      gender: map['gender'],
      bio: map['aboutme'],
      diet: map['diet'],
      genderPreference: map['genderPreference'],
      cuisine: List<String>.from(map['cuisine']), // Ensure it's a list of strings
      filePath: map['filePath'],
    );
  }

  static User fromSnapshot(DocumentSnapshot snap) {
    return User(
      id: snap.id,
      name: snap['name'],
      surname: snap['surname'],
      gender: snap['gender'],
      bio: snap['bio'],
      diet: snap['diet'],
      genderPreference: snap['genderPreference'],
      cuisine: List<String>.from(snap['cuisine']), // Convert dynamic list to List<String>
      filePath: snap['filePath'],
    );
  }
}
