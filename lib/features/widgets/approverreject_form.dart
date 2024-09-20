import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordencompra/features/widgets/arraydetalle_form.dart';
import 'package:ordencompra/features/widgets/detallefechas_form.dart';
import 'package:ordencompra/repository/authentication/authentication_repository.dart';
import 'package:poapprovalsdk/api.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../controllers/orders_controller.dart';
import '../../models/orders_model.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/product.dart';
import '../../utils/constants/text_strings.dart';
import '../../utils/theme/theme.dart';
import '../screens/dashboard_screen.dart';
import 'detallemontos_form.dart';
import 'pdfviewer_form.dart';

var ocTab;
var dataID;

class ApproverFormScreen extends StatefulWidget {
  final idDocAdj;
  final idKey;
  final idCollection;
  final ocTabBar;
  final idUser;
  const ApproverFormScreen(
      {super.key,
      required this.idKey,
      required this.idCollection,
      required this.ocTabBar,
      required this.idDocAdj,
      required this.idUser});
  @override
  State<ApproverFormScreen> createState() => _ApproverFormScreen();
}

class _ApproverFormScreen extends State<ApproverFormScreen> {
  late final bool isDark;
  late bool _customIcon = false;
  final List<Product> _products = Product.generateItems(1);
  final controller = Get.put(OrdersController());
  TextEditingController _controller = TextEditingController();

  void getDocumentResponsible() async {
    final _authRepo = Get.put(AuthenticationRepository());
    final id = _authRepo.firebaseUser?.uid;
    var docUser = '';
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('user_mappings')
        .where("firebase_id", isEqualTo: id)
        .get();

    List<String> documentIds = [];

    querySnapshot.docs.forEach((doc) {
      documentIds.add(doc['approver_id']);
    });
    var docIdUser =
        (documentIds.toString()).replaceAll("[", "").replaceAll("]", "");
    print('dashboard $documentIds');
    dataID = docIdUser;
  }

  void getDocumentIds() async {
    final _authRepo = Get.put(AuthenticationRepository());
    final id = _authRepo.firebaseUser?.uid;
    var docUser;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('purchase_orders')
        .where("id", isEqualTo: widget.idKey)
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: SizedBox(
            child: Padding(
                padding: const EdgeInsets.only(right: 0, top: 0),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: tCardBgColor,
                        border: Border.all(color: tBorderCard)),
                    padding: const EdgeInsets.only(
                        left: 10, top: 10, right: 10, bottom: 10),
                    child: SizedBox(
                      height: 180,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 62,
                              width: 400,
                              padding:
                                  const EdgeInsets.only(right: 15, left: 15),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            mAprobar),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ))),
                                child: const Text(
                                  'Aprobar',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Lato',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900),
                                ),
                                onPressed: () {
                                  _dialogAprobar(
                                      context, widget.idKey, _controller);
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 62,
                              width: 400,
                              padding:
                                  const EdgeInsets.only(right: 15, left: 15),
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.report_problem_rounded,
                                    color: mRechazar),
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: mRechazar),
                                ))),
                                label: const Text(
                                  'Rechazar',
                                  style: TextStyle(
                                      color: mRechazar,
                                      fontFamily: 'Lato',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900),
                                ),
                                onPressed: () {
                                  _dialogRechazar(
                                      context, widget.idKey, _controller);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )))));
  }
}

