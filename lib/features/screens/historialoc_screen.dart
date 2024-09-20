import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ordencompra/controllers/orders_controller.dart';
import 'package:ordencompra/features/screens/informacionoc_screen.dart';
import 'package:ordencompra/features/widgets/cardocpendientes_form.dart';
import 'package:ordencompra/models/orders_model.dart';
import 'package:ordencompra/utils/constants/text_strings.dart';
import 'package:ordencompra/utils/theme/theme.dart';

import '../../repository/authentication/authentication_repository.dart';
import '../../utils/constants/colors.dart';
import '../widgets/cardochistorial_screen.dart';
import 'informacionoch_screen.dart';

class HistorialOCScreen extends StatefulWidget {
  final idUser;
  final nameId;
  final docUSer;
  const HistorialOCScreen({
    Key? key,
    required this.idUser,
    required this.nameId,
    required this.docUSer,
  }) : super(key: key);

  get idKey => '';

  @override
  State<HistorialOCScreen> createState() => _HistorialOCScreenState();
}

class _HistorialOCScreenState extends State<HistorialOCScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ScrollController _scrollController = ScrollController();
    var docUserId;
    String? name = null;

    final controller = Get.put(OrdersController());
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('purchase_orders');
    String collectionId = collectionReference.id;
    return Scaffold(
        body: Scrollbar(
      controller: _scrollController,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('purchase_orders')
              .where("stakeholders", arrayContains: widget.idUser)
              .where("status", whereIn: ["RELEASED", "REJECTED"])
              // .where("status", isEqualTo: "REJECTED")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/emptyHistorial.png',
                      width: 254,
                      height: 210,
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              );
            }
            return (snapshot.connectionState == ConnectionState.waiting)
                ? Center(
                    // child: CircularProgressIndicator(),
                    )
                : ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      final users = snapshot.data?.docs ?? [];
                      var data = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;
                      final user = users[index];
                      var dataU = user.data() as Map<String, dynamic>;
                      final stakeholders =
                          List<String>.from(dataU['stakeholders'] ?? []);
                      Timestamp fechaC = data['issued_at'] == null
                          ? Timestamp.now()
                          : data['issued_at'];
                      String dataMeta =
                          DateFormat('dd/MM/yyyy').format(fechaC.toDate());
                      // final dataMeta = metada[1];
                      name = widget.nameId;
                      var colorCard;
                      var color;
                      if (data['status'] == 'RELEASED') {
                        colorCard = BoxDecoration(
                          border: Border(
                            left: BorderSide(width: 5.0, color: cColorReleased),
                          ),
                        );
                        color = cColorReleased;
                      } else if (data['status'] == 'REJECTED') {
                        colorCard = BoxDecoration(
                          border: Border(
                            left: BorderSide(width: 5.0, color: cColorRejected),
                          ),
                        );
                        color = cColorRejected;
                      }
                      if (stakeholders.toString().contains(widget.idUser)) {
                        final idCollection = collectionId;
                        final ocTabBar = data['purchase_order_number'];
                        final ocId = data['purchase_order_number'];
                        final documentId = data['id'];
                            final ocNumber = data['id'];
                        final ORG = data['organization_id'];
                        var currency = '';
                        if (data['currency'] == 'USD') {
                          currency = '\$';
                        } else if (data['currency'] == 'PEN') {
                          currency = "S/ ";
                        } else {
                          currency = 'USD';
                        }
                        return Card(
                            color: Colors.white,
                            margin: const EdgeInsets.only(
                                right: 20, left: 20, top: 10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => InformacionHScreen(
                                          id: documentId,
                                          idCollection: idCollection,
                                          ocTabBar: ocTabBar,
                                          idUser: widget.idUser,
                                          docUSer: widget.docUSer,
                                          statusA: '')),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  height: 220,
                                  color: Colors.white,
                                  child: Container(
                                    height: 220,
                                    decoration: colorCard,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0,
                                          right: 20,
                                          left: 20,
                                          bottom: 20),
                                      child: StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('purchase_orders') // Replace with your subcollection
                                            .snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshot) {
                                          var subject = "";
                                          var tSubject =
                                              (data['subject'].toString());
                                          if (tSubject == " ") {
                                            subject = "-------";
                                          } else if (tSubject == "") {
                                            subject = "-------";
                                          } else {
                                            subject =
                                                (data['subject'].toString());
                                          }
                                          return CardocPendientesFormScreen(
                                            amount: NumberFormat.currency(
                                                    symbol: currency + ' ')
                                                .format((data['total_amount'])),
                                            id: (data['purchase_order_number']
                                                .toString()),
                                            subject: subject,
                                            aprovador: '',
                                            ORG: ORG,
                                            dataArriedAt: dataMeta,
                                            documentId: documentId,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ));
                      }
                      if (data['supplier_document_number']
                          .toString()
                          .contains(name!.toLowerCase())) {
                        final idCollection = collectionId;
                        final ocTabBar = data['purchase_order_number'];
                        final ocId = data['purchase_order_number'];
                        final documentId = data['id'];
                        var currency = '';
                        final ORG = data['organization_id'];
                        if (data['currency'] == 'USD') {
                          currency = '\$';
                        } else if (data['currency'] == 'PEN') {
                          currency = "S/ ";
                        } else {
                          currency = 'USD';
                        }
                        return Card(
                            color: Colors.white,
                            margin: const EdgeInsets.only(
                                right: 20, left: 20, top: 10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => InformacionHScreen(
                                          id: ocId,
                                          idCollection: idCollection,
                                          ocTabBar: ocTabBar,
                                          idUser: widget.idUser,
                                          docUSer: '',
                                          statusA: '')),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  height: 220,
                                  color: Colors.white,
                                  child: Container(
                                    height: 220,
                                    decoration: colorCard,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0,
                                          right: 20,
                                          left: 20,
                                          bottom: 20),
                                      child: StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('purchase_orders')// Replace with your subcollection
                                            .snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshot) {
                                          var subject = "";
                                          var tSubject =
                                              (data['subject'].toString());
                                          if (tSubject == " ") {
                                            subject = "-------";
                                          } else if (tSubject == "") {
                                            subject = "-------";
                                          } else {
                                            subject =
                                                (data['subject'].toString());
                                          }
                                          return CardocPendientesFormScreen(
                                            amount: NumberFormat.currency(
                                                    symbol: currency + ' ')
                                                .format((data['total_amount'])),
                                            id: (data['purchase_order_number']
                                                .toString()),
                                            subject: subject,
                                            aprovador: '',
                                            ORG: ORG,
                                            dataArriedAt: dataMeta,
                                            documentId: documentId,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ));
                      }
                    },
                    // children: snapshot.data!.docs.map((doc) {

                    // }).toList(),
                  );
          }),
    ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
