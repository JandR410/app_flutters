import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../utils/constants/text_strings.dart';
import '../../utils/theme/theme.dart';

class CardNotNuevasFormScreen extends StatelessWidget {
  const CardNotNuevasFormScreen({
    Key? key,
    required this.mensaje,
    required this.title,
    required this.status,
  }) : super(key: key);

  final mensaje;
  final title;
  final status;

  @override
  Widget build(BuildContext context) {
    var estado;
    final textStyle;
    if (status == 'PENDING_APPROVAL') {
      estado = 'Pendiente';
      textStyle = OutlinedButton.styleFrom(
          side: BorderSide(width: 2.0, color: Colors.grey),
          maximumSize: Size.fromHeight(50),
          padding: EdgeInsets.only(right: 15, left: 15));
    } else {
      estado = 'Aprobado';
      textStyle = OutlinedButton.styleFrom(
          side: BorderSide(width: 2.0, color: Colors.green));
    }
    return Form(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FadeInImage(
                    fit: BoxFit.cover,
                    height: 80,
                    placeholder: AssetImage('assets/images/bell.png'),
                    image: AssetImage('assets/images/bell.png')),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      style: textStyle,
                      child: Text(
                        estado,
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                    Container(
                      width: 230,
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 1,
                        style: nTituloS,
                      ),
                    ),
                    Text(
                      mensaje,
                      style: nMensajeS,
                    )
                  ],
                )
              ],
            ),
          ]),
    );
  }
}
