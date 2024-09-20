class OrderModel {
  final String? amount;
  final String approval_levels;
  final String approved_at;
  final String approved_limit_at;
  final String id;
  final String issued_at;
  final String items;
  final String notes;
  final String organization_id;
  final String organization_name;
  final String payment_terms;
  final String requested_at;
  final String responsible;
  final String responsible_full_name;
  final String status;
  final String subject;
  final String supplier_document_number;
  final String supplier_document_type;
  final String supplier_id;
  final String supplier_organization_name;
  final String supplier_trade_representative;
  final String tax_amount;
  final String total_amount;

  OrderModel(
      this.amount,
      this.approval_levels,
      this.approved_at,
      this.approved_limit_at,
      this.id,
      this.issued_at,
      this.items,
      this.notes,
      this.organization_id,
      this.organization_name,
      this.payment_terms,
      this.requested_at,
      this.responsible,
      this.responsible_full_name,
      this.status,
      this.subject,
      this.supplier_document_number,
      this.supplier_document_type,
      this.supplier_id,
      this.supplier_organization_name,
      this.supplier_trade_representative,
      this.tax_amount,
      this.total_amount);
  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      map['amount'] as String,
      map['approval_levels'] as String,
      map['approved_at'] as String,
      map['approved_limit_at'] as String,
      map['id'] as String,
      map['issued_at'] as String,
      map['items'] as String,
      map['notes'] as String,
      map['organization_id'] as String,
      map['organization_name'] as String,
      map['payment_terms'] as String,
      map['requested_at'] as String,
      map['responsible'] as String,
      map['responsible_full_name'] as String,
      map['status'] as String,
      map['subject'] as String,
      map['supplier_document_number'] as String,
      map['supplier_document_type'] as String,
      map['supplier_id'] as String,
      map['supplier_organization_name'] as String,
      map['supplier_trade_representative'] as String,
      map['tax_amount'] as String,
      map['total_amount'] as String,
    );
  }
}

final defaultOrdersData = <String, dynamic>{
  'amount': 'Data not found',
  'approval_levels': 'Data not found',
  'approved_at': 'Data not found',
  'approved_limit_at': 'Data not found',
  'id': 'Data not found',
  'issued_at': 'Data not found',
  'items': 'Data not found',
  'notes': 'Data not found',
  'organization_id': 'Data not found',
  'organization_name': 'Data not found',
  'payment_terms': 'Data not found',
  'requested_at': 'Data not found',
  'responsible': 'Data not found',
  'responsible_full_name': 'Data not found',
  'status': 'Data not found',
  'subject': 'Data not found',
  'supplier_document_number': 'Data not found',
  'supplier_document_type': 'Data not found',
  'supplier_id': 'Data not found',
  'supplier_organization_name': 'Data not found',
  'supplier_trade_representative': 'Data not found',
  'tax_amount': 'Data not found',
  'total_amount': 'Data not found',
};

