import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordencompra/features/widgets/arraydetalle_form.dart';
import 'package:ordencompra/features/widgets/detallefechas_form.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../controllers/orders_controller.dart';
import '../../models/orders_model.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/product.dart';
import '../../utils/constants/text_strings.dart';
import '../../utils/theme/theme.dart';
import 'detallemontos_form.dart';
import 'pdfviewer_form.dart';

class AdjuntosFormScreen extends StatefulWidget {
  final idDocAdj;
  final idKey;
  final idCollection;
  final ocTabBar;
  final idUser;
  const AdjuntosFormScreen(
      {super.key,
      required this.idKey,
      required this.idCollection,
      required this.ocTabBar,
      required this.idDocAdj,
      required this.idUser});
  @override
  State<AdjuntosFormScreen> createState() => _AdjuntosFormScreen();
}

class _AdjuntosFormScreen extends State<AdjuntosFormScreen> {
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
                      tAdjuntos,
                      style: pTitulo,
                    ),
                  );
                },
                body: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('purchase_orders')
                      .doc(widget.idDocAdj)
                      .collection(
                          'attachments') // Replace with your subcollection
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
                      children: snapshot.data!.docs.map((file) {
                        final title = file['title'];
                        final link = file['url'];
                        final titleBar = file['title'].toString();
                        return Container(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          decoration: BoxDecoration(color: tCardColor),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PDFViewForm(
                                        link: link,
                                        title: title,
                                        ocTabBar: widget.ocTabBar,
                                        idKey: widget.idKey,
                                        idCollection: widget.idCollection,
                                        idUser: widget.idUser)),
                              );
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: tCardFile)),
                                padding: const EdgeInsets.only(
                                    right: 15, left: 15, top: 10, bottom: 15),
                                child: Column(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Flexible(
                                            child: Container(
                                          alignment: Alignment.center,
                                          height: 70,
                                          width: 70,
                                          padding: EdgeInsets.only(right: 10),
                                          child: Image.asset(
                                            'assets/images/pdf.png',
                                          ),
                                        )),
                                        Flexible(
                                          child: Text(
                                            title,
                                            maxLines: 1,
                                            style: pText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ));
          }).toList(),
        ),
      ),
    );
  }
}
