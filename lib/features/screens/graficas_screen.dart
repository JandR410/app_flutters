import 'package:flutter/material.dart';
import 'package:ordencompra/features/screens/graficafirst_screen.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/text_strings.dart';
import '../../utils/theme/theme.dart';

var docProveedor = '';
var datoSelect = '';

class GraficasScreen extends StatelessWidget {
  final idFilterUser;
  GraficasScreen({Key? key, required this.idFilterUser}) : super(key: key);

  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(right: 5, left: 5),
        child: OutlinedButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>  GraficaFirstScreen(id: idFilterUser,)),
            );
            
          },
          style: OutlinedButton.styleFrom(
              side: BorderSide(width: 1.0, color: tBorderCard),
              padding:
                  EdgeInsets.only(right: 15, left: 25, top: 15, bottom: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                iGraficaDash,
                width: 30,
                height: 30,
              ),
              SizedBox(width: 20),
              Text(gTitleDashboard,
                  style: gTitleStyleDashboard),
              SizedBox(width: 8),
            ],
          ),
        ),
      );
  }
}