Future<void> _dialogAprobar(
    BuildContext context, idkey, TextEditingController controller) async {
  final api = ApiClient(
      basePath: urlDev);
  final String purchaseId = '';
  IdTokenResult? tokenResult =
      await FirebaseAuth.instance.currentUser?.getIdTokenResult();
  api.addDefaultHeader('Authorization', "Bearer ${tokenResult?.token}");
  final api_instance = PurchaseOrdersApi(api);
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        title: tituloAprobar(idkey),
        content: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            height: 230,
            padding: EdgeInsets.only(right: 5, left: 5),
            child: Column(
              children: [
                Container(
                  width: 350,
                  child: Text(
                    '¿Estás seguro que deseas aprobar la orden de comprar $idkey?',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: 'Lato',
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.w400,
                      decorationThickness: 0.5,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: 350,
                  height: 30,
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Ingrese el motivo',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Roman',
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Container(
                  height: 77,
                  width: 450,
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      hintMaxLines: 2,
                      fillColor: Colors.white,
                      hintText: 'Orden de compra $idkey aprobada',
                      hintStyle: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          SizedBox(
            height: 0,
          ),
          Container(
            width: 300,
            height: 52,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(mAprobar),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: mAprobar),
                  ))),
              child: const Text('Aprobar',
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.white,
                  )),
              onPressed: () async {
                showLoadingDialog(context); // show our loading dialog
                await Future.delayed(
                    const Duration(seconds: 1)); // waiting for a second
                hideLoadingDialog(context);
                Navigator.of(context).pop();
                showSnackBarAprovado(context);
                String textAprob = "";
                String enteredText = controller.text;
                if (enteredText == "") {
                  textAprob = 'Orden de compra $idkey aprobada';
                } else {
                  textAprob = controller.text;
                }
                final obj = ApprovePurchaseOrderCommand(reason: textAprob);
                try {
                  final response =
                      await api_instance.approvePurchaseOrder(idkey, obj);
                  print(response);
                } catch (e) {
                  showErrorDialog(context, e.toString());
                  print(
                      'Exception when calling PurchaseOrdersApi->approvePurchaseOrder: $e\n');
                }
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 300,
            height: 52,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black),
                  ))),
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      );
    },
  );
}

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Container(
          padding: EdgeInsets.all(10),
          child: Text(
              'No se ha podido aprobar la orden de compra. Por favor intenta después.',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontFamily: 'Lato',
                letterSpacing: 0.1,
                fontWeight: FontWeight.w400,
                decorationThickness: 0.5,
              )),
        ),
        actions: <Widget>[
          Container(
            width: 300,
            height: 52,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black),
                  ))),
              child:
                  const Text('Cerrar', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      );
    },
  );
}

void showErrorRechazarDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Container(
          padding: EdgeInsets.all(10),
          child: Text(
              'No se ha podido rechazar la orden de compra. Por favor intenta después.',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontFamily: 'Lato',
                letterSpacing: 0.1,
                fontWeight: FontWeight.w400,
                decorationThickness: 0.5,
              )),
        ),
        actions: <Widget>[
          Container(
            width: 300,
            height: 52,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black),
                  ))),
              child:
                  const Text('Cerrar', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      );
    },
  );
}

Future<void> showLoadingDialog(
  BuildContext context,
) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

void hideLoadingDialog(BuildContext context) {
  Navigator.of(context).pop();
}

Future<void> _dialogRechazar(
    BuildContext context, idkey, TextEditingController controller) async {
  final api = ApiClient(
      basePath: urlDev);
  final String purchaseId = '';
  IdTokenResult? tokenResult =
      await FirebaseAuth.instance.currentUser?.getIdTokenResult();
  api.addDefaultHeader('Authorization', "Bearer ${tokenResult?.token}");
  final api_disapprove = PurchaseOrdersApi(api);

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.all(20.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        title: tituloRechazar(),
        content: Container(
          margin: EdgeInsets.only(right: 18.0, left: 18.0),
          height: 110,
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'Ingrese el motivo',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Roman',
                    letterSpacing: 1,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: 'Los motivos son incorrectos',
                    hintStyle: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              )
            ],
          ),
        ),
        actions: <Widget>[
          SizedBox(
            height: 0,
          ),
          Container(
            margin: EdgeInsets.only(right: 18.0, left: 18.0, bottom: 10),
            width: 340,
            height: 60,
            padding: EdgeInsets.only(top: 0, bottom: 10),
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: mRechazar),
                  ))),
              child: const Text('Rechazar',
                  style: TextStyle(
                      color: mRechazar,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w700,
                      fontSize: 16)),
              onPressed: () async {
                showLoadingDialog(context); // show our loading dialog
                await Future.delayed(
                    const Duration(seconds: 1)); // waiting for a second
                hideLoadingDialog(context);
                Navigator.of(context).pop();
                String textAprob = "";
                String enteredText = controller.text;
                if (enteredText == "") {
                  textAprob = 'Orden de compra $idkey rechazada';
                } else {
                  textAprob = controller.text;
                }
                showSnackBarRechazo(context);
                final obj = DisapprovePurchaseOrderCommand(reason: textAprob);
                try {
                  final result = await api_disapprove
                      .disapprovePurchaseOrderWithHttpInfo(idkey, obj);
                  final decodeResponse = utf8.decode(result.bodyBytes);
                  print(result);
                } catch (e) {
                  showErrorRechazarDialog(context, e.toString());
                  print(
                      'Exception when calling PurchaseOrdersApi->approvePurchaseOrder: $e\n');
                }
                ;
              },
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.only(right: 18.0, left: 18.0, bottom: 10),
            width: 340,
            height: 60,
            padding: EdgeInsets.only(top: 0, bottom: 10),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black),
                  ))),
              child: const Text('Cancelar',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w700,
                      fontSize: 16)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      );
    },
  );
}

