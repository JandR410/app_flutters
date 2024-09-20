import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:ordencompra/features/screens/dashboard_screen.dart';
import 'package:ordencompra/features/screens/signup_screen.dart';
import 'package:poapprovalsdk/api.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:developer' as developer;
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/text_strings.dart';

class GoogleButton extends StatefulWidget {
  const GoogleButton(
      {super.key, this.buttonText, this.onTap, this.color, this.textColor});
  final String? buttonText;
  final Widget? onTap;
  final Color? color;
  final Color? textColor;

  @override
  State<GoogleButton> createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<GoogleButton> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String macCode = '';
  var tokenId = '';
  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() async {
        _user = event;
        final token = await _user!.getIdToken();
        tokenId = token!;
        developer.log(_user!.uid, name: "UID FIREBASE");
        developer.log(token!, name: "ID TOKEN");
      });
    });
  }

  void sendMessage(String message) {
    print("Sending message: $message");
  }

  @override
  Widget build(BuildContext context) {
    Duration delayDuration = Duration(seconds: 1);
    String textMessage = "Hello, this is a delayed message!";
    return Center(
        child: ElevatedButton(
      onPressed: () async {
        _handleGoogleSignIn();

        showLoadingDialog(context); // show our loading dialog
        await Future.delayed(delayDuration, () {
          sendMessage(textMessage);
        }); // waiting for a second
        hideLoadingDialog(context);
      },
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(60),
        backgroundColor: tButtonLogin, // Change the button's background color
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8.0), // Adjust the border radius as needed
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            'assets/images/google.png', // Your Google logo image
            height: 30.0,
            width: 30,
          ),
          SizedBox(width: 12.0),
          Text(
            'Ingresar con Google',
            style: TextStyle(
                fontSize: 18.0,
                color: Colors.white), // Adjust the text style as needed
          ),
        ],
      ),
    ));
  }

  Future<void> _handleGoogleSignIn() async {
    String macCodeId = "";
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Duration delayDuration = Duration(seconds: 5);
    String textMessage = "Hello, this is a delayed message!";
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      await _auth.signInWithProvider(_googleAuthProvider);
      var androidInfo = await deviceInfoPlugin.androidInfo;
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
      final api = ApiClient(
          basePath: urlDev);
      IdTokenResult? tokenResult =
          await FirebaseAuth.instance.currentUser?.getIdTokenResult();
      macCodeId = androidInfo.id ?? 'Unknown';
      String? tokenCodeId = await _firebaseMessaging.getToken();
      final token = await _user!.getIdToken();
      api.addDefaultHeader('Authorization', "Bearer ${token}");
      final api_instance = DeviceSubscriptionsApi(api);
      if (_user!.uid != "") {
        try {
          final result =
              api_instance.upsertSubscription(tokenCodeId!, macCodeId);
          print(result);
        } catch (e) {
          showErrorDialog(context, e.toString());
          print(
              'Exception when calling DeviceSubscriptionsApi->upsertSubscription: $e\n');
        }

        showLoadingDialog(context); // show our loading dialog
        await Future.delayed(delayDuration, () {
          sendMessage(textMessage);
        }); // waiting for a second
        hideLoadingDialog(context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const DashboardScreen(
                    docUSer: '',
                    idUser: '',
                    nameId: '',
                  )),
        );
        await foo();
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignUpScreen()),
        );
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> foo() async {
    print('foo started');
    await Future.delayed(Duration(seconds: 1));
    print('foo executed');
    return;
  }

  Widget _userInfo() {
    var logger = Logger(
      printer: PrettyPrinter(),
    );
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: 100,
              width: 100,
            ),
            Text(_user!.email!),
            Text(_user!.uid),
          ],
        ));
  }
}

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Container(
          padding: EdgeInsets.all(10),
          child: Text(
              'Hemos tenido un problema autenticando tu usuario, por favor cierra la aplicación y vuelve a intentar.',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontFamily: 'Lato',
                letterSpacing: 0.1,
                fontWeight: FontWeight.w400,
                decorationThickness: 0.5,
              )),
        ),
        actions: <Widget>[
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
                  const Text('Cerrar', style: TextStyle(color: Colors.white)),
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

Future<void> showLoadingDialog(
  BuildContext context,
) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

void hideLoadingDialog(BuildContext context) {
  Navigator.of(context).pop();
}
