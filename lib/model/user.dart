class User {
  int? id;
  String name;
  String email;
  String? password;
  String phone;
  String? dateOfBirth;
  String? profilePicture;
  String? emailVerifiedAt;
  String? token;

  User({
    this.id,
    required this.name,
    required this.email,
    this.password,
    required this.phone,
    this.dateOfBirth,
    this.profilePicture,
    this.emailVerifiedAt,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      dateOfBirth: json['date_of_birth'],
      profilePicture: json['profile_picture'],
      emailVerifiedAt: json['email_verified_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'date_of_birth': dateOfBirth,
      'profile_picture': profilePicture,
      'email_verified_at': emailVerifiedAt,
    };
  }
}
