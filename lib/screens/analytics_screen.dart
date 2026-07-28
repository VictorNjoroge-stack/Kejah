import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/building_service.dart';
import '../services/unit_service.dart';
import '../services/financial_report_service.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final BuildingService buildingService = BuildingService();
  final UnitService unitService = UnitService();
  final FinancialReportService reportService = FinancialReportService();

  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Business Intelligence"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildFinancialSummaryCard(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Divider(),
            ),
            _buildBuildingStatsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialSummaryCard() {
    return FutureBuilder<Map<String, double>>(
      future: reportService.getTaxSummary(start: _startDate, end: _endDate),
      builder: (context, snapshot) {
        final data = snapshot.data ?? {'income': 0, 'expenses': 0, 'net': 0};
        final currencyFormat = NumberFormat.currency(symbol: 'KES ');

        return Card(
          margin: const EdgeInsets.all(16),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.indigo,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Financial Report", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.date_range, color: Colors.white),
                      onPressed: _selectDateRange,
                    ),
                  ],
                ),
                Text(
                  "${DateFormat('MMM d').format(_startDate)} - ${DateFormat('MMM d, yyyy').format(_endDate)}",
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 24),
                _reportRow("Total Income (Rent)", currencyFormat.format(data['income']!), Colors.greenAccent),
                const SizedBox(height: 12),
                _reportRow("Total Expenses (Maintenance)", currencyFormat.format(data['expenses']!), Colors.orangeAccent),
                const Divider(color: Colors.white24),
                _reportRow("Net Cash Flow (For Tax)", currencyFormat.format(data['net']!), Colors.white, isBold: true),
                const SizedBox(height: 16),
                const Text(
                  "* This report can be used for monthly tax returns and costing.",
                  style: TextStyle(color: Colors.white60, fontSize: 10, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _reportRow(String label, String value, Color color, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  Widget _buildBuildingStatsList() {
    return StreamBuilder(
      stream: buildingService.getBuildings(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final buildings = snapshot.data!;
        if (buildings.isEmpty) return const Center(child: Text("No buildings registered."));

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: buildings.length,
          itemBuilder: (context, index) {
            final building = buildings[index];
            return _buildBuildingCard(building);
          },
        );
      },
    );
  }

  Widget _buildBuildingCard(building) {
    return FutureBuilder(
      future: Future.wait([
        unitService.getBuildingTotalUnits(building.id),
        unitService.getBuildingOccupiedUnits(building.id),
        unitService.getBuildingRevenue(building.id),
        unitService.getBuildingOccupancyRate(building.id),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        final values = snapshot.data!;
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(building.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("${values[1]} / ${values[0]} Units Occupied • ${values[3].toStringAsFixed(1)}%"),
            trailing: Text("KES ${values[2].toStringAsFixed(0)}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }
}
