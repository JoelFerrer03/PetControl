import 'package:flutter/material.dart';
import 'package:petcontrol/ui/core/tema/app_colores.dart';
import 'package:petcontrol/ui/features/autenticacion/widgets/formulario_registro.dart';

class RegistroPantalla extends StatelessWidget {
  const RegistroPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColores.blanco,
      body: Stack(
        children: [
          // Fondo base blanco
          Container(color: AppColores.blanco),

          // Franja superior con degradado verde y el logo
          SizedBox(
            height: 260,
            width: double.infinity,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColores.azulOscuro,
                    AppColores.azulOscuro,
                    AppColores.azul,
                  ],
                  stops: [0.0, 0.009, 1.0],
                ),
              ),
              child: Center(
                child: SizedBox(
                  width: 298.79,
                  height: 122.67,
                  child: Image.asset(
                    'assets/img/Logo BN.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          // Contenedor claro que se superpone al fondo verde, con bordes superiores redondeados
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.77,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColores.azulOscuro,
                    AppColores.azulOscuro,
                    AppColores.azul,
                  ],
                  stops: [0.0, 0.009, 1.0],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                decoration: const BoxDecoration(
                  color: AppColores.fondoBlanco,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: const SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
                  child: FormularioRegistro(),
                ),
              ),
            ),
          ),
          
          // Boton para volver atras
          Positioned(
            top: 16,
            left: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: AppColores.botonGris, //color del boton
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back,
                  size: 22,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
