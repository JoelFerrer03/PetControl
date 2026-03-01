import 'package:flutter/material.dart';
import 'package:petcontrol/ui/core/tema/app_colores.dart';

class HistorialMedicoAdmin extends StatelessWidget {
  const HistorialMedicoAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColores.blanco,
      appBar: AppBar(
        title: const Text('Historial médico'),
      ),
      body: const Center(
        child: Text(
          'Vista de historial médico (admin)',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
