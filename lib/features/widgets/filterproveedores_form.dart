import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ordencompra/features/screens/detalleoc_screen.dart';
import 'package:ordencompra/features/screens/notificacion_screen.dart';
import 'package:ordencompra/features/screens/signup_screen.dart';
import 'package:ordencompra/repository/authentication/authentication_repository.dart';
import 'package:badges/badges.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';
import '../../controllers/profile_controller.dart';
import '../../models/user_model.dart';
import '../../utils/constants/colors.dart';
import 'filterprovee_form.dart';

var docUserId;

class FilterProveedorScreen extends StatefulWidget {
  final nameId;
  final idUser;
  const FilterProveedorScreen({
    super.key,
    required this.idUser,
    required this.nameId,
    required String docUSer,
  });

  @override
  State<FilterProveedorScreen> createState() =>
      _FilterProveedorScreenScreenState();
}

class _FilterProveedorScreenScreenState extends State<FilterProveedorScreen> {
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

  Future<void> _showTopModal(context) async {
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

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        leading: iconOC(context),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotificacionScreen(
                                  idUser: '',
                                  nameId: '',
                                  docUSer: '',
                                )));
                  },
                ),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              child: GestureDetector(
                onTap: () {
                  _showTopModal(context);
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
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(right: 30, left: 30, bottom: 30),
        child: FilterProveeScreen(
          idUser: widget.idUser,
          nameId: '',
          docUSer: '',
        ),
      ),
    );
  }
}

Widget iconOC(contet) {
  return GestureDetector(
    onTap: () {
      Navigator.pop(contet);
    },
    child: Container(
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
