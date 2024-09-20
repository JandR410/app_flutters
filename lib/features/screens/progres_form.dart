import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProgressFormScreen extends StatefulWidget {
  @override
  State<ProgressFormScreen> createState() => _ProgressFormScreen();
}

class _ProgressFormScreen extends State<ProgressFormScreen> {
  List<QueryDocumentSnapshot> data = [];
  final _db = FirebaseFirestore.instance;

  getDataItems() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("purchase_orders")
        .doc("DJjaWUHdB5pYiJYrA07x")
        .collection("items")
        .get();
    data.addAll(querySnapshot.docs);
    setState(() {});
  }

  @override
  void initState() {
    getDataItems();
    super.initState();
  }

  double _progress = 0;
  int _duration = 5;

  void startTimer(){
    new Timer.periodic(Duration(seconds: _duration), (timer){
      if(_progress == _duration){
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: data!.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, mainAxisExtent: 160),
        itemBuilder: (context, i) {
          return SafeArea(
              child: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  backgroundColor: Colors.green,
                  value: _progress
                )
              ],
            ),
          ));
          // Container(
          //   height: 450,
          //   child: Text("${data[i]['description']}"),
          // );
        });
  }
}
