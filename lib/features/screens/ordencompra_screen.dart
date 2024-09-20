import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ordencompra/controllers/orders_controller.dart';
import 'package:ordencompra/features/screens/dashboard_screen.dart';
import 'package:ordencompra/features/widgets/adjuntos_form.dart';
import 'package:ordencompra/features/widgets/detalle_form.dart';
import 'package:ordencompra/features/widgets/fecha_form.dart';
import 'package:ordencompra/features/widgets/informacion_form.dart';
import 'package:ordencompra/features/widgets/montos_form.dart';
import 'package:ordencompra/models/orders_model.dart';
import 'package:ordencompra/utils/constants/text_strings.dart';
import '../../repository/authentication/authentication_repository.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/theme/theme.dart';
import '../widgets/approverreject_form.dart';
import '../widgets/proveedor_form.dart';
import '../widgets/requerimiento_form.dart';
import 'package:poapprovalsdk/api.dart';

var ocTab;
var dataID;
var docId;

class OrdenCompraScreen extends StatefulWidget {
  final idKey;
  final idCollection;
  final ocTabBar;
  final idUser;
  final docUSer;
  const OrdenCompraScreen(
      {super.key,
      required this.idKey,
      required this.idCollection,
      required this.ocTabBar,
      required this.idUser,
      required this.docUSer});

  @override
  State<OrdenCompraScreen> createState() => _OrdenCompraScreen();
}

class _OrdenCompraScreen extends State<OrdenCompraScreen> {
  TextEditingController _controller = TextEditingController();

  Future<String> getDocumentIds() async {
    final _authRepo = Get.put(AuthenticationRepository());
    final id = _authRepo.firebaseUser?.uid;
    var docUser = '';
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('purchase_orders')
        .doc(widget.idKey)
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

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  String _data = '';

  @override
  void initState() {
    super.initState();
    getDocumentIds();
    _incrementCounter();
    getDocumentIds().then((value) {
      setState(() {
        _data = value; // Actualiza el estado con el dato obtenido
      });
    });
    print("Widget iniciado");
  }

  final controller = Get.put(OrdersController());
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: tituloOrdenCompra(),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: Colors.white,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: SizedBox(
            height: 3,
            width: double.infinity,
            child: const DecoratedBox(
              decoration: const BoxDecoration(color: mAprobar),
            ),
          ),
        ),
      ),
      body: Scrollbar(
        controller: _scrollController,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('purchase_orders')
                .where("id", isEqualTo: widget.idKey)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/emptyPendiente.png',
                        width: 254,
                        height: 210,
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                );
              }
              return ListView(
                shrinkWrap: true,
                children: snapshot.data!.docs.map((prov) {
                  final currency = prov['currency'];
                  final ocTabBar = prov['id'];
                  final responsible = prov['responsible_id'];
                  bool sttus = false;
                  if (widget.idUser == '') {
                    sttus = false;
                  } else if (widget.idUser != responsible){
                    if (_data == " "){
                      sttus = false;
                    } else if (_data == 'PENDING_APPROVAL') {
                      sttus = true;
                    } else if (_data == "RELEASED") {
                      sttus = false;
                    } else if (_data == "REJECTED") {
                      sttus = false;
                    }
                  } else {
                    sttus = false;
                  }

                  ocTab = ocTabBar;
                  return SingleChildScrollView(
                      child: Container(
                    padding: const EdgeInsets.all(tDashboardPadding),
                    child: FutureBuilder(
                      future: controller.getOrdersData(widget.idKey),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            OrdersModel ordersData =
                                snapshot.data as OrdersModel;
                            if (ordersData.status == 'PENDING_APPROVAL') {
                              final status = tPendiente;
                              //Requerimiento
                              final oc = ordersData.id;
                              final empresa = ordersData.organization_name;
                              return Column(
                                children: [
                                  InformacionFormScreen(
                                    isDark: isDark,
                                    idCod: ocTabBar,
                                    idOC: widget.ocTabBar,
                                    responsible: responsible,
                                  ),
                                  RequerimientoFormScreen(
                                    isDark: isDark,
                                    ocompra: oc,
                                    empresa: empresa,
                                    estado: status,
                                    idDocReq: ocTabBar,
                                  ),
                                  ProveedorFormScreen(
                                    idProv: widget.idKey,
                                  ),
                                  MontosFormScreen(
                                    idMont: widget.idKey,
                                  ),
                                  DetalleFormScreen(
                                    idDocDet: ocTabBar,
                                  ),
                                  FechaFormScreen(
                                    idFecha: widget.idKey,
                                  ),
                                  AdjuntosFormScreen(
                                    ocTabBar: widget.ocTabBar,
                                    idKey: widget.idKey,
                                    idCollection: widget.idCollection,
                                    idDocAdj: ocTabBar,
                                    idUser: widget.idUser,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  // Visibility(
                                  //   visible: sttus,
                                  //   child: ApproverFormScreen(
                                  //     ocTabBar: widget.ocTabBar,
                                  //     idKey: widget.idKey,
                                  //     idCollection: widget.idCollection,
                                  //     idDocAdj: docUserId,
                                  //     idUser: widget.idUser,
                                  //   ),
                                  // )
                                ],
                              );
                            } else {
                              final status = tAprobado;
                              //Requerimiento
                              final oc = ordersData.id;
                              final empresa = ordersData.organization_name;
                              return Container(
                                  child: Column(
                                children: [
                                  InformacionFormScreen(
                                    isDark: isDark,
                                    idCod: docUserId,
                                    idOC: widget.ocTabBar,
                                    responsible: responsible,
                                  ),
                                  RequerimientoFormScreen(
                                    isDark: isDark,
                                    ocompra: oc,
                                    empresa: empresa,
                                    estado: status,
                                    idDocReq: ocTabBar,
                                  ),
                                  ProveedorFormScreen(
                                    idProv: widget.idKey,
                                  ),
                                  MontosFormScreen(
                                    idMont: widget.idKey,
                                  ),
                                  DetalleFormScreen(
                                    idDocDet: docUserId,
                                  ),
                                  FechaFormScreen(
                                    idFecha: ocTabBar,
                                  ),
                                  AdjuntosFormScreen(
                                    ocTabBar: widget.ocTabBar,
                                    idKey: widget.idKey,
                                    idCollection: widget.idCollection,
                                    idDocAdj: docUserId,
                                    idUser: widget.idUser,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  // Visibility(
                                  //   visible: sttus,
                                  //   child: ApproverFormScreen(
                                  //     ocTabBar: widget.ocTabBar,
                                  //     idKey: widget.idKey,
                                  //     idCollection: widget.idCollection,
                                  //     idDocAdj: docUserId,
                                  //     idUser: widget.idUser,
                                  //   ),
                                  // )
                                ],
                              ));
                            }
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(snapshot.error.toString()));
                          } else {
                            return const Center(
                                child: Text('Something went wrong'));
                          }
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ));
                }).toList(),
              );
            }),
      ),
    );
  }

  Widget tituloOrdenCompra() {
    return Container(
      padding: EdgeInsets.only(
        top: 8,
      ),
      child: Stack(
        children: <Widget>[
          Text(
            tOrdenCompra + ':  ' + widget.ocTabBar,
            style: tDetalle,
          )
        ],
      ),
    );
  }
}

