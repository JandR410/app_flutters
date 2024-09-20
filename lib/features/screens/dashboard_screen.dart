import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ordencompra/features/screens/detalleoc_screen.dart';
import 'package:ordencompra/features/screens/notificacion_screen.dart';
import 'package:ordencompra/features/screens/signup_screen.dart';
import 'package:ordencompra/repository/authentication/authentication_repository.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/stream_controller.dart';
import '../../models/user_model.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/text_strings.dart';
import '../../utils/theme/theme.dart';
import '../widgets/modal/outSession/outSession_modal.dart';

var docUserId;

class DashboardScreen extends StatefulWidget {
  final nameId;
  const DashboardScreen({
    super.key,
    required idUser,
    required this.nameId,
    required String docUSer,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
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
    Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      _connectivityResult = result;
    });
    if (result == ConnectivityResult.none) {
      _showNoInternetDialog(context);
    }
  }

  _showNoInternetDialog(BuildContext context) async {
    ;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          title: tituloInternet(),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              height: 115,
              padding: EdgeInsets.only(right: 5, left: 5),
              child: Column(
                children: [
                  Container(
                    width: 350,
                    child: Text(dNoInternet, style: dModalInternet),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
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
                style: dModalButton,
                child:
                    const Text(dBotonM, style: TextStyle(color: Colors.white)),
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

  Future<void> _showTopModal() async {
    String _topModalData = "";
    final value = await showTopModalSheet<String?>(
      context,
      const OutSessionScreen(),
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
                    iIconNot,
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
                  _showTopModal();
                },
                child: Image.asset(
                  iIconMenubar,
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
      bottomSheet: SizedBox(
        height: 20,
      ),
      body: FutureBuilder(
        future: controller.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              UserModel userData = snapshot.data as UserModel;
              final idUser = userData.id;
              return WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: DetalleOCScreen(
                    docUSer: docUserId, idUser: idUser, nameId: widget.nameId),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return const Center(child: Text(tWrong));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

Widget iconOC(context) {
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

Widget tituloInternet() {
  return Container(
    child: Stack(
      alignment: AlignmentDirectional.centerStart,
      children: <Widget>[
        Text(
          dTitleModalInternet,
          style: dTitleModal,
        ),
        SizedBox(
          height: 60,
        ),
        Container(
          padding: EdgeInsets.only(top: 90),
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
