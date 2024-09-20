import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:ordencompra/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ordencompra/services/notification_service.dart';
import 'features/screens/app_screen.dart';
import 'utils/app_bindings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'oc',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initNotifications();

  runApp(
    GetMaterialApp(
      initialBinding: InitialBinding(),
      debugShowCheckedModeBanner: false,
      home: const AppScreen(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es')],
    ),
  );
}
