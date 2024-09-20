import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersModel {
  final String? approval_levels;
  final String? id;
  // final String issued_at;
  final String? items;
  final String? notes;
  final String? organization_name;
  final String? payment_terms;
  final String? responsible;
  final String? responsible_full_name;
  final String? status;
  final String? subject;
  final String? supplier_document_number;
  final String? supplier_document_type;
  final String? supplier_id;
  final String? supplier_organization_name;
  final String? supplier_trade_representative;

  OrdersModel(
      {
      required this.approval_levels,
      // required this.approved_at,
      // required this.approved_limit_at,
      required this.id,
      // required this.issued_at,
      required this.items,
      required this.notes,
      required this.organization_name,
      required this.payment_terms,
      // required this.requested_at,
      required this.responsible,
      required this.responsible_full_name,
      required this.status,
      required this.subject,
      required this.supplier_document_number,
      required this.supplier_document_type,
      required this.supplier_id,
      required this.supplier_organization_name,
      required this.supplier_trade_representative,});

  factory OrdersModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;
    return OrdersModel(
      approval_levels: data["approval_levels"].toString(),
      // approved_at: data["approved_at"],
      // approved_limit_at: data["approved_limit_at"],
      id: data["id"],
      // issued_at: data["issued_at"],
      items: data["items"].toString(),
      notes: data["notes"],
      organization_name: data["organization_name"],
      payment_terms: data["payment_terms"],
      // requested_at: data["requested_at"],
      responsible: data["responsible"],
      responsible_full_name: data["responsible_full_name"],
      status: data["status"],
      subject: data["subject"],
      supplier_document_number: data["supplier_document_number"],
      supplier_document_type: data["supplier_document_type"],
      supplier_id: data["supplier_id"],
      supplier_organization_name: data["supplier_organization_name"],
      supplier_trade_representative: data["supplier_trade_representative"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (approval_levels != null) "approval_levels": approval_levels,
      // if (approved_at != null) 'approved_at': approved_at,
      // if (approved_limit_at != null) 'approved_limit_at': approved_limit_at,
      if (id != null) "id": id,
      if (items != null) 'items': items,
      if (notes != null) 'notes': notes,
      // if (requested_at != null) 'requested_at': requested_at,
      if (responsible != null) 'responsible': responsible,
      if (status != null) 'status': status,
      if (subject != null) 'subject': subject,
      if (organization_name != null) 'organization_name': organization_name,
      if (supplier_id != null) 'supplier_id': supplier_id,
    };
  }
}
