import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ordencompra/utils/constants/colors.dart';

import '../../utils/constants/text_strings.dart';
import '../../utils/theme/theme.dart';

class DetalleProveedorFormScreen extends StatelessWidget {
  const DetalleProveedorFormScreen({
    super.key,
    required this.ruc,
    required this.rsocial,
    required this.codigo,
    required this.representante,
    required this.idDetProv,
  });

  final ruc;
  final rsocial;
  final codigo;
  final representante;
  final idDetProv;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('purchase_orders')
            .where("id", isEqualTo: idDetProv)
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
            children: snapshot.data!.docs.map((prov) {
              var rep = "";
              final rucNumber = prov['supplier_document_number'];
              final rSocial = prov['supplier_organization_name'];
              final cod = prov['supplier_id'];
              final tRep = prov['supplier_trade_representative'];
              if (tRep == " ") {
                rep = "-------";
              } else if (tRep == "") {
                rep = "-------";
              } else {
                rep = prov['supplier_trade_representative'];
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    tRuc,
                    style: pTitulo,
                  ),
                  Text(
                    rucNumber + ' - ' + rSocial,
                    maxLines: 1,
                    style: subText,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    tCodigo,
                    maxLines: 1,
                    style: pTitulo,
                  ),
                  Text(
                    cod,
                    maxLines: 2,
                    style: subText,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    tRepresentante,
                    maxLines: 1,
                    style: pTitulo,
                  ),
                  Text(
                    rep,
                    maxLines: 2,
                    style: subText,
                  ),
                ],
              );
            }).toList(),
          );
        });
  }
}
