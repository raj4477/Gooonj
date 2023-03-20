import 'package:flutter/material.dart';

Color mainRed = Color(0xffEB455F);
Color mainBlue = Color(0xff1C1B1F);
Color floatingAction = Color(0xff162942);
Color textgrey=Color(0xff595959);



const BoxShadow primaryShadow =
BoxShadow(blurRadius: 2, color: Color(0x2F000000), spreadRadius: 0,
    offset: Offset(0,5)
);

const BoxShadow containerShadow = BoxShadow(
  offset: Offset(0, 2),
  blurRadius: 6,
  color: Color(0x2F000000),
);

final BoxDecoration containerDeco=BoxDecoration(
    borderRadius: BorderRadius.circular(24),
    boxShadow: const [containerShadow],
    color: Colors.white);