import 'package:hive/hive.dart';

class TenantData {
  static final Box box = Hive.box('tenants');

  static List get tenants => box.values.toList();

  static void addTenant(Map<String, dynamic> tenant) {
    box.add(tenant);
  }

  static void deleteTenant(int index) {
    box.deleteAt(index);
  }
}