import 'package:flutter/material.dart';
import 'package:petcontrol/ui/core/rutas/app_router.dart';
import 'package:petcontrol/ui/core/rutas/rutas.dart';
import 'package:petcontrol/ui/core/tema/tema_app.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: temaApp,
      initialRoute: Rutas.bienvenidaPage,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
