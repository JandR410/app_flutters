import 'package:flutter/material.dart';
import '../utils/constants/text_strings.dart';

class DashboardCategoriesModel{
  final String title;
  final VoidCallback? onPress;

  DashboardCategoriesModel(this.title,  this.onPress,);

  static List<DashboardCategoriesModel> list = [
    DashboardCategoriesModel(fTitleProveedores, null),
    DashboardCategoriesModel(fTitleClientes, null),
    DashboardCategoriesModel(fTitleOC, null),
    DashboardCategoriesModel(fTitleRango, null),
  ];
}