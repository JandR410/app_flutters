import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/orders_controller.dart';
import '../../models/orders_model.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/product.dart';
import '../../utils/constants/text_strings.dart';
import '../../utils/theme/theme.dart';
import 'detallemontos_form.dart';

class MontosFormScreen extends StatefulWidget {
  final idMont;
  const MontosFormScreen({super.key,required this.idMont});

  @override
  State<MontosFormScreen> createState() => _MontosFormScreen();
}

class _MontosFormScreen extends State<MontosFormScreen> {
  late final bool isDark;
  late bool _customIcon = false;
  final List<Product> _products = Product.generateItems(1);
  final controller = Get.put(OrdersController());
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top:20),
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
                    tMontos,
                    style: pTitulo,
                  ),
                );
              },
              body: 
              Container(
                decoration: BoxDecoration(color: tCardColor),
                padding: const EdgeInsets.all(20),
                child: FutureBuilder(
                  future: controller.getOrdersData(widget.idMont),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        OrdersModel orderData = snapshot.data as OrdersModel;

                        // final mOC = orderData.amount;
                        // final mTax = orderData.tax_amount;
                        // final mTot = orderData.total_amount;

                        return DetalleMontoFormScreen( mOC: '',mTax: '', mTot: '', idDetMont: widget.idMont,);
                      } else if (snapshot.error != null) {
                        return Center(child: Text(snapshot.error.toString()));
                      } else {
                        return const Center(
                            child: Text('Something went wrong'));
                      }
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}