import 'text_strings.dart';

class OnboardContent {
  String image;
  String text;
  String descripcion;

  OnboardContent(
      {required this.image, required this.text, required this.descripcion});
}

List<OnboardContent> contents = [
  OnboardContent(
    image: "assets/images/1.png",
    text: oTitulo1,
    descripcion: oDescrip1,
  ),
  OnboardContent(
    image: "assets/images/4.png",
    text: oTitulo2,
    descripcion: oDescrip2,
  ),
  OnboardContent(
    image: "assets/images/2.png",
    text: oTitulo3,
    descripcion: oDescrip3,
  ),
  OnboardContent(
    image: "assets/images/3.png",
    text: oTitulo4,
    descripcion: oDescrip4,
  ),
];
