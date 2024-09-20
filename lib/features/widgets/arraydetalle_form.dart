import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ordencompra/features/screens/dashboard_screen.dart';

class ArrayDetalle extends StatefulWidget {
  const ArrayDetalle({
    super.key,
  });

  @override
  State<ArrayDetalle> createState() => _ArrayDetalle();
}

class _ArrayDetalle extends State<ArrayDetalle> {
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

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: data!.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, mainAxisExtent: 160),
        itemBuilder: (context, i) {
          return
           Container(
            height:450,
                    child: Text("${data[i]['description']}"),
            );
        });
  }
}
