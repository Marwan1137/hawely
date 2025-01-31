/* -------------------------------------------------------------------------- */
/*                          UserModel Class                                  */
/* -------------------------------------------------------------------------- */
class UserModel {
  final String uid; // Unique identifier for the user
  final String? email; // User's email address
  final String? firstName; // User's first name
  final String? lastName; // User's last name

  /* -------------------------------------------------------------------------- */
  /*                              Constructor                                  */
  /* -------------------------------------------------------------------------- */
  UserModel({
    required this.uid,
    this.email,
    this.firstName,
    this.lastName,
  });

  /* -------------------------------------------------------------------------- */
  /*                          CopyWith Method                                  */
  /* -------------------------------------------------------------------------- */
  UserModel copyWith({
    String? uid, // Optional new UID
    String? email, // Optional new email
    String? firstName, // Optional new first name
    String? lastName, // Optional new last name
  }) {
    return UserModel(
      uid: uid ?? this.uid, // Use existing UID if not provided
      email: email ?? this.email, // Use existing email if not provided
      firstName: firstName ??
          this.firstName, // Use existing first name if not provided
      lastName:
          lastName ?? this.lastName, // Use existing last name if not provided
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                          Factory Method for Firestore                     */
  /* -------------------------------------------------------------------------- */
  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '', // Extract UID from Firestore data
      email: data['email'] ?? '', // Extract email from Firestore data
      firstName:
          data['firstName'] ?? '', // Extract first name from Firestore data
      lastName: data['lastName'] ?? '', // Extract last name from Firestore data
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                          Convert UserModel to Map                         */
  /* -------------------------------------------------------------------------- */
  Map<String, dynamic> toMap() {
    return {
      'uid': uid, // Include UID in the map
      'email': email, // Include email in the map
      'firstName': firstName, // Include first name in the map
      'lastName': lastName, // Include last name in the map
    };
  }
}
