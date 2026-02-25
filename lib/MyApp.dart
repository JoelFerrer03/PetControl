import 'package:flutter/material.dart';
import 'package:petcontrol/ui/core/tema/tema_app.dart';
import 'package:petcontrol/ui/features/autenticacion/pantallas/bienvenida_pantalla.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: temaApp,
      home: const BienvenidaPantalla(),
    );
  }
}