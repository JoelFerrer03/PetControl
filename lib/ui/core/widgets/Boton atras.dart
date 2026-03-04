import 'package:flutter/material.dart';

class BotonAtras extends StatelessWidget {
  const BotonAtras({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      left: 16,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back, size: 24, color: Colors.black),
      ),
    );
  }
}
