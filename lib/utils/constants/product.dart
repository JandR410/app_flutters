import 'package:ordencompra/utils/constants/text_strings.dart';

class Product {
  Product({
    required this.id,
    required this.title,
    required this.description,
    this.isExpanded = false,
  });

  int id;
  String title;
  String description;
  bool isExpanded;

  static List<Product> generateItems(int numberOfItems) {
    return List<Product>.generate(numberOfItems, (int index) {
      return Product(
        id: index,
        title: tProveedor,
        description: 'Está é a descrição do produto ',
      );
    });
  }
}