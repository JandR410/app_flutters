import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordencompra/controllers/orders_controller.dart';
import 'package:ordencompra/features/screens/historial_screen.dart';
import 'package:ordencompra/features/screens/pendientes_screen.dart';
import 'package:ordencompra/features/widgets/filterbuttons_form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ordencompra/utils/theme/theme.dart';
import '../../models/dashboardCategoriesModel.dart';
import '../../repository/authentication/authentication_repository.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/constants/text_strings.dart';
import '../screens/tabs_form.dart';
import '../widgets/tab_item.dart';
import 'calendaroc_form.dart';

var userDocId = '';

class DetalleCalendarScreen extends StatefulWidget {
  final docUSer;
  final idUser;
  final nameId;
  final startDate;
  final endDate;
  const DetalleCalendarScreen(
      {Key? key,
      required this.docUSer,
      required this.idUser,
      required this.nameId,
      required this.startDate,
      required this.endDate})
      : super(key: key);

  @override
  State<DetalleCalendarScreen> createState() => _DetalleCalendarScreenState();
}

class _DetalleCalendarScreenState extends State<DetalleCalendarScreen> {
  void getDocumentIds() async {
    final _authRepo = Get.put(AuthenticationRepository());
    final id = _authRepo.firebaseUser?.uid;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('purchase_orders')
        .where("responsible", isEqualTo: widget.idUser)
        .get();

    List<String> documentIds = [];

    querySnapshot.docs.forEach((doc) {
      documentIds.add(doc.id);
    });
    var docUserCard =
        (documentIds.toString()).replaceAll("[", "").replaceAll("]", "");
    print('detalleoc $documentIds');
    userDocId = docUserCard.replaceAll("[]", "");
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
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            actions: [
              Padding(padding: EdgeInsets.only(top:30)),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: IconButton(
                    icon: Image.asset(
                      'assets/images/menu_oc.png',
                      width: 25,
                      height: 25,
                    ),
                    onPressed: () {
                      setState(() {
                        mostrarFiltros = !mostrarFiltros;
                      });
                    },
                  )),
            ],
            automaticallyImplyLeading: false,
            title: Transform(
              transform: Matrix4.translationValues(-30, 0.0, 10.0),
              child: tituloOrdenCompra(),
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
            SizedBox(
              height: 20,
            ),
            TabsCalendarScreen(
              docUSer: widget.docUSer,
              idUser: widget.idUser,
              nameId: widget.nameId,
              startDate: widget.startDate,
              endDate: widget.endDate,
            ),
            // TabsOCScreen(
            //   docUSer: widget.docUSer,
            //   idUser: widget.idUser,
            // )
          ])),
        ));
  }
}

Widget tituloOrdenCompra() {
  return Container(
    child: const Stack(
      alignment: AlignmentDirectional.centerStart,
      children: <Widget>[
        Text(
          tTitulo,
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontFamily: 'knockout',
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Text(
          'Ii',
          style: TextStyle(
            fontSize: 85,
            color: Colors.transparent,
            fontFamily: 'knockout',
            letterSpacing: 1,
            decoration: TextDecoration.underline,
            decorationColor: Colors.green,
            decorationThickness: 5,
          ),
        ),
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
