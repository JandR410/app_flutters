import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ordencompra/features/screens/detallegrafica_screen.dart';
import 'package:ordencompra/features/screens/notificacion_screen.dart';
import 'package:ordencompra/features/screens/signup_screen.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';

import '../../repository/authentication/authentication_repository.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/text_strings.dart';
import '../widgets/modal/outSession/outSession_modal.dart';

class GraficaFirstScreen extends StatefulWidget {
  final id;

  const GraficaFirstScreen({super.key, required this.id});

  @override
  State<GraficaFirstScreen> createState() => _GraficaFirstScreenState();
}

class _GraficaFirstScreenState extends State<GraficaFirstScreen> {
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
      body: DetalleGraficaScreen(idKey: widget.id),
    );
  }
}

Widget iconOC(context) {
  return GestureDetector(
    onTap: () {
      Navigator.pop(context);
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
            iIconDashboard,
            width: 30.0,
            height: 30.0,
          ),
        ],
      ),
    ),
  );
}
