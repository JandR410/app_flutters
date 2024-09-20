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
import '../widgets/cardnotanterior_form.dart';
import '../widgets/cardnotnueva_form.dart';
import '../widgets/filterbuttons_form.dart';
import 'detalleoc_screen.dart';

class AnteriorNotScreen extends StatelessWidget {
  final idUser;
  final nameId;
  final id;
  final idCollection;
  final ocTabBar;
  const AnteriorNotScreen({
    Key? key,
    required this.idUser,
    required this.nameId,required this.id,required this.idCollection,required this.ocTabBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var docUserId;
    String? name = null;

    void getDocumentIds() async {
      final _authRepo = Get.put(AuthenticationRepository());
      final id = _authRepo.firebaseUser?.uid;
      var docUser;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where("id", isEqualTo: idUser)
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
                .collection('notifications')
                .where("employee_id",
                    isEqualTo: idUser)
                .where( "status", isEqualTo: "READ") // Replace with your subcollection
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Container(
                    height: double.maxFinite,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/emptyNotificacion.png',
                          width: 254,
                          height: 210,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              }
              return (snapshot.connectionState == ConnectionState.waiting)
                  ? Center(
                      // child: CircularProgressIndicator(),
                      )
                  : ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index].data()
                            as Map<String, dynamic>;
                        name = 'READ';
                        if (name == null) {
                          final idCollection = collectionId;
                          final message = data['message'];
                          final title = data['title'];
                          final status = data['purchase_order_status'];
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
                                              id: id,
                                              idCollection: idCollection,
                                              ocTabBar: ocTabBar,
                                              idUser: idUser, docUSer: '',
                                            )),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    color: Colors.white,
                                    child: Container(
                                      height: 230,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                              width: 5.0, color: Colors.white),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('notifications')
                                              .where("employee_id",
                                                  isEqualTo:
                                                      idUser) // Replace with your subcollection
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
                                            return CardNotAnteriorFormScreen(
                                              mensaje: message,
                                              title: title,
                                              status: status,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ));
                        }
                        if (data['status']
                            .toString()
                            .contains(name.toString())) {
                          final idCollection = collectionId;
                          final message = data['message'];
                          final title = data['title'];
                          final status = data['purchase_order_status'];
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
                                              id: id,
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
                                      height: 150,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                              width: 5.0, color: Colors.white),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('notifications')
                                              .where("employee_id",
                                                  isEqualTo:
                                                      idUser) // Replace with your subcollection
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
                                            return CardNotAnteriorFormScreen(
                                              mensaje: message,
                                              title: title,
                                              status: status,
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
                    );
            })
          );
  }
}
