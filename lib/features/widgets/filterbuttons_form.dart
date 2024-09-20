import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ordencompra/features/screens/dashboard_screen.dart';
import 'package:ordencompra/features/widgets/filterproveedores_form.dart';
import '../../models/dashboardCategoriesModel.dart';
import '../../repository/authentication/authentication_repository.dart';
import '../../utils/constants/colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../utils/constants/text_strings.dart';
import '../../utils/theme/theme.dart';
import '../screens/filtercalendar_screen.dart';
import '../screens/pendientes_screen.dart';
import '../screens/tabs_form.dart';
import 'calendardashboard_form.dart';
import 'filtercliente_form.dart';
import 'filterordencompra_form.dart';

var docProveedor = '';
var datoSelect = '';


class FilterButtonScreen extends StatefulWidget {
  final idFilterUser;
  FilterButtonScreen({Key? key, required this.idFilterUser}) : super(key: key);

  @override
  State<FilterButtonScreen> createState() => _FilterButtonScreen();
}

class _FilterButtonScreen extends State<FilterButtonScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme txtTheme;
    final list = DashboardCategoriesModel.list;
    DateTimeRange selectedDates =
        DateTimeRange(start: DateTime.now(), end: DateTime.now());
    DateTimeRange? _selectedDateRange;
    return Localizations.override(
      context: context,
      child: SizedBox(
        height: 45,
        child: ListView.builder(
          itemCount: list.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => GestureDetector(
            onTap: list[index].onPress,
            child: SizedBox(
              height: 85,
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      if (list[index].title == 'Proveedores') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FilterProveedorScreen(
                                    nameId: '',
                                    idUser: widget.idFilterUser,
                                    docUSer: '',
                                  )),
                        );
                        FilterProveedorScreen;
                      } else if (list[index].title == 'Clientes') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FilterClienteScreen(
                                    nameId: '',
                                    idUser: widget.idFilterUser,
                                    docUSer: '',
                                  )),
                        );
                        FilterClienteScreen;
                      } else if (list[index].title == 'Órdenes de compra') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FilterOrdenCompraScreen(
                                    nameId: '',
                                    idUser: widget.idFilterUser,
                                    docUSer: '',
                                  )),
                        );
                        FilterOrdenCompraScreen;
                      } else if (list[index].title == 'Rango') {
                        var start;
                        var end;
                        DateTimeRange? _selectedDateRange;
                        final DateTimeRange? picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary:
                                      dDateSelect, // Change this to your desired color
                                  onPrimary: const Color.fromARGB(255, 18, 17,
                                      17), // Text color on primary color
                                  surface: Colors.grey, // Surface color
                                  onSurface: Colors
                                      .black, // Text color on surface color
                                ),
                                dialogBackgroundColor:
                                    Colors.white, // Background color
                              ),
                              child: child!,
                            );
                          },
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(width: 1.0, color: tBorderCard),
                        padding: EdgeInsets.only(
                            right: 15, left: 15, top: 15, bottom: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(list[index].title,
                            style: fTextTitle),
                        SizedBox(width: 8),
                        Image.asset(
                          iArrowFilter,
                          width: 30,
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? _selectedDateRange;
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: Locale('es', 'ES'),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: dDateSelect, // Change this to your desired color
              onPrimary: const Color.fromARGB(
                  255, 18, 17, 17), // Text color on primary color
              surface: Colors.grey, // Surface color
              onSurface: Colors.black, // Text color on surface color
            ),
            dialogBackgroundColor: Colors.white, // Background color
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }
}
