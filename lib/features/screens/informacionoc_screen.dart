import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ordencompra/features/screens/ordencompra_screen.dart';
import 'package:ordencompra/features/screens/signup_screen.dart';
import 'package:ordencompra/repository/authentication/authentication_repository.dart';
import 'package:ordencompra/utils/constants/colors.dart';
import 'package:poapprovalsdk/api.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';

import '../../utils/constants/text_strings.dart';
import '../../utils/theme/theme.dart';
import 'notificacion_screen.dart';

class InformacionScreen extends StatefulWidget {
  final id;
  final idCollection;
  final ocTabBar;
  final idUser;
  final docUSer;
  const InformacionScreen(
      {super.key,
      required this.id,
      required this.idCollection,
      required this.ocTabBar,
      required this.idUser,
      required this.docUSer});

  @override
  State<InformacionScreen> createState() => _InformacionScreenState();
}

class _InformacionScreenState extends State<InformacionScreen> {
  Future<String> getDocumentIds() async {
    final _authRepo = Get.put(AuthenticationRepository());
    final id = _authRepo.firebaseUser?.uid;
    var docUser = '';
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('purchase_orders')
        .doc(widget.id)
        .collection('approvers')
        .where("approver_id", isEqualTo: widget.idUser)
        .get();

    List<String> documentIds = [];

    querySnapshot.docs.forEach((doc) {
      documentIds.add(doc['status']);
    });
    var docIdUser =
        (documentIds.toString()).replaceAll("[", "").replaceAll("]", "");
    print('status $documentIds');
    docId = (documentIds.toString()).replaceAll("[", "").replaceAll("]", "");
    return docIdUser;
  }

  Future<void> _showTopModal() async {
    String _topModalData = "";
    final value = await showTopModalSheet<String?>(
      context,
      const DummyModal(),
      backgroundColor: Colors.black,
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(0),
      ),
    );

    if (value != null) setState(() => _topModalData = value);
  }

  String _data = '';

  @override
  void initState() {
    super.initState();
    getDocumentIds().then((value) {
      setState(() {
        _data = value; // Actualiza el estado con el dato obtenido
      });
    });
  }

  @override
  void dispose() {
    getDocumentIds().then((value) {
      setState(() {
        _data = value; // Actualiza el estado con el dato obtenido
      });
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _controllerAprobar = TextEditingController();
    TextEditingController _controllerRechazar = TextEditingController();
    bool sttus = false;
    if (_data == " ") {
      sttus = false;
    } else if (_data == 'PENDING_APPROVAL') {
      sttus = true;
    } else if (_data == "RELEASED") {
      sttus = false;
    } else if (_data == "REJECTED") {
      sttus = false;
    }
    return Scaffold(
      appBar: AppBar(
        leading: iconOC(),
        titleSpacing: 0,
        actions: [
          Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 1,
              ),
              child: Transform(
                transform: Matrix4.translationValues(0, 0, 0.0),
                child: IconButton(
                  icon: Image.asset(
                    'assets/images/notificacion.png',
                    width: 15.0,
                    height: 15,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              child: GestureDetector(
                onTap: () {
                  _showTopModal();
                },
                child: Image.asset(
                  'assets/images/menubar.png',
                  width: 80.0,
                  height: 50.0,
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: Column(children: [
          Flexible(
            child: OrdenCompraScreen(
                idKey: widget.id,
                idCollection: widget.idCollection,
                ocTabBar: widget.ocTabBar,
                idUser: widget.idUser,
                docUSer: widget.docUSer),
          ),
          Visibility(
            visible: sttus,
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, -3), // Posición del sombreado
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      height: 62,
                      width: 400,
                      padding: const EdgeInsets.only(right: 15, left: 15),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(mAprobar),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
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
                              context, widget.id, _controllerAprobar);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 62,
                      width: 400,
                      color: Colors.white,
                      padding: const EdgeInsets.only(right: 15, left: 15),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.report_problem_rounded,
                            color: mRechazar),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
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
                              context, widget.id, _controllerRechazar);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

Widget iconOC() {
  return Container(
    height: 30.0,
    width: 30.0,
    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
    margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
    child: Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Image.asset(
          'assets/images/icono.png',
          width: 30.0,
          height: 30.0,
        ),
      ],
    ),
  );
}

class DummyModal extends StatelessWidget {
  const DummyModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authRepo = Get.put(AuthenticationRepository());
    final id = _authRepo.firebaseUser?.uid;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user_mappings')
            .where("firebase_id", isEqualTo: id)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Center()
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    final ID = data['firebase_id'];
                    final full_name = data['full_name'];
                    final correo = data['email'];
                    print('FirebaseID $ID and $full_name');
                    return Container(
                      height: 230,
                      padding: EdgeInsets.only(
                        top: 20,
                      ),
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                child: Container(
                                  padding: EdgeInsets.only(left: 20, bottom: 5),
                                  child: Image.asset(
                                    'assets/images/icono.png',
                                    width: 30.0,
                                    height: 30.0,
                                  ),
                                ),
                              ),
                              SizedBox(
                                child: Container(
                                  padding: EdgeInsets.only(right: 20),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Image.asset(
                                      'assets/images/menubar.png',
                                      width: 80.0,
                                      height: 50.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3,
                            width: double.infinity,
                            child: const DecoratedBox(
                              decoration: const BoxDecoration(color: mAprobar),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              full_name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 24,
                                  fontFamily: 'Knockout'),
                              // textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              correo,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  fontFamily: 'Lato'),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.only(left: 0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.transparent),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(color: Colors.black),
                                  ))),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Cerrar Sesión',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Lato',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16)),
                                  SizedBox(width: 8),
                                  Image.asset(
                                    'assets/images/exit.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                ],
                              ),
                              onPressed: () async {
                                await _signOut();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpScreen()));
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  });
        });
  }
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().signOut();
}

