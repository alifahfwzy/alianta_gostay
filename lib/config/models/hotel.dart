class Hotel {
  final String? id;
  final String name;
  final String location;
  final List<String> facilities;
  final String imageUrl;
  final double rating;
  final DateTime? createdAt;

  Hotel({
    this.id,
    required this.name,
    required this.location,
    required this.facilities,
    required this.imageUrl,
    this.rating = 0.0,
    this.createdAt,
  });

  // Convert from JSON
  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'],
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      facilities: List<String>.from(json['facilities'] ?? []),
      imageUrl: json['image_url'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'location': location,
      'facilities': facilities,
      'image_url': imageUrl,
      'rating': rating,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }
}
