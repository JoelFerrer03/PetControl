import 'package:flutter/material.dart';
import 'package:petcontrol/ui/core/tema/app_colores.dart';

class VistaPacientesAdmin extends StatelessWidget {
  const VistaPacientesAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColores.blanco,
      appBar: AppBar(
        title: const Text('Pacientes'),
      ),
      body: const Center(
        child: Text(
          'Vista de pacientes (admin)',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
