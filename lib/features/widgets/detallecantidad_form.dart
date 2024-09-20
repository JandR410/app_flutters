import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordencompra/features/widgets/detallemontos_form.dart';
import 'package:ordencompra/models/orders_model.dart';
import '../../controllers/orders_controller.dart';
import '../../utils/constants/product.dart';
import '../../utils/constants/text_strings.dart';
import '../../utils/theme/theme.dart';

class DetalleCantidadFormScreen extends StatelessWidget {
  final itemsData;
  const DetalleCantidadFormScreen(
      {super.key, required this.itemsData, required this.unidad});

  final unidad;
  @override
  Widget build(BuildContext context) {
    CollectionReference items = FirebaseFirestore.instance.collection('items');
    return FutureBuilder<DocumentSnapshot>(
      future: items.doc(itemsData).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Column(
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
                          '${data['description']}',
                          style: pText,
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
                          'S/ 10,000',
                          style: pText,
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
                          'S/ 10,000',
                          style: pText,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ]);
        }
        return Text('Loading');
      }),
    );
  }
}
