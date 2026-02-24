import 'package:flutter/material.dart';

class RegisterPantalla extends StatelessWidget {
  const RegisterPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrate')),
      body: const SafeArea(
        child: Center(
          child: Text('Pantalla de Register'),
        ),
      ),
    );
  }
}