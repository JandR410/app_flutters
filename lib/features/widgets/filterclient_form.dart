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

class FilterClientScreen extends StatefulWidget {
  final nameId;
  final idUser;
  const FilterClientScreen({
    super.key,
    required this.idUser,
    required this.nameId,
    required String docUSer,
  });

  @override
  State<FilterClientScreen> createState() => _FilterClientScreenState();
}

class _FilterClientScreenState extends State<FilterClientScreen> {
  String rucID = "";
  var datoSelect = '';
  bool? _isChecked = false;
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
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          toolbarHeight: 150,
          leadingWidth: 500,
          leading: tituloCliente(),
          backgroundColor: Colors.white,
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(3),
              child: Container(
                color: Colors.white,
                child: TextField(
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: EdgeInsets.only(
                          right: 10, left: 10, top: 10, bottom: 10),
                      hintText: ' Buscar cliente'),
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
              backgroundColor: Colors.black, minimumSize: Size(350, 40)),
          child: const Text(
            'Filtrar',
            style: TextStyle(color: Colors.white),
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
          var dataClean = snapshots.data?.docs
              .fold<Map<String, dynamic>>({}, (Map<String, dynamic> map, obj) {
                map[(obj.data() as Map<String, dynamic>)['organization_name']] =
                    obj;
                return map;
              })
              .values
              .toList();
          return (snapshots.connectionState == ConnectionState.waiting)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: dataClean!.length,
                  itemBuilder: (context, index) {
                    var data = dataClean[index].data() as Map<String, dynamic>;
                    if (rucID.isEmpty) {
                      return Center(
                        child: StatefulBuilder(
                          builder: (context, _setState) => CheckboxListTile(
                            title: Text(
                              data['organization_name'],
                              style: TextStyle(fontSize: 12),
                            ),
                            value: _isChecked,
                            activeColor: Colors.black,
                            checkColor: Colors.white,
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (value) {
                              _setState(() {
                                _isChecked = value;
                                if (_isChecked == true) {
                                  datoSelect = rucID;
                                  print('Dato $rucID');
                                }
                              });
                            },
                          ),
                        ),
                      );
                    }
                    if (data['organization_name']
                        .toString()
                        .toLowerCase()
                        .contains(rucID.toLowerCase())) {
                      return Center(
                        child: StatefulBuilder(
                          builder: (context, _setState) => CheckboxListTile(
                            title: Text(
                              data['organization_name'],
                              style: TextStyle(fontSize: 12),
                            ),
                            value: _isChecked,
                            activeColor: Colors.black,
                            checkColor: Colors.white,
                            tristate: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (value) {
                              _setState(() {
                                _isChecked = value;
                                if (_isChecked == true) {
                                  datoSelect = data['organization_name'];
                                  print('Dato $datoSelect');
                                }
                              });
                            },
                          ),
                        ),
                      );
                    }
                    return Container();
                  },
                );
        },
      ),
    );
  }
}

Widget tituloCliente() {
  return Container(
    color: Colors.white,
    child: const Stack(
      alignment: AlignmentDirectional.centerStart,
      children: <Widget>[
        Text(
          tCliente,
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
