import 'package:cloud_firestore/cloud_firestore.dart';

class ItemsModel {
  final String description;
  final String id_item;
  final String price;
  final String quantity;
  final String type;
  final String unit_of_measurement;
  final String total_amount;

  ItemsModel(
      {required this.description, 
      required this.id_item, 
      required this.price, 
      required this.quantity, 
      required this.type, 
      required this.unit_of_measurement,
      required this.total_amount});

  factory ItemsModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    //  if(document.data() == null || document.data()!.isEmpty) return OrdersModel.empty();
    final data = document.data()!;
    return ItemsModel(
      description: data["description"], 
      id_item: data["id_item"], 
      price: data["price"], 
      quantity: data["quantity"], 
      type: data["type"], 
      unit_of_measurement: data["unit_of_measurement"], 
      total_amount: data["total_amount"], 
    );
  }
}
