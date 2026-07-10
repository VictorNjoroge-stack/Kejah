import 'package:hive/hive.dart';

class PropertyData {
  static final Box box = Hive.box('properties');

  static List get properties => box.values.toList();

  static void addProperty(Map<String, dynamic> property) {
    box.add(property);
  }

  static void deleteProperty(int index) {
    box.deleteAt(index);
  }
}