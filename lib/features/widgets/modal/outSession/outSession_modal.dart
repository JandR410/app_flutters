import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ordencompra/features/screens/signup_screen.dart';
import 'package:ordencompra/repository/authentication/authentication_repository.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';

import '../../../../controllers/stream_controller.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/theme/theme.dart';

class OutSessionScreen extends StatelessWidget {
  const OutSessionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authRepo = Get.put(AuthenticationRepository());
    final id = _authRepo.firebaseUser?.uid;
      final DashboardStreamController _dashboardStreamController = DashboardStreamController();

    return StreamBuilder<List<DocumentSnapshot>>(
        stream: _dashboardStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            // Si no hay datos en la colección
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
                            iIconDashboard,
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
                              iIconMenubar,
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
                      tUserNotFound,
                      style: dUserError,
                      // textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      tEmailNotFound,
                      style: dModalErrorTitle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.only(left: 0),
                    child: ElevatedButton(
                      style: dErrorUserButton,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(dBotonOut,
                              style: dBotonTextError),
                          SizedBox(width: 8),
                          Image.asset(
                            iIconExit,
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
                                builder: (context) => const SignUpScreen()));
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Si hay datos en la colección
            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var data =
                      snapshot.data![index].data() as Map<String, dynamic>;
                  final ID = data['firebase_id'];
                  final full_name = data['full_name'];
                  final correo = data['email'];
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
                                  iIconDashboard,
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
                                    iIconMenubar,
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
                            style: dTitleUser,
                            // textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            correo,
                            style: dTitleEmail,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.only(left: 0),
                          child: ElevatedButton(
                            style: dOutUserButton,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(dBotonOut,
                                    style: dBotonTextOut),
                                SizedBox(width: 8),
                                Image.asset(
                                  iIconExit,
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
          }
        });
  }
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().signOut();
}