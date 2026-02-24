import 'package:flutter/material.dart';

class LoginPantalla extends StatelessWidget {
  const LoginPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: const SafeArea(
        child: Center(
          child: Text('Pantalla de login'),
        ),
      ),
    );
  }
}