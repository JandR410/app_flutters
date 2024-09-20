import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ordencompra/utils/constants/colors.dart';

import '../../utils/constants/text_strings.dart';
import '../../utils/theme/theme.dart';

class RequerimientoFormScreen extends StatelessWidget {
  const RequerimientoFormScreen({
    super.key,
    required this.isDark,
    required this.ocompra,
    required this.empresa,
    required this.estado,
    required this.idDocReq,
  });

  final bool isDark;
  final ocompra;
  final empresa;
  final estado;
  final idDocReq;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('purchase_orders')
          .where("id", isEqualTo: idDocReq)
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
          children: snapshot.data!.docs.map((req) {
            final oc = req['purchase_order_number'];
            final emp = req['organization_name'];
            final numberTotal = req['total_amount'];
            final subjectTe = req['subject'];
            final periodo = req['fiscal_year'];
            final styleText;
            var subjectT = '';
            final textH;
            if (subjectTe == "") {
              styleText = TextStyle(
                fontSize: 1,
                fontFamily: 'Lato',
                color: Colors.black,
              );
              textH = 2;
            } else if (subjectTe == " ") {
              styleText = TextStyle(
                fontSize: 1,
                fontFamily: 'Lato',
                color: Colors.black,
              );
              textH = 2;
            } else {
              subjectT = req['subject'];
              styleText = TextStyle(
                fontSize: 18,
                fontFamily: 'Lato',
                color: Colors.black,
                fontWeight: FontWeight.w700,
              );
              ;
              textH = 24;
            }
            var currency;

            if (req['currency'] == 'USD') {
              currency = '\$';
            } else if (req['currency'] == 'PEN') {
              currency = "S/ ";
            } else {
              currency = 'USD';
            }

            String mTol = (NumberFormat.currency(symbol: currency + ' ')
                .format((numberTotal)));
            var status;
            final textStyle;
            if (req['status'] == 'PENDING_APPROVAL') {
              status = 'Pendiente';
              textStyle = OutlinedButton.styleFrom(
                  side: BorderSide(width: 2.0, color: Colors.grey),
                  maximumSize: Size.fromHeight(50),
                  padding: EdgeInsets.only(right: 15, left: 15));
            } else if (req['status'] == 'RELEASED') {
              status = 'Aprobado';
              textStyle = OutlinedButton.styleFrom(
                  side: BorderSide(width: 2.0, color: Colors.green),
                  padding: EdgeInsets.only(right: 15, left: 15));
            } else {
              status = 'Rechazado';
              textStyle = OutlinedButton.styleFrom(
                  side: BorderSide(width: 2.0, color: Colors.red),
                  padding: EdgeInsets.only(right: 13, left: 13));
            }

            return SizedBox(
              height: 290,
              child: Container(
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: tCardBgColor,
                          border: Border.all(color: tBorderCard)),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              subjectT,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: styleText,
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  tOrdenCx,
                                  style: pText,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  oc,
                                  style: pText,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  tPeriodoCx,
                                  style: pText,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  periodo,
                                  style: pText,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  tEmpresa,
                                  style: pText,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  emp,
                                  style: pText,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  tEstado,
                                  style: pText,
                                ),
                              ),
                              Flexible(
                                child: OutlinedButton(
                                  onPressed: () {},
                                  style: textStyle,
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  tMontoTotal,
                                  style: pText,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  mTol,
                                  style: pText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