showSnackBarRechazo(context) {
  SnackBar snackBar = SnackBar(
    content: const Text(
      'La OC ha sido rechazada',
      style: TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w900,
          fontFamily: 'Lato'),
      textAlign: TextAlign.center,
    ),
    backgroundColor: mRechazar,
    dismissDirection: DismissDirection.up,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 130),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  Navigator.of(context).pop();
}

showSnackBarAprovado(context) {
  SnackBar snackBar = SnackBar(
    content: const Text(
      'La OC ha sido aprobada',
      style: TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w900,
          fontFamily: 'Lato'),
      textAlign: TextAlign.center,
    ),
    backgroundColor: mAprobar,
    dismissDirection: DismissDirection.up,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 130),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  Navigator.of(context).pop();
}

Widget tituloAprobar(id) {
  return Container(
    child: Stack(
      alignment: AlignmentDirectional.centerStart,
      children: <Widget>[
        Text(
          'CONFIRMACIÓN',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontFamily: 'knockout',
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Container(
          padding: EdgeInsets.only(top: 30),
          child: Text(
            'IiIiIiIiIiIiIi',
            style: TextStyle(
              fontSize: 5,
              color: Colors.transparent,
              fontFamily: 'knockout',
              letterSpacing: 1,
              decoration: TextDecoration.underline,
              decorationColor: Colors.green,
              decorationThickness: 9,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget tituloRechazar() {
  return Container(
    margin: EdgeInsets.only(right: 18.0, left: 18.0),
    child: Stack(
      alignment: AlignmentDirectional.centerStart,
      children: <Widget>[
        Text(
          'RECHAZAR OC',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontFamily: 'knockout',
          ),
        ),
        SizedBox(
          height: 60,
        ),
        Container(
          padding: EdgeInsets.only(top: 30),
          child: Text(
            'IiIiIiIiIiIiIi',
            style: TextStyle(
              fontSize: 5,
              color: Colors.transparent,
              fontFamily: 'knockout',
              letterSpacing: 1,
              decoration: TextDecoration.underline,
              decorationColor: Colors.green,
              decorationThickness: 9,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget tituloError() {
  return Container(
    margin: EdgeInsets.only(right: 18.0, left: 18.0),
    child: Stack(
      alignment: AlignmentDirectional.centerStart,
      children: <Widget>[
        Text(
          'RECHAZAR OC',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontFamily: 'knockout',
          ),
        ),
        SizedBox(
          height: 60,
        ),
        Container(
          padding: EdgeInsets.only(top: 30),
          child: Text(
            'IiIiIiIiIiIiIi',
            style: TextStyle(
              fontSize: 5,
              color: Colors.transparent,
              fontFamily: 'knockout',
              letterSpacing: 1,
              decoration: TextDecoration.underline,
              decorationColor: Colors.green,
              decorationThickness: 9,
            ),
          ),
        ),
      ],
    ),
  );
}
