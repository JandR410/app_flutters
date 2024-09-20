import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:ordencompra/models/items_model.dart';
import 'package:ordencompra/repository/authentication/exceptions/t_exceptiones.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/orders_model.dart';
import '../../utils/constants/text_strings.dart';

class OrdersRepository extends GetxController {
  static OrdersRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<OrdersModel> getOrdersDetails(String id) async {
    try {
      final snapshot = await _db
          .collection("purchase_orders")
          .where("id", isEqualTo: id)
          .get();
      if (snapshot.docs.isEmpty) throw 'Usuario no registrado';
      final ordersData =
          snapshot.docs.map((e) => OrdersModel.fromSnapshot(e)).single;
      final prefs = await SharedPreferences.getInstance();
      var savaData = jsonEncode(ordersData.toString());
      await prefs.setString('jsonData', savaData);
      return ordersData;
    } on FirebaseAuthException catch (e) {
      final result = TExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString().isEmpty
          ? 'Something went wrong. Please Try Again'
          : e.toString();
    }
  }

  Future<QuerySnapshot?> getItems() async {
    List<String> docItems = [];
    try {
      final itemsData = _db.collection("purchase_orders").get().then((value) {
        value.docs.forEach((result) {
          _db
              .collection("purchase_orders")
              .doc(result.id)
              .collection("items")
              .get()
              .then((subcol) {
            subcol.docs.forEach((document) {
              print(document.data());
              docItems.add(document.reference.id);
            });
          });
        });
      });
      return itemsData;
    } on FirebaseAuthException catch (e) {
      final result = TExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString().isEmpty
          ? 'Something went wrong. Please Try Again'
          : e.toString();
    }
  }

  Future<QuerySnapshot?> getApproval() async {
    try {
      final itemsData = _db.collection("purchase_orders").get().then((value) {
        value.docs.forEach((result) {
          final snapshot = _db
              .collection("purchase_orders")
              .doc(result.id)
              .collection("approval_levels")
              .where("purchase_order_id", isEqualTo: "2130002478")
              .get()
              .then((subcol) {
            subcol.docs.forEach((element) {
              print(element.data());
            });
          });
        });
      });
    } on FirebaseAuthException catch (e) {
      final result = TExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString().isEmpty
          ? 'Something went wrong. Please Try Again'
          : e.toString();
    }
  }

  Future<QuerySnapshot?> getData(String id) async {
    var dataofItem = FirebaseFirestore.instance
        .collection("purchase_orders")
        .where("responsible", isEqualTo: "CSTI119")
        .get()
        .then((QuerySnapshot? querySnapShot) {
      querySnapShot!.docs.forEach((doc) {
        var allData = doc["items"];
        print("allData = $allData");
      });
    });
    return dataofItem;
  }
}
