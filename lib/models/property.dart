class Property {
  final String id;
  final String title;
  final String description;
  final String location;
  final String type;

  final double price;
  final double deposit;

  final int bedrooms;
  final int bathrooms;

  final bool parking;
  final bool furnished;
  final bool available;

  final List<String> images;

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.type,
    required this.price,
    required this.deposit,
    required this.bedrooms,
    required this.bathrooms,
    required this.parking,
    required this.furnished,
    required this.available,
    required this.images,
  });

  factory Property.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return Property(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      type: map['type'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      deposit: (map['deposit'] ?? 0).toDouble(),
      bedrooms: map['bedrooms'] ?? 1,
      bathrooms: map['bathrooms'] ?? 1,
      parking: map['parking'] ?? false,
      furnished: map['furnished'] ?? false,
      available: map['available'] ?? true,
      images: List<String>.from(map['images'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'type': type,
      'price': price,
      'deposit': deposit,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'parking': parking,
      'furnished': furnished,
      'available': available,
      'images': images,
    };
  }
}