import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ordencompra/controllers/orders_controller.dart';
import 'package:ordencompra/features/screens/informacionoc_screen.dart';
import 'package:ordencompra/features/widgets/arraydetalle_form.dart';
import 'package:ordencompra/features/widgets/cardocpendientes_form.dart';
import 'package:ordencompra/models/orders_model.dart';
import 'package:ordencompra/utils/constants/text_strings.dart';
import 'package:ordencompra/utils/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repository/authentication/authentication_repository.dart';
import '../widgets/filterbuttons_form.dart';
import 'detalleoc_screen.dart';

class FilterCalendarScreen extends StatelessWidget {
  final idUser;
  final nameId;
  final startDate;
  final endDate;
  const FilterCalendarScreen({
    Key? key,
    required this.idUser,
    required this.nameId,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var docUserId;
    String? name = '';

    void getDocumentIds() async {
      final _authRepo = Get.put(AuthenticationRepository());
      final id = _authRepo.firebaseUser?.uid;
      var docUser;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('purchase_orders')
          .where("id", isEqualTo: idUser)
          .where("status", isEqualTo: "PENDING_APPROVAL")
          .get();

      List<String> documentIds = [];

      querySnapshot.docs.forEach((doc) {
        documentIds.add(doc.id);
      });

      var docIdUser =
          (documentIds.toString()).replaceAll("[", "").replaceAll("]", "");
      print(documentIds);
      docUserId = docIdUser.replaceAll("[]", "");
    }

    final controller = Get.put(OrdersController());
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('purchase_orders');
    String collectionId = collectionReference.id;
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('purchase_orders')
                .where('issued_at', isGreaterThanOrEqualTo: endDate)
                .where('issued_at', isLessThanOrEqualTo: startDate)// Replace with your subcollection
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              // if (!snapshot.hasData) {
              //   return Center(
              //     child: CircularProgressIndicator(),
              //   );
              // }
              return (snapshot.connectionState == ConnectionState.waiting)
                  ? Center(
                      // child: CircularProgressIndicator(),
                      )
                  : ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final users = snapshot.data?.docs ?? [];
                        var data = snapshot.data!.docs[index].data()
                            as Map<String, dynamic>;
                        if (data['responsible']
                        .toString()
                        .toLowerCase()
                        .contains(idUser)) {
                          final idCollection = collectionId;
                          final ocTabBar = data['id'];
                          final ocId = data['id'];
                          var currency = '';
                          final ORG = data['organization_id'];
                            final documentId = data['id'];
                        final user = users[index];
                        var dataU = user.data() as Map<String, dynamic>;
                        final metada =
                            List<String>.from(dataU['metadata'] ?? []);
                        final dataMeta = metada[1];
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
                                        builder: (context) => InformacionScreen(
                                              id: ocId,
                                              idCollection: idCollection,
                                              ocTabBar: ocTabBar,
                                              idUser: idUser,
                                              docUSer: ''
                                            )),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    color: Colors.white,
                                    child: Container(
                                      height: 200,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                              width: 5.0, color: Colors.grey),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('purchase_orders')// Replace with your subcollection
                                              .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            // if (!snapshot.hasData) {
                                            //   return Center(
                                            //     // child:
                                            //     //     CircularProgressIndicator(),
                                            //   );
                                            // }
                                            return CardocPendientesFormScreen(
                                              amount: NumberFormat.currency(
                                                      symbol: currency + ' ')
                                                  .format(
                                                      (data['total_amount'])),
                                              id: (data['id'].toString()),
                                              subject:
                                                  (data['subject'].toString()),
                                              aprovador: '', ORG: ORG,
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
            }));
  }
}
