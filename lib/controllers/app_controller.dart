import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../repository/authentication/authentication_repository.dart';

class AppController extends GetxController {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late String? token;

  @override
  void onInit() {
    print('AppController onInit');
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    Get.put(AuthenticationRepository());
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);

    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    token = await firebaseMessaging.getToken();
    print('token Firebase $token');

    configureFirebaseListeners();
    super.onReady();
  }

  @override
  void onClose() {
    print('AppController onClose');
    super.onClose();
  }

  void configureFirebaseListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('A new onMessage event was published!');
      // Maneja la notificación cuando la app está en primer plano

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // if (notification != null && android != null) {
      //   print('notification: ${notification.title}');
      //   print('notification: ${notification.body}');

      //   Get.defaultDialog(
      //     title: notification.title ?? '',
      //     content: Column(
      //       children: [
      //         Text(notification.body ?? ''),
      //         ElevatedButton(
      //           onPressed: () {
      //             Get.back();
      //           },
      //           child: const Text('Cerrar'),
      //         ),
      //       ],
      //     ),
      //   );
      // }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Maneja la notificación cuando la app está en segundo plano
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('Handling a background message ${message.messageId}');
  }
}
