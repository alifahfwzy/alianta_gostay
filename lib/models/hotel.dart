class Hotel {
  final String? id;
  final String name;
  final String location;
  final String description;
  final double? rating;
  final String? imageUrl;
  final List<String> facilities;
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
    this.createdAt,
    this.updatedAt,
  });

  // Convert from JSON (Supabase response)
  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'],
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      description:
          json['description'] as String? ??
          'Hotel yang nyaman dengan fasilitas lengkap',
      rating: (json['rating'] ?? 0.0).toDouble(),
      imageUrl:
          json['image_url'] ??
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400',
      facilities:
          json['facilities'] != null
              ? List<String>.from(json['facilities'])
              : [],
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
    return {
      if (id != null) 'id': id,
      'name': name,
      'location': location,
      'description': description,
      'rating': rating ?? 0.0,
      'image_url':
          imageUrl ??
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400',
      'facilities': facilities,
    };
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
    };
  }

  // Copy with method untuk update
  Hotel copyWith({
    String? id,
    String? name,
    String? location,
    String? description,
    double? rating,
    String? imageUrl,
    List<String>? facilities,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Hotel{id: $id, name: $name, location: $location, description: $description, rating: $rating, facilities: $facilities}';
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
