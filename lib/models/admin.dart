class Admin {
  final String id;
  final String username;
  final String password;
  final String email;
  final String name; // Ganti dari 'fullName' ke 'name'
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  Admin({
    required this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '', // Match dengan kolom database
      role: json['role'] ?? 'admin',
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'email': email,
      'name': name, // Match dengan kolom database
      'role': role,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toJsonSafe() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'name': name,
      'role': role,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
