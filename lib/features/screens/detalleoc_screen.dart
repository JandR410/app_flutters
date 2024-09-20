import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ordencompra/controllers/orders_controller.dart';
import 'package:ordencompra/features/widgets/filterbuttons_form.dart';
import 'package:ordencompra/repository/authentication/authentication_repository.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/constants/text_strings.dart';
import 'graficas_screen.dart';
import 'tabs_form.dart';

var userDocId = '';
var dataApprover = '';
var docUserId = '';
var docUrId = '';
bool sttus = false;

class DetalleOCScreen extends StatefulWidget {
  final docUSer;
  final idUser;
  final nameId;
  const DetalleOCScreen(
      {Key? key,
      required this.docUSer,
      required this.idUser,
      required this.nameId})
      : super(key: key);

  @override
  State<DetalleOCScreen> createState() => _DetalleOCScreenState();
}

class _DetalleOCScreenState extends State<DetalleOCScreen> {
  

  Future <void> getDocumentApprovers() async {
    final _authRepo = Get.put(AuthenticationRepository());
    final id = _authRepo.firebaseUser?.uid;
    var docUser = '';
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('purchase_orders')
        .get();

    List<String> documentIds = [];

    querySnapshot.docs.forEach((doc) {
      documentIds.add(doc['responsible_id']);
    });
    var docIdUser =
        (documentIds.toString()).replaceAll("[", "").replaceAll("]", "");
    print('responsable $documentIds');
    docUrId = docIdUser;
  }

  void getDocumentIds() async {
    final _authRepo = Get.put(AuthenticationRepository());
    final id = _authRepo.firebaseUser?.uid;
    var docUser = '';
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('user_mappings')
        .where("firebase_id", isEqualTo: id)
        .get();

    List<String> documentIds = [];

    querySnapshot.docs.forEach((doc) {
      documentIds.add(doc.id);
    });
    var docIdUser =
        (documentIds.toString()).replaceAll("[", "").replaceAll("]", "");
    print('dashboard $documentIds');
    docUserId = docIdUser;
  }

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<String> fetchData() async {
    await Future.delayed(Duration(seconds: 6));
    return "Datos cargados";
  }

  @override
  void initState() {
    getDocumentIds();
    getDocumentApprovers();
    selectStatus();
    super.initState();
  }

 Future <void> selectStatus() async {
    if (widget.idUser != docUrId) {
      sttus = true;
    } else {
      sttus = false;
    }
  }

  final controller = Get.put(OrdersController());
  List<QueryDocumentSnapshot> data = [];
  final _db = FirebaseFirestore.instance;
  String approvaded = '';
  bool mostrarFiltros = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: false,
            actions: [
              Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Transform(
                    transform: Matrix4.translationValues(0, -3, 0.0),
                    child: IconButton(
                      icon: Image.asset(
                        iMenuOC,
                        width: 25,
                        height: 25,
                      ),
                      onPressed: () {
                        setState(() {
                          mostrarFiltros = !mostrarFiltros;
                        });
                      },
                    ),
                  )),
            ],
            automaticallyImplyLeading: false,
            title: Transform(
              transform: Matrix4.translationValues(0, 12.0, 0.0),
              child: Container(
                  padding: EdgeInsets.only(
                    left: 10,
                  ),
                  child: tituloOrdenCompra()),
            ),
          ),
          body: Container(
              child: Column(children: [
            Visibility(
                visible: mostrarFiltros,
                child: Container(
                  padding: const EdgeInsets.all(tDashboardPadding),
                  child: FilterButtonScreen(idFilterUser: widget.idUser),
                )),
            Visibility(
                visible: sttus,
                child: Container(
                  width: 400,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
                  child: GraficasScreen(idFilterUser: widget.idUser),
                )),
            SizedBox(
              height: 20,
            ),
            TabsOCScreen(
              docUSer: widget.docUSer,
              idUser: widget.idUser,
              nameId: widget.nameId,
            ),
          ])),
        ));
  }
}

Widget tituloOrdenCompra() {
  return Container(
    child: const Stack(
      alignment: AlignmentDirectional.centerStart,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.cover,
              child: Text(
                tTitulo,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontFamily: 'knockout',
                ),
              ),
            ),
            SizedBox(
              height: 30,
              child: Text(
                'INICIASESI',
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 10.0,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.green,
                  decorationThickness: 11,
                  fontFamily: 'knockout',
                  color: Colors.white,
                ),
              ),
            ),
          ],
        )
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
          iIconDashboard,
          width: 30.0,
          height: 30.0,
        ),
      ],
    ),
  );
}
