import 'package:flutter/material.dart';

class CustomBodyScaffold extends StatelessWidget {
  const CustomBodyScaffold({super.key, this.child});
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SafeArea(
            child: child!,
          ),
        ],
      ),
    );
  }
}