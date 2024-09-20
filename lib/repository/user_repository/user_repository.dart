import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordencompra/repository/authentication/exceptions/t_exceptiones.dart';

import '../../models/user_model.dart';

class UserRepository extends GetxController{
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createUser(UserModel user) async {
    await _db.collection("user_mappings").add(user.toJson()).whenComplete(
        () => Get.snackbar("Success", "You account has been created",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withOpacity(0.1),
              colorText: Colors.green),
      )
    .catchError((error, stackTrace){
      Get.snackbar("Error", "Something went wrong. Try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      print("ERROR - $error");
    });  
  }

  Future<UserModel> getUserDetails(String firebaseid) async{
    try{
      final snapshot = await _db.collection("user_mappings").where("firebase_id", isEqualTo: firebaseid).get();
      if (snapshot.docs.isEmpty) throw 'Usuario no registrado';
      final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
      return userData;
    } on FirebaseAuthException catch (e) {
      final result = TExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString().isEmpty ? 'Something went wrong. Please Try Again' : e.toString();
    }
  }
  
  Future<List<UserModel>> allUser() async{
    final snapshot = await _db.collection("user_mappings").get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userData;
  }

  Future<QuerySnapshot?> getData(String firebaseid) async {
    var dataofItem = FirebaseFirestore.instance
        .collection("user_mappings.employee").where("firebase_id", isEqualTo: firebaseid).get().then((QuerySnapshot? querySnapShot){
          querySnapShot!.docs.forEach((doc) { 
            var allData = doc["employee"];
            print("allData = $allData");
          });
        });
   return dataofItem; 
  }
}