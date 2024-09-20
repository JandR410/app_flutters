import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../utils/constants/text_strings.dart';
import '../../utils/theme/theme.dart';
import '../screens/ordencompra_screen.dart';

class PDFViewForm extends StatelessWidget{
  final link;
  final title;
  final idKey;
  final idCollection;
  final ocTabBar;
  final idUser;
  PDFViewForm({Key? key,required this.link,required this.title,required this.idKey,required this.idCollection,required this.ocTabBar, required this.idUser}) : super(key: key);


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp),
          onPressed: () {
                    Navigator.pop(context);
          },
        ),
        title: Text(title),
        titleSpacing: 0,
        backgroundColor: Colors.white,
      ),
      body: SfPdfViewer.network(link),
    );
  }
}

Widget tituloPDF() {
  return Container(
    child: const Stack(
      alignment: AlignmentDirectional.centerStart,
      children: <Widget>[
        Text(
          PDF,
          style: tDetalle,
        )
      ],
    ),
  );
}