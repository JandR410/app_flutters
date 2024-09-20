import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordencompra/controllers/orders_controller.dart';
import 'package:ordencompra/features/screens/historial_screen.dart';
import 'package:ordencompra/features/screens/pendientes_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ordencompra/utils/theme/theme.dart';
import '../../repository/authentication/authentication_repository.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/text_strings.dart';
import '../widgets/tab_item.dart';
import 'anteriornot_screen.dart';
import 'historialoc_screen.dart';
import 'nuevasnot_screen.dart';
var userDocId='';
class TabsNotScreen extends StatefulWidget {
  final docUSer;
  final idUser;
  final nameId;
  final id;
  final idCollection;
  final ocTabBar;
  const TabsNotScreen({Key? key,required this.docUSer, required this.idUser, required  this.nameId,required this.id,required this.idCollection,required this.ocTabBar}): super(key: key);

  @override
  State<TabsNotScreen> createState() => _TabsNotScreenState();
}

class _TabsNotScreenState extends State<TabsNotScreen> {
    
  void getDocumentIds() async {
    final _authRepo = Get.put(AuthenticationRepository());
    final id = _authRepo.firebaseUser?.uid;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('purchase_orders')
        .where("id", isEqualTo: widget.idUser)
        .get();

    List<String> documentIds = [];

    querySnapshot.docs.forEach((doc) {
      documentIds.add(doc.id);
    });
    var docUserCard = (documentIds.toString()).replaceAll("[", "").replaceAll("]", "");
    print(documentIds);
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Expanded(
        child: Scaffold(
          appBar: 
             PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(90)),
                    color: tCardColor,
                  ),
                  child: const TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(90)),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black54,
                    tabs: [
                      TabItem(title: nNuevas, style: tTabPendientes),
                      TabItem(title: nAnteriores, style: tTabHistorial),
                    ],
                  ),
                ),
              ),
            ),
          body: 
          TabBarView(
            children: [
              Center(child: NuevasNotScreen(idUser:widget.idUser, nameId: widget.nameId,id: widget.id,
                                idCollection: widget.idCollection,
                                ocTabBar: widget.ocTabBar,
              )),
              Center(child: AnteriorNotScreen(idUser:widget.idUser, nameId: widget.nameId,id: widget.id,
                                idCollection: widget.idCollection,
                                ocTabBar: widget.ocTabBar,)),
            ],
          ),
        ),
      ),
    );
  }
}