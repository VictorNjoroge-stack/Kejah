class Tenant {
  final String name;
  final String phone;
  final String propertyName;
  final int rent;

  Tenant({
    required this.name,
    required this.phone,
    required this.propertyName,
    required this.rent,
  });

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "phone": phone,
      "propertyName": propertyName,
      "rent": rent,
    };
  }

  static Tenant fromMap(Map data) {
    return Tenant(
      name: data["name"],
      phone: data["phone"],
      propertyName: data["propertyName"],
      rent: data["rent"],
    );
  }
}