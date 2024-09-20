import 'package:cloud_firestore/cloud_firestore.dart';

class ApprovalModel {
  final String approver_id;
  final String approver_release_code;
  final String email;
  final String full_name;
  final String is_level_approver;
  final String level;
  final String notes;
  final String purchase_order_id;
  final String release_at;
  final String release_indicator;

  ApprovalModel(
      {required this.approver_id, 
      required this.approver_release_code, 
      required this.email, 
      required this.full_name, 
      required this.is_level_approver, 
      required this.level,
      required this.notes,
      required this.purchase_order_id,
      required this.release_at,
      required this.release_indicator});

  factory ApprovalModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    //  if(document.data() == null || document.data()!.isEmpty) return OrdersModel.empty();
    final data = document.data()!;
    return ApprovalModel(
      approver_id: data["approver_id"], 
      approver_release_code: data["approver_release_code"], 
      email: data["email"], 
      full_name: data["full_name"], 
      is_level_approver: data["is_level_approver"], 
      level: data["level"], 
      notes: data["notes"], 
      purchase_order_id: data["purchase_order_id"], 
      release_at: data["release_at"], 
      release_indicator: data["release_indicator"], 
    );
  }
}
