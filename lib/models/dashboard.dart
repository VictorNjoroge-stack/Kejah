class Dashboard {
  final int totalBuildings;
  final int totalUnits;
  final int occupiedUnits;
  final int vacantUnits;
  final int totalTenants;

  final double occupancyRate;

  final double totalRevenue;

  final double expectedRevenue;

  final double collectionRate;

  final int openMaintenance;

  /// Monthly revenue for the analytics chart.
  /// Oldest month → newest month.
  final List<double> monthlyRevenue;

  const Dashboard({
    required this.totalBuildings,
    required this.totalUnits,
    required this.occupiedUnits,
    required this.vacantUnits,
    required this.totalTenants,
    required this.occupancyRate,
    required this.totalRevenue,
    required this.expectedRevenue,
    required this.collectionRate,
    required this.openMaintenance,
    required this.monthlyRevenue,
  });

  Dashboard.empty()
      : totalBuildings = 0,
        totalUnits = 0,
        occupiedUnits = 0,
        vacantUnits = 0,
        totalTenants = 0,
        occupancyRate = 0,
        totalRevenue = 0,
        expectedRevenue = 0,
        collectionRate = 0,
        openMaintenance = 0,
        monthlyRevenue = const [
          0,
          0,
          0,
          0,
          0,
          0,
        ];

  Dashboard copyWith({
    int? totalBuildings,
    int? totalUnits,
    int? occupiedUnits,
    int? vacantUnits,
    int? totalTenants,
    double? occupancyRate,
    double? totalRevenue,
    double? expectedRevenue,
    double? collectionRate,
    int? openMaintenance,
    List<double>? monthlyRevenue,
  }) {
    return Dashboard(
      totalBuildings: totalBuildings ?? this.totalBuildings,
      totalUnits: totalUnits ?? this.totalUnits,
      occupiedUnits: occupiedUnits ?? this.occupiedUnits,
      vacantUnits: vacantUnits ?? this.vacantUnits,
      totalTenants: totalTenants ?? this.totalTenants,
      occupancyRate: occupancyRate ?? this.occupancyRate,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      expectedRevenue: expectedRevenue ?? this.expectedRevenue,
      collectionRate: collectionRate ?? this.collectionRate,
      openMaintenance: openMaintenance ?? this.openMaintenance,
      monthlyRevenue: monthlyRevenue ?? this.monthlyRevenue,
    );
  }
}