import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'dart:math' as math show Random;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:ordencompra/utils/constants/colors.dart';
import 'package:poapprovalsdk/api.dart';
import 'package:rounded_background_text/rounded_background_text.dart';
import '../../utils/constants/text_strings.dart';
import '../screens/dashboard_screen.dart';

class InformacionFormScreen extends StatelessWidget {
  final idCod;
  final idOC;
  final responsible;
  const InformacionFormScreen(
      {super.key,
      required this.isDark,
      required this.idCod,
      required this.idOC,
      required this.responsible});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('purchase_orders')
            .doc(idCod)
            .collection('approvers') // Replace with your subcollection
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 Text ('Sin aprobadores asignados'),
                  SizedBox(height: 20),
                ],
              ),
            );
          }
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
              child: ListView(
                shrinkWrap: true,
                children: snapshot.data!.docs.map((oc) {
                  final responsable = oc['full_name']== null
                  ? ''
                  : oc['full_name'];;
                  final idApprover = oc['approver_id'];
                  var index = "";
                  if(responsable == ""){
                    index = "";
                  } else {
                    index = responsable[0];
                  }
                  var estado;
                  final textStyle;
                  if (oc['status'] == 'PENDING_APPROVAL') {
                    estado = 'Pendiente';
                    textStyle = OutlinedButton.styleFrom(
                        side: BorderSide(width: 2.0, color: Colors.grey),
                        maximumSize: Size.fromHeight(50),
                        padding: EdgeInsets.only(right: 15, left: 15));
                  } else if (oc['status'] == 'RELEASED') {
                    estado = 'Aprobado';
                    textStyle = OutlinedButton.styleFrom(
                        side: BorderSide(width: 2.0, color: Colors.green),
                        padding: EdgeInsets.only(right: 15, left: 15));
                  } else {
                    estado = 'Rechazado';
                    textStyle = OutlinedButton.styleFrom(
                        side: BorderSide(width: 2.0, color: Colors.red),
                        padding: EdgeInsets.only(right: 13, left: 13));
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: InkWell(
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Container(
                                      alignment: Alignment.center,
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.primaries[math.Random()
                                              .nextInt(
                                                  Colors.primaries.length)]),
                                      child: Text(
                                        index,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),
                                      )))),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            width: 170,
                            alignment: Alignment.topLeft,
                            child: Text(
                              responsable,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                      new Spacer(),
                      OutlinedButton(
                        onPressed: () {
                          if (responsible != idApprover) {
                            if (estado == 'Pendiente') {
                              _dialogNotificar(context, idCod, idApprover);
                            }
                          }
                        },
                        style: textStyle,
                        child: Text(
                          estado,
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  );
                }).toList(),
              ),
            ),
          )));
        });
  }
}

Future<void> _dialogNotificar(BuildContext context, idCod, idApprover) async {
  final api = ApiClient(
      basePath: urlDev);
  final String purchaseId = '';
  IdTokenResult? tokenResult =
      await FirebaseAuth.instance.currentUser?.getIdTokenResult();
  api.addDefaultHeader('Authorization', "Bearer ${tokenResult?.token}");
  final api_notify = PurchaseOrdersApi(api);
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        title: tituloNotificacion(),
        content: Container(
          height: 80,
          child: Column(
            children: [
              Container(
                child: Text(
                  'Recuerda evitar el spam al aprobador',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontFamily: 'Lato',
                    letterSpacing: 1,
                    decorationThickness: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Container(
            width: 350,
            height: 60,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(mAprobar),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: mAprobar),
                  ))),
              child: const Text('Si, notificar',
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Lato'
                  )),
              onPressed: () async {
                Navigator.pop(context);
                showSnackBarNotifica(context);
                try {
                  final result = await
                      api_notify.notifyPurchaseOrderReview(idCod, idApprover);
                  print(result);
                } catch (e) {
                  showErrorRechazarDialog(context, e.toString());
                  print(
                      'Exception when calling PurchaseOrdersApi->notifyPurchaseOrderReview: $e\n');
                }
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 350,
            height: 60,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black),
                  ))),
              child: const Text('No, cancelar',
                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Lato')),
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
              'No se ha podido notificar al aprobador. Por favor intenta después.',
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

Widget tituloNotificacion() {
  return Container(
    child: Stack(
      alignment: AlignmentDirectional.centerStart,
      children: <Widget>[
        Text(
          '¿REENVIAR NOTIFICACIÓN?',
          style: TextStyle(
            fontSize: 28,
            color: Colors.black,
            fontFamily: 'knockout',
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Container(
          padding: EdgeInsets.only(top: 80),
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

showSnackBarNotifica(context) {
  SnackBar snackBar = SnackBar(
    content: const Text(
      'La notificacion ha sido reenviada con exito',
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
}
