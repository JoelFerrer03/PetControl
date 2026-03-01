import 'package:flutter/material.dart';
import 'package:petcontrol/ui/core/tema/app_colores.dart';

class BotonAtras extends StatelessWidget {
  const BotonAtras({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      left: 16,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            color: AppColores.botonPrincipal,
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
    );
  }
}