import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ordencompra/models/orders_model.dart';

import '../../utils/constants/text_strings.dart';
import '../../utils/theme/theme.dart';

class CardocHistorialFormScreen extends StatelessWidget {
  const CardocHistorialFormScreen({Key? key, required this.amount, required this.id, required this.subject, required this.aprovador})
      : super(key: key);

  final amount;
  final id;
  final subject;
  final aprovador;

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tOrdenCompra,
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
                style: tsubStyle,
              ),
              Text(
                'S/ '+amount,
                maxLines: 1,
                style: tsubStyle,
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
            maxLines: 2,
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
            aprovador,
            maxLines: 2,
            style: tsubStyle,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.0),
            child: Divider(
              thickness: 1.4,
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FadeInImage(
                  fit: BoxFit.cover,
                  height: 30,
                  placeholder: AssetImage('assets/images/card.png'),
                  image: AssetImage('assets/images/card.png')),
              Text('Hace 2 horas')
            ],
          ),
        ]));
  }
}
