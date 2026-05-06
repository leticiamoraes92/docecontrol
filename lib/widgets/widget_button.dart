import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;

  const Buttons(this.texto, {super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(texto),
    );
  }
}