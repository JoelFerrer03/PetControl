import 'package:flutter/material.dart';
import 'package:petcontrol/ui/core/tema/app_colores.dart';
import 'package:petcontrol/ui/features/autenticacion/pantallas/login_pantalla.dart';
import 'package:petcontrol/ui/features/autenticacion/pantallas/registro_pantalla.dart';

class BienvenidaPantalla extends StatelessWidget {
  const BienvenidaPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColores.blanco,
      body: SafeArea(
        child: Column(
          children: [
            //Header
            SizedBox(
              height: 400, //Cambiar tamaño del fondo gradiante
              width: double.infinity,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColores.azulOscuro, AppColores.azul],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ClipPath(
                      clipper: CurvaClipper(),
                      child: Container(
                        color: AppColores.blanco,
                        height: 120,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/img/Logo BN.png', height: 400, fit: BoxFit.cover,),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // BODY
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Text(
                    "bienvenido a VetManager",
                    style: TextStyle(fontSize: 14, color: AppColores.negro),
                  ),
                  const SizedBox(height: 15),
                  //Boton
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPantalla(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColores.botonGris,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Iniciar Sesión",
                        style: TextStyle(
                          //fontFamily: , //preguntar a jero
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColores.botonTexto,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(child: Text("¿No tienes cuenta?")),
                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPantalla(),
                        ),
                      );
                    },
                    child: const Text(
                      "Registrate",
                      style: TextStyle(
                        //fontFamily: , //preguntar a jero
                        fontSize: 16,
                        color: AppColores.textoAzul,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurvaClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Línea vertical hasta donde empieza la curva en el lado izquierdo
    path.lineTo(0, size.height * 0.85);

    // Curva que sube hacia la derecha, generando un arco tipo “cuarto de círculo”
    // como en la referencia: más baja a la izquierda y más alta en la derecha.
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 1.0,
      size.width,
      size.height * 0.10,
    );

    // Cerramos el camino por la parte inferior
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
