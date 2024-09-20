import 'package:flutter/material.dart';

import '../constants/colors.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF339900),
  onPrimary: Color(0xFFFFFFFF),
  secondary: Color(0xFF6EAEE7),
  onSecondary: Color(0xFFFFFFFF),
  error: Color(0xFFBA1A1A),
  onError: Color(0xFFFFFFFF),
  background: Color(0xFFFFFFFF),
  onBackground: Color(0xFF1A1C18),
  shadow: Color(0xFF000000),
  outlineVariant: Color(0xFFC2C8BC),
  surface: Color(0xFFF9FAF3),
  onSurface: Color(0xFF1A1C18),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF339900),
  onPrimary: Color(0xFFFFFFFF),
  secondary: Color(0xFF6EAEE7),
  onSecondary: Color(0xFFFFFFFF),
  error: Color(0xFFBA1A1A),
  onError: Color(0xFFFFFFFF),
  background: Color(0xFFFCFDF6),
  onBackground: Color(0xFF1A1C18),
  shadow: Color(0xFF000000),
  outlineVariant: Color(0xFFC2C8BC),
  surface: Color(0xFFF9FAF3),
  onSurface: Color(0xFF1A1C18),
);

//Dashboard
const dModalInternet = TextStyle(
  fontSize: 18,
  color: Colors.black,
  fontFamily: 'Lato',
  letterSpacing: 0.1,
  fontWeight: FontWeight.w400,
  decorationThickness: 0.5,
);

const dModalErrorTitle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w400,
    fontSize: 18,
    fontFamily: 'Lato');

const dUserError = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 24,
    fontFamily: 'Knockout');

const dBotonTextError = TextStyle(
    color: Colors.white,
    fontFamily: 'Lato',
    fontWeight: FontWeight.w700,
    fontSize: 16);

const dTitleUser = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 24,
    fontFamily: 'Knockout');

const dTitleEmail = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w400,
    fontSize: 18,
    fontFamily: 'Lato');

const dBotonTextOut = TextStyle(
    color: Colors.white,
    fontFamily: 'Lato',
    fontWeight: FontWeight.w700,
    fontSize: 16);

const dTitleModal = TextStyle(
  fontSize: 30,
  color: Colors.black,
  fontFamily: 'knockout',
);

ButtonStyle dModalButton = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(color: Colors.black),
    )));

ButtonStyle dErrorUserButton = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(color: Colors.black),
    )));

ButtonStyle dOutUserButton = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(color: Colors.black),
    )));

//Orden de compra
const tOrdenC = TextStyle(
  fontSize: 18,
  color: Colors.black,
  fontWeight: FontWeight.w700,
  fontFamily: 'knockout',
);

const tTabPendientes = TextStyle(
  fontFamily: 'Lato',
  fontSize: 14,
  color: Colors.white,
  fontWeight: FontWeight.w600,
);

const tTabHistorial = TextStyle(
  fontFamily: 'Lato',
  fontSize: 14,
  color: Colors.black,
  fontWeight: FontWeight.w600,
);

//Pendientes
const tituloStyle = TextStyle(
  fontSize: 12,
  color: tTitleCard,
  height: 1.3,
  fontWeight: FontWeight.w200,
  fontFamily: 'Lato',
);

const tsubStyle = TextStyle(
  fontSize: 15,
  color: Colors.black87,
  height: 1.3,
  fontWeight: FontWeight.w200,
  fontFamily: 'knockout',
  letterSpacing: 0.5,
);

const tfirtsLine = TextStyle(
  fontSize: 15,
  color: Colors.black87,
  height: 1.3,
  fontWeight: FontWeight.w200,
  fontFamily: 'knockout',
  letterSpacing: 0.5,
);

//Detalle - Requerimiento
const tDetalle = TextStyle(
  fontSize: 16,
  fontFamily: 'Roman',
  color: Colors.black,
  fontWeight: FontWeight.w700,
);

const reqText = TextStyle(
  fontSize: 18,
  fontFamily: 'Lato',
  color: Colors.black,
  fontWeight: FontWeight.w700,
);

const reqTextNull = TextStyle(
  fontSize: 1,
  fontFamily: 'Lato',
  color: Colors.black,
);

const pText = TextStyle(
  fontSize: 15,
  fontFamily: 'Lato',
  color: Colors.black,
  fontWeight: FontWeight.w800,
);

const mText = TextStyle(
  fontSize: 15,
  fontFamily: 'Lato',
);

const pTextfecha = TextStyle(
  fontSize: 15,
  fontFamily: 'Lato',
);

const pTitulo = TextStyle(
  fontSize: 14,
  fontFamily: 'Lato',
  fontWeight: FontWeight.w700,
);

//Detalle - Proveedor
const subText = TextStyle(
  fontSize: 14,
  fontFamily: 'Lato',
  color: Colors.black,
);

//Notificaciones
const nTituloS = TextStyle(
  fontSize: 14,
  fontFamily: 'Lato',
  fontWeight: FontWeight.w700,
  color: Colors.black,
);

const nMensajeS = TextStyle(
  fontSize: 12,
  fontFamily: 'Lato',
  fontWeight: FontWeight.w400,
  color: Colors.black,
);

//Filter
const fTextTitle =
    TextStyle(color: Colors.black, fontFamily: 'Roman', fontSize: 14);

//Graficas
const gTitleStyleDashboard = TextStyle(
    color: Colors.black,
    fontFamily: 'Lato',
    fontSize: 16,
    fontWeight: FontWeight.w900);

const gTitleAprobado =
    TextStyle(fontSize: 14, fontFamily: 'Lato', fontWeight: FontWeight.w700);
const gDetalleAprobado = TextStyle(
    fontSize: 12,
    color: Color(0xff7F7F7F),
    fontFamily: 'Lato',
    fontWeight: FontWeight.w400);

const gTitleRejected =
    TextStyle(fontSize: 14, fontFamily: 'Lato', fontWeight: FontWeight.w700);
const gDetalleDesaprobados = TextStyle(
    fontSize: 12,
    color: Color(0xff7F7F7F),
    fontFamily: 'Lato',
    fontWeight: FontWeight.w400);

const gTitlePending =
    TextStyle(fontSize: 14, fontFamily: 'Lato', fontWeight: FontWeight.w700);
const gDetallePendiente = TextStyle(
    fontSize: 12,
    color: Color(0xff7F7F7F),
    fontFamily: 'Lato',
    fontWeight: FontWeight.w400);


ThemeData lightMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: lightColorScheme,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
        lightColorScheme.primary, // Slightly darker shade for the button
      ),
      foregroundColor:
          MaterialStateProperty.all<Color>(Colors.white), // text color
      elevation: MaterialStateProperty.all<double>(5.0), // shadow
      padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(horizontal: 20, vertical: 18)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Adjust as needed
        ),
      ),
    ),
  ),
);

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: darkColorScheme,
);
