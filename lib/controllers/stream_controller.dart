import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../repository/authentication/authentication_repository.dart';

final _authRepo = Get.put(AuthenticationRepository());
final id = _authRepo.firebaseUser?.uid;

class DashboardStreamController {
  final StreamController<List<DocumentSnapshot>> _controller =
      StreamController<List<DocumentSnapshot>>();

  DashboardStreamController() {
    _init();
  }

  void _init() {
    FirebaseFirestore.instance
        .collection('user_mappings')
        .where("firebase_id", isEqualTo: id)
        .snapshots()
        .listen((snapshot) {
      _controller.add(snapshot.docs);
    });
  }

  Stream<List<DocumentSnapshot>> get stream => _controller.stream;

  void dispose() {
    _controller.close();
  }
}


class FirestoreStreamController {
  final StreamController<List<DocumentSnapshot>> _controller =
      StreamController<List<DocumentSnapshot>>();

  FirestoreStreamController() {
    _init();
  }

  void _init() {
    FirebaseFirestore.instance
        .collection('purchase_orders')
        .orderBy("issued_at", descending: true)
        .snapshots()
        .listen((snapshot) {
      _controller.add(snapshot.docs);
    });
  }

  Stream<List<DocumentSnapshot>> get stream => _controller.stream;

  void dispose() {
    _controller.close();
  }
}
