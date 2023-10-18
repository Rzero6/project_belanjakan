class User {
  final int? id;
  final String? username;
  final String? password;
  final String? email;
  final String? dateOfBirth;
  final String? phone;
  final String? profilePic;
  User({
    this.id,
    this.username,
    this.password,
    this.dateOfBirth,
    this.email,
    this.phone,
    this.profilePic,
  });

  @override
  String toString() {
    return 'User{name: $username, password: $password}';
  }
}
