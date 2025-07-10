class User {
  final String? id;
  final String email;
  final String password;
  final String username;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    required this.email,
    required this.password,
    required this.username,
    this.createdAt,
    this.updatedAt,
  });

  // Convert from JSON (Supabase response)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      username: json['username'] ?? '',
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null,
    );
  }

  // Convert to JSON (untuk insert/update ke Supabase)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
      'username': username,
    };

    // Hanya tambahkan ID jika ada (untuk update)
    if (id != null) {
      data['id'] = id;
    }

    return data;
  }

  // Convert to JSON tanpa password (untuk response ke UI)
  Map<String, dynamic> toJsonSafe() {
    final Map<String, dynamic> data = {
      'id': id,
      'email': email,
      'username': username,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };

    return data;
  }

  // Copy with method untuk update
  User copyWith({
    String? id,
    String? email,
    String? password,
    String? username,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      username: username ?? this.username,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, email: $email, username: $username}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