Future<void> _dialogAprobar(
    BuildContext context, idkey, TextEditingController controller) async {
  final api = ApiClient(basePath: urlDev);
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
                    const Duration(seconds: 3)); // waiting for a second
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
                  Navigator.of(context).pop();
                  showErrorDialog(context, e.toString());
                  FirebaseCrashlytics.instance
                      .log('Error: Error al aprobar $e');
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
  final api = ApiClient(basePath: urlDev);
  final String purchaseId = '';
  IdTokenResult? tokenResult =
      await FirebaseAuth.instance.currentUser?.getIdTokenResult();
  api.addDefaultHeader('Authorization', "Bearer ${tokenResult?.token}");
  final api_disapprove = PurchaseOrdersApi(api);

  final _formKey = GlobalKey<FormState>();
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
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: controller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es obligatorio';
                      }
                      return null;
                    },
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
                    const Duration(seconds: 2)); // waiting for a second
                hideLoadingDialog(context);
                Navigator.of(context).pop();
                String textAprob = "";
                String enteredText = controller.text;
                if (_formKey.currentState?.validate() ?? false) {
                  // Si el formulario es válido, muestra un mensaje

                  showSnackBarRechazo(context);
                  final obj =
                      DisapprovePurchaseOrderCommand(reason: enteredText);
                  try {
                    final result = await api_disapprove
                        .disapprovePurchaseOrderWithHttpInfo(idkey, obj);
                    final decodeResponse = utf8.decode(result.bodyBytes);
                    print(result);
                  } catch (e) {
                    showErrorRechazarDialog(context, e.toString());
                    FirebaseCrashlytics.instance.crash();
                    print(
                        'Exception when calling PurchaseOrdersApi->approvePurchaseOrder: $e\n');
                  }
                  ;
                } else {
                  _showNoInternetDialog(context);
                  // showSnackBarSinMotivo(context);
                }
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
  // Navigator.of(context).pop();
}

showSnackBarSinMotivo(context) {
  SnackBar snackBar = SnackBar(
    content: const Text(
      'Por favor, ingresa un motivo al rechazar la OC',
      style: TextStyle(
          fontSize: 14,
          color: Colors.white,
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
  // Navigator.of(context).pop();
}

showSnackBarAprovado(context) async {
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

_showNoInternetDialog(BuildContext context) async {
  ;
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        title: tituloErrorRechazo(),
        content: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            height: 85,
            padding: EdgeInsets.only(right: 5, left: 5),
            child: Column(
              children: [
                Container(
                  width: 350,
                  child: Text(tMotivoNotFound, style: dModalInternet),
                ),
                SizedBox(
                  height: 10,
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
              style: dModalButton,
              child: const Text(tTitleButtonNotFound,
                  style: TextStyle(color: Colors.white)),
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

Widget tituloErrorRechazo() {
  return Container(
    child: Stack(
      alignment: AlignmentDirectional.centerStart,
      children: <Widget>[
        Text(
          tTitleMotivoNotFound,
          style: dTitleModal,
        ),
        SizedBox(
          height: 40,
        ),
        Container(
          padding: EdgeInsets.only(top: 60),
          child: Text(
            'IiIiIiIi',
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
