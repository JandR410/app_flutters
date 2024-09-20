import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:ordencompra/utils/theme/theme.dart';
import 'package:ordencompra/features/widgets/custom_bodyScaffold.dart';
import 'package:ordencompra/features/widgets/custom_scaffold.dart';
import 'package:ordencompra/features/widgets/google_button.dart';
import 'package:sign_in_button/sign_in_button.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: iconOC(),
          titleSpacing: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Image.asset('assets/images/menu.png'),
            ),
          ],
          backgroundColor: Colors.black,
        ),
        body: bodyOC(),  
      );
  }
}

Widget bodyOC(){
  return CustomBodyScaffold(
    child: Column(
      children: [
        Flexible(
          flex: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 20.0,
            ),
            child: Container(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'ÓRDENES DE COMPRA',
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                    ]
                  )
                ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget iconOC() {
  return Container(
    height: 30.0,
    width: 30.0,
    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
    margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
    child: new Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        new Image.asset(
          'assets/images/icono.png',
          width: 30.0,
          height: 30.0,
        ),
      ],
    ),
  );
}
