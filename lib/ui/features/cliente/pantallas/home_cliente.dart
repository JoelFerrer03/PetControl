import 'package:flutter/material.dart';
import 'package:petcontrol/ui/core/tema/app_colores.dart';

class HomeCliente extends StatelessWidget {
  const HomeCliente({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColores.fondoBlanco,
      appBar: AppBar(
        title: const Text('Home Cliente'),
        backgroundColor: AppColores.verde,
      ),
      body: const Center(
        child: Text(
          'Bienvenido, cliente',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
