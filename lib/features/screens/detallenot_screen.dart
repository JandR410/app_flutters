import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ordencompra/controllers/orders_controller.dart';
import 'package:poapprovalsdk/api.dart';
import '../../repository/authentication/authentication_repository.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/text_strings.dart';
import 'tabsnot_form.dart';

bool _lights = false;
bool sttus = false;

class DetalleNotScreen extends StatefulWidget {
  final docUSer;
  final idUser;
  final nameId;
  const DetalleNotScreen({
    super.key,
    required this.docUSer,
    required this.idUser,
    required this.nameId,
  });

  @override
  State<DetalleNotScreen> createState() => _DetalleNotScreenState();
}

class _DetalleNotScreenState extends State<DetalleNotScreen> {
  bool userDocStatus = false;
  Future<bool> getDocumentIds() async {
    final _authRepo = Get.put(AuthenticationRepository());
    final id = _authRepo.firebaseUser?.uid;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('notifications_config')
        .where("employee_id", isEqualTo: widget.idUser)
        .get();

    List<bool> documentIds = [];

    querySnapshot.docs.forEach((doc) {
      documentIds.add(doc['status']);
    });
    List<bool> docUserCard = documentIds;
    print('detalleoc $docUserCard');
    userDocStatus = documentIds[0];
    return documentIds[0];
  }

  @override
  void initState() {
    getDocumentIds();
    super.initState();
  }

  final controller = Get.put(OrdersController());
  List<QueryDocumentSnapshot> data = [];
  final _db = FirebaseFirestore.instance;
  String approvaded = '';
  bool mostrarFiltros = false;
  @override
  Widget build(BuildContext context) {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('purchase_orders');
    String collectionId = collectionReference.id;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: false,
              automaticallyImplyLeading: false,
              title: Transform(
                transform: Matrix4.translationValues(0, 12.0, 0.0),
                child: Container(
                    padding: EdgeInsets.only(left: 10),
                    child: tituloOrdenCompra()),
              ),
            ),
            bottomSheet: SizedBox(
              height: 20,
              child: const DecoratedBox(
                decoration: const BoxDecoration(color: Colors.red),
              ),
            ),
            body: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('purchase_orders')
                    .limit(1)
                    .where("responsible_id", isEqualTo: widget.idUser)
                    .where("status",
                        isEqualTo:
                            "PENDING_APPROVAL") // Replace with your subcollection
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  bool demoStatus = false;
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/emptyNotificacion.png',
                            width: 254,
                            height: 210,
                          ),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: GestureDetector(
                              onTap: () {
                                _dialogNotificar(context, '');
                              },
                              child: SwitchListTile(
                                title: Text('Silenciar'),
                                activeColor: mAprobar,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                value: demoStatus,
                                // activeTrackColor: swColor,
                                hoverColor: Colors.white,
                                inactiveThumbColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide(
                                      color: Colors.transparent), // No border
                                ),
                                onChanged: (bool? value) async {
                                  setState(() {
                                    _dialogNotificar(context, value);
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return (snapshot.connectionState == ConnectionState.waiting)
                      ? Center(
                          // child: CircularProgressIndicator(),
                          )
                      : ListView.builder(
                          shrinkWrap: false,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final users = snapshot.data?.docs ?? [];
                            var data = snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                            final user = users[index];
                            var dataU = user.data() as Map<String, dynamic>;
                            final stakeholders =
                                List<String>.from(dataU['stakeholders'] ?? []);
                            var demo = stakeholders;
                            final idCollection = collectionId;
                            final ocTabBar = data['id'];
                            final ocId = data['id'];
                            final ORG = data['organization_id'];
                            var currency = '';
                            if (sttus == userDocStatus) {
                              demoStatus = false;
                            } else {
                              demoStatus = true;
                            }

                            if (data['currency'] == 'USD') {
                              currency = '\$';
                            } else if (data['currency'] == 'PEN') {
                              currency = "S/ ";
                            } else {
                              currency = 'USD';
                            }
                            return Container(
                                height: 670,
                                child: Column(children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  TabsNotScreen(
                                    docUSer: widget.docUSer,
                                    idUser: widget.idUser,
                                    nameId: widget.nameId,
                                    id: ocId,
                                    idCollection: idCollection,
                                    ocTabBar: ocTabBar,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: GestureDetector(
                                      onTap: () {
                                        _dialogNotificar(context, '');
                                      },
                                      child: SwitchListTile(
                                        title: Text('Silenciar'),
                                        activeColor: mAprobar,
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        value: demoStatus,
                                        // activeTrackColor: swColor,
                                        hoverColor: Colors.white,
                                        inactiveThumbColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                          side: BorderSide(
                                              color: Colors
                                                  .transparent), // No border
                                        ),
                                        onChanged: (bool? value) async {
                                          setState(() {
                                            _dialogNotificar(context, value);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ]));
                          },
                        );
                })));
  }
}

Future<void> _dialogNotificar(BuildContext context, value) async {
  final api = ApiClient(
      basePath: 'https://po-approvals-api-dev-t5mqaxgq2q-uc.a.run.app');
  final String purchaseId = '';
  IdTokenResult? tokenResult =
      await FirebaseAuth.instance.currentUser?.getIdTokenResult();
  api.addDefaultHeader('Authorization', "Bearer ${tokenResult?.token}");
  final api_instance = NotificationsApi(api);

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        title: tituloNotificacion(),
        content: Container(
          height: 73,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 0),
                child: Text(
                  '¿Estás seguro que deseas silenciar las notificaciones?',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontFamily: 'Lato',
                    letterSpacing: 0.5,
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
              child: const Text('Si, silenciar',
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.white,
                  )),
              onPressed: () async {
                showLoadingDialog(context);
                await Future.delayed(const Duration(seconds: 1));
                hideLoadingDialog(context);
                Navigator.pop(context);
                // showSnackBarAprovado(context);
                try {
                  final result =
                      await api_instance.configureNotifications(value);
                  print(result);
                } catch (e) {
                  showErrorDialog(context, e.toString());
                  print(
                      'Exception when calling NotificationsApi->configureNotifications: $e\n');
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
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
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

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Container(
          padding: EdgeInsets.all(10),
          child: Text(
              'No se ha podido actualizar la configuración en este momento. Por favor intenta después.',
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

void hideLoadingDialog(BuildContext context) {
  Navigator.of(context).pop();
}

Widget tituloNotificacion() {
  return Container(
    child: Stack(
      alignment: AlignmentDirectional.centerStart,
      children: <Widget>[
        Text(
          'SILENCIAR',
          style: TextStyle(
            fontSize: 28,
            color: Colors.black,
            fontFamily: 'knockout',
          ),
        ),
        SizedBox(
          height: 0,
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

Widget tituloOrdenCompra() {
  return Container(
    child: Stack(
      alignment: AlignmentDirectional.centerStart,
      children: <Widget>[
        Text(
          nTitulo,
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontFamily: 'knockout',
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 35),
          child: Text(
            'IiIiIiIiIiIiIi',
            style: TextStyle(
              fontSize: 5,
              color: Colors.transparent,
              fontFamily: 'knockout',
              letterSpacing: 1,
              decoration: TextDecoration.underline,
              decorationColor: Colors.green,
              decorationThickness: 30,
            ),
          ),
        ),
        // SizedBox(
        //   height: 10,
        //   width: 10,
        //   child: const DecoratedBox(
        //     decoration: const BoxDecoration(color: Colors.red),
        //   ),
        // )
      ],
    ),
  );
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
