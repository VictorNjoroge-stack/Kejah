class Dashboard {
  final int totalBuildings;
  final int totalUnits;
  final int occupiedUnits;
  final int vacantUnits;
  final int totalTenants;

  final double occupancyRate;

  final double totalRevenue;

  final double expectedRevenue;

  final int openMaintenance;

  const Dashboard({
    required this.totalBuildings,
    required this.totalUnits,
    required this.occupiedUnits,
    required this.vacantUnits,
    required this.totalTenants,
    required this.occupancyRate,
    required this.totalRevenue,
    required this.expectedRevenue,
    required this.openMaintenance,
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
        openMaintenance = 0;
}