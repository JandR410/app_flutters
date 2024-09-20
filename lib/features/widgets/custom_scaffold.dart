import 'package:flutter/material.dart';

import '../../utils/constants/sizes.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, this.child});
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        leading: iconOC(),
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            height:650,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/fondoLogin.png"),
                fit: BoxFit.fitHeight,
              ),
            ),
            child: Container(
              width: 600,
              height: 400,
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top:110, right: 10, left: 10),
              child: Image.asset(
                'assets/images/iconos.png',
                width: 500,
              ),
            ),
          ),
          SafeArea(
            child: child!,
          ),
        ],
      ),
    );
  }
}

Widget iconOC() {
  return Container(
    height: 30.0,
    width: 30.0,
    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
    margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
    child: Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Image.asset(
          'assets/images/logo.png',
          width: 60.0,
          height: 60.0,
        ),
      ],
    ),
  );
}
