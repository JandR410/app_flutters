import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ordencompra/features/screens/ordencompra_screen.dart';
import 'package:ordencompra/features/screens/signup_screen.dart';
import 'package:ordencompra/repository/authentication/authentication_repository.dart';
import 'package:ordencompra/utils/constants/colors.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';

import 'notificacion_screen.dart';
import 'ordencomprah_screen.dart';

class InformacionHScreen extends StatefulWidget {
  final id;
  final idCollection;
  final ocTabBar;
  final idUser;
  final docUSer;
  final statusA;
  const InformacionHScreen(
      {super.key,
      required this.id,
      required this.idCollection,
      required this.ocTabBar,
      required this.idUser,
      required this.docUSer,
      required this.statusA});

  @override
  State<InformacionHScreen> createState() => _InformacionHScreenState();
}

class _InformacionHScreenState extends State<InformacionHScreen> {
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

  @override
  Widget build(BuildContext context) {
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
      body: OrdenCompraHScreen(
          idKey: widget.id,
          idCollection: widget.idCollection,
          ocTabBar: widget.ocTabBar,
          idUser: widget.idUser,
          docUSer: widget.docUSer),
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
