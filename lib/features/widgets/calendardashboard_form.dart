import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordencompra/features/screens/detalleoc_screen.dart';
import 'package:ordencompra/features/screens/notificacion_screen.dart';
import 'package:ordencompra/repository/authentication/authentication_repository.dart';
import 'package:badges/badges.dart';
import '../../controllers/profile_controller.dart';
import '../../models/user_model.dart';
import 'detallecalendar_form.dart';

var docUserId;

class CalendarDashScreen extends StatefulWidget {
  final nameId;
  final startDate;
  final endDate;
  const CalendarDashScreen({
    super.key, required idUser, required this.nameId, required String docUSer,required this.startDate,required this.endDate,
  });

  @override
  State<CalendarDashScreen> createState() => _CalendarDashScreenState();
}

class _CalendarDashScreenState extends State<CalendarDashScreen> {
  
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
    var docIdUser = (documentIds.toString()).replaceAll("[", "").replaceAll("]", "");
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
      appBar: AppBar(
        leading: iconOC(),
        titleSpacing: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) =>const NotificacionScreen(idUser: '', nameId: '', docUSer: '',)));
              },
              child:
               Image.asset(
                'assets/images/notificacion.png',
                width: 15.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Image.asset(
              'assets/images/menubar.png',
              width: 80.0,
              height: 50.0,
            ),
          ),
        ],
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: controller.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              UserModel userData = snapshot.data as UserModel;
              final idUser = userData.id;
              print('idUser $idUser');
              return 
                    DetalleCalendarScreen(docUSer: docUserId, idUser: idUser, nameId: widget.nameId, startDate: widget.startDate, endDate: widget.endDate,);
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return const Center(child: Text('Something went wrong'));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
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
