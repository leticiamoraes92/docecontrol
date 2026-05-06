import 'package:flutter/material.dart';

class TextosCustom extends StatelessWidget {
  final String seuTexto;
  final double fontSize;
  final Color fontColor;

  const TextosCustom(this.seuTexto, this.fontSize, this.fontColor);

  @override
  Widget build(BuildContext context) {
    return Text(
      seuTexto,
      maxLines: 5,
      softWrap: true,
      style: TextStyle(
        color: fontColor,
        fontSize: fontSize,
      ),
    );
  }
}
