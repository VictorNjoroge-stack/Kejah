import 'package:flutter/material.dart';
import '../state/app_state.dart';

class AnalyticsScreen extends StatelessWidget {
  AnalyticsScreen({super.key});

  final AppState app = AppState.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Analytics")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _card("Buildings", app.buildings.length.toString()),
          _card("Houses", app.houses.length.toString()),
          _card("Total Rent", app.totalRentExpected().toString()),
          _card("Collected", app.totalCollected().toString()),
          _card("Arrears", app.totalArrears().toString()),
        ],
      ),
    );
  }

  Widget _card(String t, String v) {
    return Card(
      child: ListTile(
        title: Text(t),
        trailing: Text(v),
      ),
    );
  }
}