class User {
  final int id;
  final String username;
  final String? email;
  final String? fullName;
  final String? avatarUrl;

  User({
    required this.id,
    required this.username,
    this.email,
    this.fullName,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'],
      fullName: json['fullName'],
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'fullName': fullName,
      'avatarUrl': avatarUrl,
    };
  }
}