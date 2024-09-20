import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordencompra/features/widgets/detallefechas_form.dart';
import '../../controllers/orders_controller.dart';
import '../../models/orders_model.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/product.dart';
import '../../utils/constants/text_strings.dart';
import '../../utils/theme/theme.dart';
import 'package:intl/intl.dart';
import 'detallemontos_form.dart';

class FechaFormScreen extends StatefulWidget {
  final idFecha;
  const FechaFormScreen({super.key,required this.idFecha});

  @override
  State<FechaFormScreen> createState() => _FechaFormScreen();
}

class _FechaFormScreen extends State<FechaFormScreen> {
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
                    tFechaM,
                    style: pTitulo,
                  ),
                );
              },
              body: 
              Container(
                decoration: BoxDecoration(color: tCardColor),
                padding: const EdgeInsets.all(20),
                child: FutureBuilder(
                  future: controller.getOrdersData(widget.idFecha),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        OrdersModel orderData = snapshot.data as OrdersModel;

                        // final dateSolicitud = orderData.requested_at;
                        // DateTime fechaS = DateTime.parse(dateSolicitud);
                        // final formatedSolicitud = DateFormat('dd/MM/yyyy').format(fechaS);
                        
                        // final dateOC = orderData.issued_at;
                        // DateTime fechaOC = DateTime.parse(dateOC);
                        // final formatedOC = DateFormat('dd/MM/yyyy').format(fechaOC);

                        // final dateAp = orderData.approved_at;
                        // DateTime fechaAP = DateTime.parse(dateAp);
                        // final formatedAP = DateFormat('dd/MM/yyyy').format(fechaAP);

                        final termino = orderData.payment_terms;
                        final responsable = orderData.responsible_full_name;

                        return DetalleFechasFormScreen(fechaS: '', fechaOC: '', fechaAp: '', termino: termino, responsable: responsable, idDetFecha: widget.idFecha, );
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