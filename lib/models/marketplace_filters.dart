class MarketplaceFilters {
  double? minRent;
  double? maxRent;
  int? minBedrooms;
  String? propertyType;
  bool? parking;
  bool? wifi;

  MarketplaceFilters({
    this.minRent,
    this.maxRent,
    this.minBedrooms,
    this.propertyType,
    this.parking,
    this.wifi,
  });

  bool get isEmpty =>
      minRent == null &&
      maxRent == null &&
      minBedrooms == null &&
      propertyType == null &&
      parking == null &&
      wifi == null;

  void reset() {
    minRent = null;
    maxRent = null;
    minBedrooms = null;
    propertyType = null;
    parking = null;
    wifi = null;
  }
}
