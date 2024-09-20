import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ordencompra/controllers/orders_controller.dart';
import 'package:ordencompra/features/screens/dashboard_screen.dart';
import 'package:ordencompra/utils/constants/text_strings.dart';
import '../../repository/authentication/authentication_repository.dart';
import '../../utils/constants/colors.dart';
import '../../utils/theme/theme.dart';
import 'package:fl_chart/fl_chart.dart';

var ocTab;
var data;

double sumPENDING = 0;
double sumRELEASE = 0;
double sumREJECTED = 0;

int pendingSum = 0;
int releaseSum = 0;
int rejectedSum = 0;

class DetalleGraficaScreen extends StatefulWidget {
  final idKey;
  DetalleGraficaScreen({
    super.key,
    required this.idKey,
  });

  @override
  State<DetalleGraficaScreen> createState() => _DetalleGraficaScreen();
}

class _DetalleGraficaScreen extends State<DetalleGraficaScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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

  Future<void> getSubcollectionsData(String userId) async {
    try {
      CollectionReference ordersRef = _firestore.collection('dashboard').doc(widget.idKey).collection('history_pen');
      CollectionReference addressesRef = _firestore.collection('dashboard').doc(widget.idKey).collection('history_usd');

      // Obtén datos de la subcolección "history_pen"
      QuerySnapshot ordersSnapshot = await ordersRef.get();
      List<QueryDocumentSnapshot> ordersDocs = ordersSnapshot.docs;

      // Procesa los datos de "history_pen"
      ordersDocs.forEach((doc) {
        print('history_pen: ${doc.id}, Data: ${doc.data()}');
      });

      QuerySnapshot addressesSnapshot = await addressesRef.get();
      List<QueryDocumentSnapshot> addressesDocs = addressesSnapshot.docs;

      addressesDocs.forEach((doc) {
        print('history_usd: ${doc.id}, Data: ${doc.data()}');
      });
    } catch (e) {
      print('Error obteniendo datos de subcolecciones: $e');
    }
  }


  Future<void> getDataFromAllSubcollections() async {
    double dsumPENDING = 0;
    double dsumRELEASE = 0;
    double dsumREJECTED = 0;
    List<String> dataID = [];
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var data = await FirebaseFirestore.instance
        .collection('purchase_orders')
        .where("stakeholders", arrayContains: widget.idKey)
        .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in data.docs) {
      Map<String, dynamic> subDoc = doc.data();

      dataID.add(subDoc['status']);
    }

    final filteredItemsPENDING =
        dataID.where((item) => item.contains('PENDING_APPROVAL')).toList();
    final dataCounterPENDING = filteredItemsPENDING.length;
    dsumPENDING += dataCounterPENDING;

    final filteredItemsRELEASE =
        dataID.where((item) => item.contains('RELEASE')).toList();
    final dataCounterRELEASE = filteredItemsRELEASE.length;
    dsumRELEASE += dataCounterRELEASE;

    final filteredItemsREJECTED =
        dataID.where((item) => item.contains('REJECTED')).toList();
    final dataCounterREJECTED = filteredItemsREJECTED.length;
    dsumREJECTED += dataCounterREJECTED;
    sumPENDING = dsumPENDING;
    sumRELEASE = dsumRELEASE;
    sumREJECTED = dsumREJECTED;

    pendingSum = sumPENDING.toInt();
    releaseSum = sumRELEASE.toInt();
    rejectedSum = sumREJECTED.toInt();

    print('Contador $dsumREJECTED, $dsumPENDING, $dsumRELEASE and $data');
    showingSections(sumREJECTED, sumPENDING, sumRELEASE);
    fetchData();
  }

  showSnackBarCargando(context) {
    SnackBar snackBar = SnackBar(
      content: const Text(
        'Cargando información',
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

  @override
  void initState() {
    getDocumentIds();
    getSubcollectionsData(widget.idKey);
    getDataFromAllSubcollections();
    super.initState();
  }

  Future<String> fetchData() async {
    await Future.delayed(Duration(seconds: 6));
    return "Datos cargados";
  }

  @override
  void dispose() {
    super.dispose();
  }

  final controller = Get.put(OrdersController());
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

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth * 0.9;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_sharp),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DashboardScreen(
                          idUser: '',
                          nameId: '',
                          docUSer: '',
                        )),
              );
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
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('dashboard')
                .where('employee_id', isEqualTo: widget.idKey)
                .snapshots(),
            builder:
                ( context, snapshot) {
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
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              } 
              return ListView(
                shrinkWrap: true,
                children: snapshot.data!.docs.map((graf) {
                  final rejected = graf['rejected'];
                  final pending_approval = graf['pending_approval'];
                  final released = graf['released'];

              return Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 350,
                              child: Container(
                                  padding: EdgeInsets.only(left: 20, top: 20),
                                  child: tituloDashboard()),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 10, top: 10, bottom: 20),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: tCardBgColor,
                              border: Border.all(color: tBorderCard)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 200,
                                height: 250,
                                child: PieChart(
                                  PieChartData(
                                    sections: showingSections(
                                        sumREJECTED, sumPENDING, sumRELEASE),
                                    sectionsSpace: 0,
                                    centerSpaceRadius: 40,
                                  ),
                                ),
                              ),
                              Container(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          alignment: Alignment.topLeft,
                                          margin: EdgeInsets.only(right: 10),
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: gdColorAproveed)),
                                      Container(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                            Text(
                                              gTitleAprobados,
                                              style: gTitleAprobado,
                                            ),
                                            Text(
                                              '$releaseSum OCs',
                                              style: gDetalleAprobado,
                                            )
                                          ])),
                                    ],
                                  )),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                      child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(right: 10),
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: gdColorRejected)),
                                      Container(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                            Text(
                                              gTitleDesaprobado,
                                              style: gTitleRejected,
                                            ),
                                            Text(
                                              '$rejectedSum OCs',
                                              style: gDetalleDesaprobados,
                                            )
                                          ])),
                                    ],
                                  )),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                      child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(right: 10),
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: gdPending)),
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(gTitlePendiente,
                                                    style: gTitlePending),
                                                Text(
                                                  '$pendingSum OCs',
                                                  style: gDetallePendiente,
                                                )
                                              ])),
                                    ],
                                  )),
                                ],
                              )),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // Expanded(
                        //   child: Container(
                        //     margin: const EdgeInsets.only(
                        //       left: 20,
                        //       right: 20,
                        //     ),
                        //     padding: const EdgeInsets.all(10),
                        //     alignment: Alignment.centerLeft,
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(10),
                        //       color: tCardBgColor,
                        //       border: Border.all(color: tBorderCard),
                        //     ),
                        //     child: ListView.separated(
                        //       itemCount: 5,
                        //       itemBuilder: (context, index) {
                        //         var year = getSubcollectionsData('year');
                        //         var month = getSubcollectionsData('month');
                        //         return ListTile(
                        //           title: Row(
                        //             mainAxisSize: MainAxisSize.max,
                        //             mainAxisAlignment: MainAxisAlignment.start,
                        //             children: [
                        //               const SizedBox(
                        //                 width: 70,
                        //                 child: Text(
                        //                   "",
                        //                   style: tDetalle,
                        //                 ),
                        //               ),
                        //               const SizedBox(
                        //                 width: 20,
                        //               ),
                        //               Expanded(
                        //                 child: Column(
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.start,
                        //                   children: [
                        //                     Stack(
                        //                       children: [
                        //                         Container(
                        //                           width: double.infinity,
                        //                           height: 20,
                        //                           color: lightColorScheme
                        //                               .primary
                        //                               .withOpacity(0.2),
                        //                         ),
                        //                         Container(
                        //                           width:
                        //                               (Get.width - 190) * 0.8,
                        //                           height: 20,
                        //                           color:
                        //                               lightColorScheme.primary,
                        //                         )
                        //                       ],
                        //                     ),
                        //                     const SizedBox(
                        //                       height: 10,
                        //                     ),
                        //                     const Row(
                        //                       mainAxisAlignment:
                        //                           MainAxisAlignment
                        //                               .spaceBetween,
                        //                       children: [
                        //                         Text(
                        //                           'S/ 1000.00',
                        //                           style: pTitulo,
                        //                         ),
                        //                         SizedBox(
                        //                           width: 20,
                        //                         ),
                        //                         Text(
                        //                           'S/ 1000.00',
                        //                           style: pTitulo,
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         );
                        //       },
                        //       separatorBuilder: (context, index) =>
                        //           const Divider(
                        //         color: Colors.grey,
                        //         height: 1,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    );
            }).toList());
  }
));}}

Widget tituloOrdenCompra() {
  return Container(
    padding: EdgeInsets.only(
      top: 8,
    ),
    child: Stack(
      children: <Widget>[
        Text(
          tOrdenCompra,
          style: tDetalle,
        )
      ],
    ),
  );
}

List<PieChartSectionData> showingSections(
    double REJECTED, double PENDING, double RELEASE) {
  return List.generate(3, (i) {
    final isTouched = false; // Puedes cambiar esto para detectar toques
    final double fontSize = isTouched ? 25 : 16;
    final double radius = isTouched ? 60 : 40;
    switch (i) {
      case 0:
        return PieChartSectionData(
          color: gdColorAproveed,
          value: RELEASE,
          title: '',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xff00D515),
          ),
        );
      case 1:
        return PieChartSectionData(
          color: gdPending,
          value: PENDING,
          title: '',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xff0E88F3),
          ),
        );
      case 2:
        return PieChartSectionData(
          color: gdColorRejected,
          value: REJECTED,
          title: '',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffFF0000),
          ),
        );
      default:
        throw Error();
    }
  });
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

Widget tituloDashboard() {
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
                'DASHBOARD',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
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
