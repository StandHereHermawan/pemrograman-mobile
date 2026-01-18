class User {
  static const String collectionName = "users";
  static const String defaultRole = "customer";
  static const String specialRole = "admin";
  final String id;
  final String username;
  final String password;
  final String createdAt;

  const User({
    this.id = "0",
    this.username = "Kosong",
    this.password = "Kosong",
    this.createdAt = "kosong",
  });

  @override
  String toString() {
    return "{id:${this.id},username:${this.username},password:${this.password},createdAt:${this.createdAt}}";
  }

  User.fromJson(Map<String, dynamic>? jsonObject)
      : this(
          id: jsonObject?['id'] as String,
          username: jsonObject?['username'] as String,
          password: jsonObject?['password'] as String,
          createdAt: jsonObject?['created_at'] as String,
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'created_at': createdAt,
    };
  }
}