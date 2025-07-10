class Hotel {
  final String? id;
  final String name;
  final String location;
  final List<String> facilities;
  final String imageUrl;
  final double rating;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Hotel({
    this.id,
    required this.name,
    required this.location,
    required this.facilities,
    required this.imageUrl,
    this.rating = 0.0,
    this.createdAt,
    this.updatedAt,
  });

  // Convert from JSON (Supabase response)
  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'],
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      facilities: List<String>.from(json['facilities'] ?? []),
      imageUrl:
          json['image_url'] ??
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400',
      rating: (json['rating'] ?? 0.0).toDouble(),
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
      'facilities': facilities,
      'image_url': imageUrl,
      'rating': rating,
    };

    // Hanya tambahkan ID jika ada (untuk update)
    if (id != null) {
      data['id'] = id;
    }

    return data;
  }

  // Copy with method untuk update
  Hotel copyWith({
    String? id,
    String? name,
    String? location,
    List<String>? facilities,
    String? imageUrl,
    double? rating,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Hotel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      facilities: facilities ?? this.facilities,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Hotel{id: $id, name: $name, location: $location, facilities: $facilities, rating: $rating}';
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
