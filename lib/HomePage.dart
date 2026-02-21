import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Veterinaria'),
      ),
      body: const Center(
        child: Text('Pantalla principal'),
      ),
    );
  }
}