import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ordencompra/utils/constants/text_strings.dart';
import 'package:ordencompra/features/widgets/custom_scaffold.dart';
import 'package:ordencompra/features/widgets/google_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formSignupKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late ConnectivityResult _connectivityResult;
  late Stream<ConnectivityResult> _connectivityStream;

  User? _user;

  bool agreePersonalData = true;

  @override
  void initState() {
    super.initState();
      _auth.authStateChanges().listen((event) {
        setState(() {
          _user = event;
        });
      });
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to block the back button
        return false;
      },
      child: CustomScaffold(
        child: Column(
          children: [
            const Expanded(
              flex: 1,
              child: SizedBox(
                height: 10,
              ),
            ),
            Expanded(
              flex: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 20.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: SingleChildScrollView(
                  // get started form
                  child: Form(
                    key: _formSignupKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: InkWell(
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 45,
                              height: 45,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        Text(
                          tIniciarSersion,
                          style: TextStyle(
                            fontSize: 32.0,
                            fontFamily: 'knockout',
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          child: Text(
                            'INICIASESI',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10.0,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.green,
                              decorationThickness: 6,
                              fontFamily: 'knockout',
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        // signup button
                        SizedBox(
                          width: double.infinity,
                          height: 80,
                          child: GoogleButton(
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        // already have an account
                        SizedBox(
                          height: 0.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 
_showNoInternetDialog(
    BuildContext context) {;
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
                  child: Text(
                    'Estamos trabajando para solucionarlo, vuelve a intentarlo en unos momentos.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: 'Lato',
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.w400,
                      decorationThickness: 0.5,
                    ),
                  ),
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
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black),
                  ))),
              child:
                  const Text('Volver a cargar', style: TextStyle(color: Colors.white)),
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

Widget tituloInternet() {
  return Container(
    child: Stack(
      alignment: AlignmentDirectional.centerStart,
      children: <Widget>[
        Text(
          'LO SENTIMOS, ALGO SALIÓ MAL',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontFamily: 'knockout',
          ),
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