class Hotel {
  final String? id;
  final String name;
  final String location;
  final String description;
  final double? rating;
  final String? imageUrl;
  final List<String> facilities;
  final int? availableRooms;
  final int? totalRooms;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Hotel({
    this.id,
    required this.name,
    required this.location,
    required this.description,
    this.rating,
    this.imageUrl,
    this.facilities = const [],
    this.availableRooms,
    this.totalRooms,
    this.createdAt,
    this.updatedAt,
  });

  // Convert from JSON (Supabase response)
  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'],
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      description: json['description'] as String? ?? 'Tidak ada deskripsi',
      rating: (json['rating'] ?? 0.0).toDouble(),
      imageUrl: json['image_url'],
      facilities:
          json['facilities'] != null
              ? List<String>.from(json['facilities'])
              : [],
      availableRooms: json['available_rooms'] ?? 0,
      totalRooms: json['total_rooms'] ?? 0,
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
      'name': name,
      'location': location,
      'description': description,
      'rating': rating,
      'image_url': imageUrl,
      'facilities': facilities,
      'available_rooms': availableRooms,
      'total_rooms': totalRooms,
    };

    // Hanya tambahkan ID jika ada (untuk update)
    if (id != null) {
      data['id'] = id;
    }

    return data;
  }

  // Method khusus untuk insert (tanpa ID)
  Map<String, dynamic> toJsonForInsert() {
    return {
      'name': name,
      'location': location,
      'description': description,
      'rating': rating,
      'image_url': imageUrl,
      'facilities': facilities,
      'available_rooms': availableRooms,
      'total_rooms': totalRooms,
    };
  }

  // Copy with method untuk update
  Hotel copyWith({
    String? id,
    String? name,
    String? location,
    String? description,
    int? pricePerNight,
    double? rating,
    String? imageUrl,
    List<String>? facilities,
    int? availableRooms,
    int? totalRooms,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Hotel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      facilities: facilities ?? this.facilities,
      availableRooms: availableRooms ?? this.availableRooms,
      totalRooms: totalRooms ?? this.totalRooms,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Hotel{id: $id, name: $name, location: $location, description: $description, rating: $rating, availableRooms: $availableRooms, totalRooms: $totalRooms}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Hotel && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
