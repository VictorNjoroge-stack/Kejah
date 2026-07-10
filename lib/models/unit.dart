class Unit {
  final String id;
  final String buildingId;

  final String unitNumber;
  final String unitType;

  final int bedrooms;
  final int bathrooms;

  final double rent;
  final double deposit;

  final bool occupied;
  final bool furnished;
  final bool parking;

  final String status;

  final String? tenantId;

  final List<String> images;

  Unit({
    required this.id,
    required this.buildingId,
    required this.unitNumber,
    required this.unitType,
    required this.bedrooms,
    required this.bathrooms,
    required this.rent,
    required this.deposit,
    required this.occupied,
    required this.furnished,
    required this.parking,
    required this.status,
    required this.images,
    this.tenantId,
  });

  factory Unit.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return Unit(
      id: id,
      buildingId: map['buildingId'] ?? '',

      unitNumber: map['unitNumber'] ?? '',
      unitType: map['unitType'] ?? '',

      bedrooms: map['bedrooms'] ?? 0,
      bathrooms: map['bathrooms'] ?? 0,

      rent: (map['rent'] ?? 0).toDouble(),
      deposit: (map['deposit'] ?? 0).toDouble(),

      occupied: map['occupied'] ?? false,

      furnished: map['furnished'] ?? false,

      parking: map['parking'] ?? false,

      status: map['status'] ?? 'Vacant',

      tenantId: map['tenantId'],

      images: List<String>.from(
        map['images'] ?? [],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'buildingId': buildingId,

      'unitNumber': unitNumber,
      'unitType': unitType,

      'bedrooms': bedrooms,
      'bathrooms': bathrooms,

      'rent': rent,
      'deposit': deposit,

      'occupied': occupied,

      'furnished': furnished,

      'parking': parking,

      'status': status,

      'tenantId': tenantId,

      'images': images,
    };
  }
}