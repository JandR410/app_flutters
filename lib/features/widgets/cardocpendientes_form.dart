import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../utils/constants/text_strings.dart';
import '../../utils/theme/theme.dart';

class CardocPendientesFormScreen extends StatelessWidget {
  const CardocPendientesFormScreen(
      {Key? key,
      required this.amount,
      required this.id,
      required this.subject,
      required this.aprovador,
      required this.ORG,
      required this.dataArriedAt,
      required this.documentId})
      : super(key: key);

  final amount;
  final id;
  final subject;
  final aprovador;
  final ORG;
  final dataArriedAt;
  final documentId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('purchase_orders')
            .doc(documentId)
            .collection('approvers')
            .limit(1)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: ListView(
              reverse: true,
              physics: ClampingScrollPhysics(),
              children: snapshot.data!.docs.map((e) {
                // final ocI = e['purchase_order_id'];
                var responsable = "";


                final responsableDemo = e['full_name'];

                if(responsableDemo == ""){
                  responsable = "-------------------";
                } else {
                  responsable = e['full_name'];
                }
                // var responsableName = responsable[]
                return Form(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tOrdenCp,
                            maxLines: 1,
                            style: tituloStyle,
                          ),
                          Text(
                            tMontoP,
                            maxLines: 1,
                            style: tituloStyle,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            id,
                            maxLines: 1,
                            style: tfirtsLine,
                          ),
                          Text(
                            amount,
                            maxLines: 1,
                            style: tfirtsLine,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        tAsunto,
                        maxLines: 1,
                        style: tituloStyle,
                      ),
                      Text(
                        subject,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: tsubStyle,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        tResponsable,
                        maxLines: 1,
                        style: tituloStyle,
                      ),
                      Text(
                        responsable,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                        style: tsubStyle,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.0),
                        child: Divider(
                          thickness: 1,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FadeInImage(
                              fit: BoxFit.contain,
                              height: 30,
                              placeholder: AssetImage('assets/images/$ORG.png'),
                              image: AssetImage('assets/images/$ORG.png')),
                          Text(dataArriedAt)
                        ],
                      ),
                    ]));
              }).toList(),
            ),
          );
        });
  }
}
