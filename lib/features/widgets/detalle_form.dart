import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ordencompra/features/widgets/detallecantidad_form.dart';
import 'package:ordencompra/features/widgets/detallefechas_form.dart';
import 'package:ordencompra/features/widgets/detallemontos_form.dart';
import 'package:ordencompra/models/orders_model.dart';
import 'package:ordencompra/repository/orders_repository/orders_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/orders_controller.dart';
import '../../models/items_model.dart';
import '../../repository/orders_repository/ordersraw_repository.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/product.dart';
import '../../utils/constants/text_strings.dart';
import '../../utils/theme/theme.dart';
import 'arraydetalle_form.dart';

class DetalleFormScreen extends StatefulWidget {
  final idDocDet;
  const DetalleFormScreen({super.key, required this.idDocDet});

  @override
  State<DetalleFormScreen> createState() => _DetalleFormScreen();
}

class _DetalleFormScreen extends State<DetalleFormScreen> {
  late final bool isDark;
  late bool _customIcon = false;
  final List<Product> _products = Product.generateItems(1);
  final controller = Get.put(OrdersController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: ExpansionPanelList.radio(
          expansionCallback: (int index, bool isExpanded) {},
          children: _products.map<ExpansionPanel>((Product product) {
            return ExpansionPanelRadio(
              // isExpanded: product.isExpanded,
              value: product.id,
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return const ListTile(
                  //leading: CircleAvatar(child: Text(product.id.toString())),
                  title: Text(
                    tDetall,
                    style: pTitulo,
                  ),
                );
              },
              body: Container(
                  decoration: BoxDecoration(color: tCardColor),
                  padding: const EdgeInsets.all(20),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('purchase_orders')
                        .doc(widget.idDocDet)
                        .collection('items') // Replace with your subcollection
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        children: snapshot.data!.docs.map((detalle) {
                          final quantity = detalle['quantity'].toString();
                          final unit = detalle['unit_of_measurement'];
                          final mPrice = detalle['price'];
                          var currency = '';

                          if (detalle['currency'] == 'USD') {
                            currency = '\$';
                          } else if (detalle['currency'] == 'PEN') {
                            currency = "S/ ";
                          } else {
                            currency = 'USD';
                          }
                          String price =
                              (NumberFormat.currency(symbol: currency + ' ')
                                  .format((detalle['price'])));
                          final description = detalle['description'];
                          return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        description,
                                        maxLines: 1,
                                        style: pText,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        price,
                                        style: pText,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        quantity + ' ' + unit,
                                        style: subText,
                                      ),
                                    ),
                                  ],
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
                              ]);
                        }).toList(),
                      );
                    },
                  )),
            );
          }).toList(),
        ),
      ),
    );
  }
}
