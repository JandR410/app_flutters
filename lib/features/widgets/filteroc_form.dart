import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordencompra/features/screens/detalleoc_screen.dart';
import 'package:ordencompra/features/screens/notificacion_screen.dart';
import 'package:ordencompra/repository/authentication/authentication_repository.dart';
import 'package:badges/badges.dart';
import '../../controllers/profile_controller.dart';
import '../../models/user_model.dart';
import '../../utils/constants/text_strings.dart';
import '../screens/dashboard_screen.dart';

var docUserId;

class FilterOCScreen extends StatefulWidget {
  final nameId;
  final idUser;
  const FilterOCScreen({
    super.key,
    required this.idUser,
    required this.nameId,
    required String docUSer,
  });

  @override
  State<FilterOCScreen> createState() => _FilterOCScreenState();
}

class _FilterOCScreenState extends State<FilterOCScreen> {
  final ScrollController _scrollController = ScrollController();
  String rucID = "";
  var datoSelect = '';

  Map<String, bool> _isCheckedMap = {};
  bool _selectAll = false;

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

  @override
  void initState() {
    getDocumentIds();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 150,
          leadingWidth: 500,
          leading: tituloOC(),
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(3),
              child: Container(
                height: 60,
                color: Colors.white,
                child: TextField(
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      suffixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: EdgeInsets.only(
                          right: 10, left: 10, top: 10, bottom: 10),
                      hintText: ' Buscar órdenes de compra'),
                  onChanged: (val) {
                    setState(() {
                      rucID = val;
                    });
                  },
                ),
              ))),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black, minimumSize: Size(350, 50)),
          child: const Text(
            'Filtrar',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DashboardScreen(
                        idUser: widget.idUser,
                        nameId: datoSelect,
                        docUSer: '',
                      )),
            );
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('purchase_orders')
            .where("stakeholders", arrayContains: widget.idUser)
            .snapshots(),
        builder: (context, snapshots) {
          return (snapshots.connectionState == ConnectionState.waiting)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Scrollbar(
                  thumbVisibility: true, // Hace que el Scrollbar sea visible
                  trackVisibility:
                      true, // Hace que el Scrollbar siempre sea visible
                  controller: _scrollController,
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        child: CheckboxListTile(
                          title: const Text(
                            'Marcas todas',
                            style: TextStyle(fontSize: 12),
                          ),
                          value: _selectAll,
                          activeColor: Colors.black,
                          checkColor: Colors.white,
                          tristate: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (bool? value) {
                            setState(() {
                              _selectAll = (value == null) ? false : true;
                              _isCheckedMap
                                  .updateAll((key, value) => _selectAll);
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: snapshots.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data = snapshots.data!.docs[index].data()
                                as Map<String, dynamic>;
                            var purchaseOrderNumber =
                                data['purchase_order_number'];

                            // Inicializa el estado del checkbox si aún no se ha hecho.
                            _isCheckedMap.putIfAbsent(
                                purchaseOrderNumber, () => false);

                            if (rucID.isEmpty) {
                              return Container(
                                color: Colors.white,
                                child: Center(
                                  child: StatefulBuilder(
                                    builder: (context, _setState) =>
                                        CheckboxListTile(
                                      title: Text(
                                        data['purchase_order_number'],
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      value: _isCheckedMap[purchaseOrderNumber],
                                      activeColor: Colors.black,
                                      checkColor: Colors.white,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      onChanged: (value) {
                                        _setState(() {
                                          // Actualiza el estado del checkbox específico.
                                          _isCheckedMap[purchaseOrderNumber] =
                                              value!;
                                          if (value == true) {
                                            datoSelect = purchaseOrderNumber;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              );
                            }
                            if (data['purchase_order_number']
                                .toString()
                                .toLowerCase()
                                .contains(rucID.toLowerCase())) {
                              return Container(
                                color: Colors.white,
                                child: Center(
                                  child: StatefulBuilder(
                                    builder: (context, _setState) =>
                                        CheckboxListTile(
                                      title: Text(
                                        data['purchase_order_number'],
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      value: _isCheckedMap[purchaseOrderNumber],
                                      activeColor: Colors.black,
                                      checkColor: Colors.white,
                                      tristate: true,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      onChanged: (value) {
                                        // Actualiza el estado del checkbox específico.
                                        _isCheckedMap[purchaseOrderNumber] =
                                            value!;
                                        if (value == true) {
                                          datoSelect = purchaseOrderNumber;
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Container(
                              color: Colors.white,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}

Widget tituloOC() {
  return Container(
    color: Colors.white,
    child: const Stack(
      alignment: AlignmentDirectional.centerStart,
      children: <Widget>[
        Text(
          tOC,
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
            fontSize: 55,
            color: Colors.transparent,
            fontFamily: 'knockout',
            letterSpacing: 1,
            decoration: TextDecoration.underline,
            decorationColor: Colors.green,
            decorationThickness: 1,
          ),
        ),
      ],
    ),
  );
}
