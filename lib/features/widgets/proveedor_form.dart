import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordencompra/features/widgets/detalleproveedor_form.dart';
import 'package:ordencompra/utils/constants/colors.dart';
import '../../controllers/orders_controller.dart';
import '../../models/orders_model.dart';
import '../../utils/constants/product.dart';
import '../../utils/constants/text_strings.dart';
import '../../utils/theme/theme.dart';

class ProveedorFormScreen extends StatefulWidget {
  final idProv;
  const ProveedorFormScreen({super.key,required this.idProv});

  @override
  State<ProveedorFormScreen> createState() => _ProveedorFormScreen();
}

class _ProveedorFormScreen extends State<ProveedorFormScreen> {
  late final bool isDark;
  final List<Product> _products = Product.generateItems(1);
  final controller = Get.put(OrdersController());
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top:20),
        child: ExpansionPanelList.radio(
          expansionCallback: (int index, bool isExpanded) {},
                dividerColor: Colors.grey,
          children: _products.map<ExpansionPanel>((Product product) {
            return ExpansionPanelRadio(
              // isExpanded: product.isExpanded,
              value: product.id,
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  //leading: CircleAvatar(child: Text(product.id.toString())),
                  title: Text(
                    product.title,
                    style: pTitulo,
                  ),
                );
              },
              body: 
              Container(
                decoration: BoxDecoration(color: tCardColor),
                padding: const EdgeInsets.all(20),
                child: FutureBuilder(
                  future: controller.getOrdersData(widget.idProv),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        OrdersModel orderData = snapshot.data as OrdersModel;

                        final ruc = orderData.supplier_document_number;
                        final rsocial = orderData.supplier_organization_name;
                        final codigo = orderData.supplier_id;
                        final representante = orderData.supplier_trade_representative;

                        return DetalleProveedorFormScreen(
                          ruc: ruc,
                          rsocial: rsocial,
                          codigo: codigo,
                          representante: representante, idDetProv: widget.idProv,
                        );
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
