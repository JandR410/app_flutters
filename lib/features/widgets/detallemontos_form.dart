import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/constants/text_strings.dart';
import '../../utils/theme/theme.dart';

class DetalleMontoFormScreen extends StatelessWidget {
  const DetalleMontoFormScreen({
    super.key,
    required this.mOC,
    required this.mTax,
    required this.mTot,
    required this.idDetMont,
  });

  final mOC;
  final mTax;
  final mTot;
  final idDetMont;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('purchase_orders')
            .where("id",
                isEqualTo: idDetMont) // Replace with your subcollection
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            children: snapshot.data!.docs.map((monto) {
              var currency = '';
              if (monto['currency'] == 'USD') {
                currency = '\$';
              } else if (monto['currency'] == 'PEN') {
                currency = "S/ ";
              } else {
                currency = 'USD';
              }

              final OC = monto['amount'];
              String montoOC =
                  (NumberFormat.currency(symbol: currency + ' ').format((OC)));
              final Tax = monto['tax_amount'];
              String montoTax =
                  (NumberFormat.currency(symbol: currency + ' ').format((Tax)));
              final Total = monto['total_amount'];
              String montoTotal = (NumberFormat.currency(symbol: currency + ' ')
                  .format((Total)));
              return Form(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Flexible(
                            child: Text(
                              tMontoOC,
                              style: pText,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              montoOC,
                              style: mText,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              tMontoImpuesto,
                              style: pText,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              montoTax,
                              style: mText,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              tMontoT,
                              style: pText,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              montoTotal,
                              style: pText,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ]),
              );
            }).toList(),
          );
        });
  }
}
