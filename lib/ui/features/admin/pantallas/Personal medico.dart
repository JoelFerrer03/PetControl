import 'package:flutter/material.dart';
import 'package:petcontrol/ui/core/tema/app_colores.dart';

class PersonalMedicoAdmin extends StatelessWidget {
  const PersonalMedicoAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColores.blanco,
      appBar: AppBar(
        title: const Text('Personal médico'),
      ),
      body: const Center(
        child: Text(
          'Vista de personal médico (admin)',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
