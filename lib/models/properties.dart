class Property {
  final String id;
  final String title;
  final String location;
  final String type;
  final double price;
  final int bedrooms;
  final bool available;
  final List<String> images;

  Property({
    required this.id,
    required this.title,
    required this.location,
    required this.type,
    required this.price,
    required this.bedrooms,
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
      location: map['location'] ?? '',
      type: map['type'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      bedrooms: map['bedrooms'] ?? 0,
      available: map['available'] ?? true,
      images: List<String>.from(
        map['images'] ?? [],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'location': location,
      'type': type,
      'price': price,
      'bedrooms': bedrooms,
      'available': available,
      'images': images,
    };
  }
}