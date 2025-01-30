class UserModel {
  final String uid;
  final String? email;
  final String? firstName;
  final String? lastName;

  UserModel({
    required this.uid,
    this.email,
    this.firstName,
    this.lastName,
  });

  UserModel copyWith({
    String? uid,
    String? email,
    String? firstName,
    String? lastName,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
