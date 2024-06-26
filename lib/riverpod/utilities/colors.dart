import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final primaryColor = Provider<Color>((ref) {
  return const Color(0xFF0750a4);
});

final primaryLight = Provider<Color>((ref) {
  return Color(0xFFBCDBFE);
});

final secondaryColor = Provider<Color>((ref) {
  return const Color(0xff108d7c );
});

final secondaryLight = Provider<Color>((ref) {
  return Color.fromARGB(255, 184, 231, 225);
});

final positiveColor = Provider<Color>((ref) {
  return const Color(0xff108d7c );
});

final negativeColor = Provider<Color>((ref) {
  return Color.fromARGB(255, 231, 76, 76);
});

final offwhite = Provider<Color>((ref) {
  return Color.fromARGB(255, 243, 254, 255);
});

final truewhite = Provider<Color>((ref) {
  return Color.fromARGB(255, 255, 255, 255);
});

final truegray = Provider<Color>((ref) {
  return const Color(0xFF7E7E7E);
});

final brightGray = Provider<Color>((ref) {
  return const Color(0xFFEEEEEE);
});

final darkGray = Provider<Color>((ref) {
  return Color.fromARGB(255, 49, 49, 49);
});

final trueOrange = Provider<Color>((ref) {
  return Color.fromARGB(255, 237, 99, 36);
});

final lightOrange = Provider<Color>((ref) {
  return Color.fromARGB(255, 250, 230, 219);
});

final trueyellow = Provider<Color>((ref) {
  return Color.fromARGB(255, 223, 212, 3);
});

final darkyellow = Provider<Color>((ref) {
  return Color.fromARGB(255, 181, 172, 5);
});

final lightyellow = Provider<Color>((ref) {
  return Color.fromARGB(255, 255, 253, 207);
});




final statuspaymentcolor = StateProvider<Color>((ref) {
  return const Color(0xFFFDD835) ;
});