import 'package:flutter/material.dart';
import 'package:petcontrol/ui/core/tema/app_colores.dart';
import 'package:petcontrol/ui/features/admin/widgets/tarjeta creacion paciente.dart';

class VistaPacientesAdmin extends StatelessWidget {
  const VistaPacientesAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final alturaCurva = (size.height * 0.66).clamp(560.0, 760.0);
    return Scaffold(
      backgroundColor: const Color(0xFFECECEC),
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned.fill(child: ColoredBox(color: Color(0xFFECECEC))),
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [
                      AppColores.verdepacientes,
                      AppColores.verdepacientes,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipPath(
                clipper: CurvaClipper(),
                child: Container(
                  color: const Color(0xFFECECEC),
                  height: alturaCurva,
                  width: double.infinity,
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Encabezado(
                    onVolver: () => Navigator.of(context).pop(),
                    onNuevo: () => _abrirRegistroPaciente(context),
                  ),
                  const SizedBox(height: 20),
                  const _BuscadorPacientes(),
                  const SizedBox(height: 20),
                  for (var i = 0; i < _pacientes.length; i++) ...[
                    _TarjetaPaciente(paciente: _pacientes[i]),
                    if (i < _pacientes.length - 1) const SizedBox(height: 30),
                  ],
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
    path.moveTo(0, size.height * 0.33);
    path.quadraticBezierTo(
      size.width * 0.22,
      size.height * 0.46,
      size.width * 0.52,
      size.height * 0.55,
    );
    path.quadraticBezierTo(
      size.width * 0.78,
      size.height * 0.64,
      size.width,
      size.height * 0.52,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

void _abrirRegistroPaciente(BuildContext context) {
  showGeneralDialog<void>(
    context: context,
    barrierLabel: 'registro_paciente',
    barrierColor: Colors.black38,
    barrierDismissible: true,
    transitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Material(
              type: MaterialType.transparency,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: TarjetaCreacionPaciente(
                  onCerrar: () => Navigator.of(dialogContext).pop(),
                  onRegistrar: (data) {
                    Navigator.of(dialogContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Paciente ${data.nombre} registrado (${data.sexo})',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curva = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curva,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.97, end: 1).animate(curva),
          child: child,
        ),
      );
    },
  );
}

class _Encabezado extends StatelessWidget {
  const _Encabezado({required this.onVolver, required this.onNuevo});

  final VoidCallback onVolver;
  final VoidCallback onNuevo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onVolver,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: 20,
          ),
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text(
            'Pacientes',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
        ),
        FilledButton(
          onPressed: onNuevo,
          style: FilledButton.styleFrom(
            minimumSize: const Size(76, 28),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            backgroundColor: AppColores.verdepacientes,
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.black87, width: 1),
            shape: const StadiumBorder(),
          ),
          child: const Text(
            '+ nuevo',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _BuscadorPacientes extends StatelessWidget {
  const _BuscadorPacientes();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: TextField(
        cursorColor: AppColores.negro,
        decoration: InputDecoration(
          hintText: 'Buscar por nombre o dueño...',
          hintStyle: const TextStyle(color: Color(0xFF5C646A), fontSize: 16),
          prefixIcon: const Icon(
            Icons.search,
            size: 20,
            color: Color(0xFF5C646A),
          ),
          filled: true,
          fillColor: const Color(0xFFEAEAEA),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black87, width: 1.05),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black, width: 1.25),
          ),
        ),
      ),
    );
  }
}

class _TarjetaPaciente extends StatelessWidget {
  const _TarjetaPaciente({required this.paciente});

  final _PacienteVista paciente;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 96),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE3E3E3),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: const Color(0xFF4B4B4B), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFD2E2DB),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.pets_outlined,
              color: Color(0xFF14916A),
              size: 19,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      paciente.nombre,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF222222),
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 1.8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFBFE4D9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        paciente.especie,
                        style: const TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D7C62),
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  paciente.raza,
                  style: const TextStyle(
                    color: Color(0xFF646E74),
                    fontSize: 12.8,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${paciente.edad} años | ${paciente.peso} kg | ${paciente.dueno}',
                  style: const TextStyle(
                    color: Color(0xFF646E74),
                    fontSize: 12.8,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PacienteVista {
  const _PacienteVista({
    required this.nombre,
    required this.especie,
    required this.raza,
    required this.edad,
    required this.peso,
    required this.dueno,
  });

  final String nombre;
  final String especie;
  final String raza;
  final int edad;
  final int peso;
  final String dueno;
}

const _pacientes = <_PacienteVista>[
  _PacienteVista(
    nombre: 'Luna',
    especie: 'Perro',
    raza: 'Golden Retriever',
    edad: 3,
    peso: 28,
    dueno: 'Maria Garcia',
  ),
  _PacienteVista(
    nombre: 'Luna',
    especie: 'Perro',
    raza: 'Golden Retriever',
    edad: 3,
    peso: 28,
    dueno: 'Maria Garcia',
  ),
  _PacienteVista(
    nombre: 'Luna',
    especie: 'Perro',
    raza: 'Golden Retriever',
    edad: 3,
    peso: 28,
    dueno: 'Maria Garcia',
  ),
  _PacienteVista(
    nombre: 'Luna',
    especie: 'Perro',
    raza: 'Golden Retriever',
    edad: 3,
    peso: 28,
    dueno: 'Maria Garcia',
  ),
  _PacienteVista(
    nombre: 'Luna',
    especie: 'Perro',
    raza: 'Golden Retriever',
    edad: 3,
    peso: 28,
    dueno: 'Maria Garcia',
  ),
];