Future<void> _dialogAprobar(
    BuildContext context, idkey, TextEditingController controller) async {
  final api = ApiClient(
      basePath: 'https://po-approvals-api-dev-t5mqaxgq2q-uc.a.run.app');
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
        content: Container(
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
                  readOnly: true,
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
                String enteredText = controller.text;
                final obj = ApprovePurchaseOrderCommand(reason: enteredText);
                showSnackBarAprovado(context);
                try {
                  final response =
                      api_instance.approvePurchaseOrder(idkey, obj);
                  print(response);
                } catch (e) {
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
      basePath: 'https://po-approvals-api-dev-t5mqaxgq2q-uc.a.run.app');
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
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black),
                  ))),
              child: const Text('Rechazar',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w700,
                      fontSize: 16)),
              onPressed: () async {
                showLoadingDialog(context); // show our loading dialog
                await Future.delayed(
                    const Duration(seconds: 1)); // waiting for a second
                hideLoadingDialog(context);
                Navigator.of(context).pop();
                String enteredText = controller.text;
                final obj = DisapprovePurchaseOrderCommand(reason: enteredText);
                showSnackBarRechazo(context);
                try {
                  final result = await api_disapprove
                      .disapprovePurchaseOrderWithHttpInfo(idkey, obj);
                  final decodeResponse = utf8.decode(result.bodyBytes);
                  print(result);
                } catch (e) {
                  print(
                      'Exception when calling PurchaseOrdersApi->approvePurchaseOrder: $e\n');
                }
                ;
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
    backgroundColor: mAprobar,
    dismissDirection: DismissDirection.up,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 130),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
