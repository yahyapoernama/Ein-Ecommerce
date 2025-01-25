class UserModel {
  final int? id; // Bisa null karena tidak ada saat register
  final String username;
  final String email;
  final String password;
  final DateTime? createdAt; // Bisa null karena tidak ada saat register

  UserModel({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.createdAt,
  });

  // Untuk mengirim data register ke API
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
    };
  }

  // Untuk menerima data user dari API
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}