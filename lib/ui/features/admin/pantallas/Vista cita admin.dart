import 'package:flutter/material.dart';
import 'package:petcontrol/ui/core/tema/app_colores.dart';

class VistaCitaAdmin extends StatelessWidget {
  const VistaCitaAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColores.blanco,
      appBar: AppBar(
        title: const Text('Citas'),
      ),
      body: const Center(
        child: Text(
          'Vista de citas (admin)',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
