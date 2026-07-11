class Building {
  final String id;
  final String buildingCode;

  final String name;

  final String county;
  final String town;
  final String estate;
  final String address;

  final double latitude;
  final double longitude;

  final String ownerId;

  final List<String> images;

  final bool verified;

  final DateTime createdAt;
  final int totalUnits;
  final int occupiedUnits;
  final int vacantUnits;
  final double monthlyRevenue;

  Building({
    required this.id,
    required this.buildingCode,
    required this.name,
    required this.county,
    required this.town,
    required this.estate,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.ownerId,
    required this.images,
    required this.verified,
    required this.createdAt,
  });

  factory Building.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return Building(
      id: id,
      buildingCode: map['buildingCode'] ?? '',
      name: map['name'] ?? '',
      county: map['county'] ?? '',
      town: map['town'] ?? '',
      estate: map['estate'] ?? '',
      address: map['address'] ?? '',
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      ownerId: map['ownerId'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      verified: map['verified'] ?? false,
      createdAt: DateTime.tryParse(
        map['createdAt'] ?? '',
      ) ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'buildingCode': buildingCode,
      'name': name,
      'county': county,
      'town': town,
      'estate': estate,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'ownerId': ownerId,
      'images': images,
      'verified': verified,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}