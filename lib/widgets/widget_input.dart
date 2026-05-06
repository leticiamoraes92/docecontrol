import 'package:flutter/material.dart';

class InputTextos extends StatelessWidget {
  final String rotulo;
  final TextEditingController controller;
  final TextInputType tipo;
  final int maxLines;

  final Function(String)? onChanged;

  const InputTextos(
      this.rotulo, {
        super.key,
        required this.controller,
        this.tipo = TextInputType.text,
        this.maxLines = 1,
        this.onChanged,
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: tipo,
      maxLines: maxLines,

      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: rotulo,
        border: OutlineInputBorder(),
      ),
    );
  }
}