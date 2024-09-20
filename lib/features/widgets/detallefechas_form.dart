import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/constants/text_strings.dart';
import '../../utils/theme/theme.dart';

class DetalleFechasFormScreen extends StatelessWidget {
  const DetalleFechasFormScreen({
    super.key,
    required this.fechaS,
    required this.fechaOC,
    required this.fechaAp,
    required this.termino,
    required this.responsable,
    required this.idDetFecha,
  });

  final fechaS;
  final fechaOC;
  final fechaAp;
  final termino;
  final responsable;
  final idDetFecha;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('purchase_orders')
            .where("id", isEqualTo: idDetFecha)
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
            children: snapshot.data!.docs.map((fech) {
              Timestamp fechaSo = fech['requested_at'] == null
                  ? Timestamp.now()
                  : fech['requested_at'];
              String formattedDateSo =
                  DateFormat('dd/MM/yyyy').format(fechaSo.toDate());
              // String formattedDateSo = DateFormat('dd/MM/yyyy').format(dateTimeSo).toString();

              Timestamp fechaC = fech['issued_at'] == null
                  ? Timestamp.now()
                  : fech['issued_at'];
              String formattedDateC =
                  DateFormat('dd/MM/yyyy').format(fechaC.toDate());
              // String formattedDateC = DateFormat('dd/MM/yyyy').format(dateTimeC).toString();

              Timestamp fechaA = fech['approved_at'] == null
                  ? Timestamp.now()
                  : fech['approved_at'];
              String formattedDateA =
                  DateFormat('dd/MM/yyyy').format(fechaA.toDate());
              // String formattedDateA = DateFormat('dd/MM/yyyy').format(dateTimeA).toString();
              var tPago = "";
              var responsible = "";
              final tPagoInicial = fech['payment_terms'];
              if (tPagoInicial == "Pago a 0 días a realizar el servicio") {
                tPago = "Pago inmediato";
              }
              final tResponsible = fech['responsible_full_name'];
              if (tResponsible == " ") {
                responsible = "-------";
              } else if (tResponsible == "") {
                responsible = "-------";
              } else {
                responsible = fech['responsible_full_name'];
              }
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
                              tFechaSolicitud,
                              style: pText,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              formattedDateSo,
                              style: pTextfecha,
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
                              tFechaCreacion,
                              style: pText,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              formattedDateC,
                              style: pTextfecha,
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
                              tFechaLimite,
                              style: pText,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              formattedDateA,
                              style: pTextfecha,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: Divider(
                          thickness: 1.4,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        tTerminoPago,
                        maxLines: 1,
                        style: pTitulo,
                      ),
                      Text(
                        tPago,
                        maxLines: 2,
                        style: subText,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        tResponsableOC,
                        maxLines: 1,
                        style: pTitulo,
                      ),
                      Text(
                        responsible,
                        maxLines: 2,
                        style: subText,
                      ),
                    ]),
              );
            }).toList(),
          );
        });
  }
}
