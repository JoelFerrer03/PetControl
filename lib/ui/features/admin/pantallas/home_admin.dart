import 'package:flutter/material.dart';
import 'package:petcontrol/ui/core/tema/app_colores.dart';
import 'package:petcontrol/ui/features/admin/pantallas/Historial medico admin.dart';
import 'package:petcontrol/ui/features/admin/pantallas/Personal medico.dart';
import 'package:petcontrol/ui/features/admin/pantallas/Vista cita admin.dart';
import 'package:petcontrol/ui/features/admin/pantallas/Vista pacientes admin.dart';
import 'package:petcontrol/ui/features/autenticacion/pantallas/bienvenida_pantalla.dart';

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColores.blanco,
      //bottomNavigationBar: _bottomNavbar(context),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 3),
                    _header(context),
                    const SizedBox(height: 16),

                    _filaEstadisticas(),

                    const SizedBox(height: 24),

                    const Text(
                      "Menu Principal",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _menuPrincipalGrid(),

                    const SizedBox(height: 24),

                    const Text(
                      "Próxima Cita",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 10),
                    _tarjetaProximaCita(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            //const BotonAtras(),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavbar(context),

    );
  }
}

Widget _header(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: const [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColores.verde,
            child: Text(
              'N',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bienvenido',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              Text(
                'Dr. Naymar Guerra',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ],
      ),
      IconButton(
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        icon: const Icon(Icons.logout),
        tooltip: 'Salir',
      ),
    ],
  );
}

Widget _filaEstadisticas() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      _tarjetaMetrica(
        icono: Icons.pets_outlined,
        numero: '24',
        etiqueta: 'Pacientes',
      ),
      const SizedBox(width: 12),
      _tarjetaMetrica(
        icono: Icons.event_note_outlined,
        numero: '8',
        etiqueta: 'Citas',
      ),
      const SizedBox(width: 12),
      _tarjetaMetrica(
        icono: Icons.group_outlined,
        numero: '5',
        etiqueta: 'Personal',
      ),
    ],
  );
}

Widget _tarjetaMetrica({

  required IconData icono,
  required String numero,
  required String etiqueta,
}) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColores.blanco,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColores.negro, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 22, color: AppColores.negro),
          const SizedBox(height: 6),
          Text(
            numero,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            etiqueta,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    )
  );
}

Widget _menuPrincipalGrid() {
  return Column(
    children: [
      Row(
        children: [
          _cardMenuPrincipal(
            icono: Icons.pets_outlined,
            titulo: 'Pacientes',
            subtitulo: 'Gestionar mascotas'
          ),
          const SizedBox(width: 15,),

          _cardMenuPrincipal(
            icono: Icons.calendar_month_outlined,
            titulo: 'Citas',
            subtitulo: 'Agendar y consultar',
          )
        ],
      ),
      const SizedBox(height: 20),
      Row(
        children: [
          
          _cardMenuPrincipal(
            icono: Icons.assignment_outlined,
            titulo: 'Historial Medico',
            subtitulo: 'Registros clinicos',
          ),

          const SizedBox(width: 12),
          _cardMenuPrincipal(
            icono: Icons.medical_services_outlined,
            titulo: 'Personal medico',
            subtitulo: 'Equipo Veterinario',
          ),

        ],
      )
    ],
  );
}

Widget _cardMenuPrincipal({
  required IconData icono,
  required String titulo,
  required String subtitulo,
}) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColores.blanco,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black54, width: 1),

      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icono, size: 34, color: AppColores.negro, fill: 0,),
          const SizedBox(height: 10),
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10,),
          Text(
            subtitulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: AppColores.textoNegro,
            ),
          )
        ],
      ),
    ),
  );
}

Widget _tarjetaProximaCita() {
  return Column(
    children: const [
      _ItemProximaCita(
        titulo: 'Freya - Vacunación',
        detalle: 'Hoy 10:30 AM - Dr. GUERRA',
      ),
      SizedBox(height: 10),
      _ItemProximaCita(
        titulo: 'Luna - Control General',
        detalle: 'Hoy 2:15 PM - Dr. GUERRA',
      ),
    ],
  );
}

class _ItemProximaCita extends StatelessWidget {
  final String titulo;
  final String detalle;

  const _ItemProximaCita({
    required this.titulo,
    required this.detalle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black54, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.favorite_border,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detalle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
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

Widget _bottomNavbar(BuildContext context) {
  return Container(
    height: 76,
    decoration: const BoxDecoration(
      color: AppColores.navbar,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const VistaPacientesAdmin()),
            );
          },
          icon: const Icon(Icons.pets, color: AppColores.negro, size: 30, fill: 0,),
          tooltip: 'Pacientes',
        ),
        IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const VistaCitaAdmin()),
            );
          },
          icon: const Icon(Icons.calendar_month_outlined, color: AppColores.negro, size: 30),
          tooltip: 'Citas',
        ),
        IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const BienvenidaPantalla()),
              (route) => false,
            );
          },
          icon: const Icon(Icons.home_outlined, color: AppColores.negro, size: 35),
          tooltip: 'Inicio',
        ),
        IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HistorialMedicoAdmin()),
            );
          },
          icon: const Icon(Icons.assignment_outlined, color: AppColores.negro, size: 30),
          tooltip: 'Historial médico',
        ),
        IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PersonalMedicoAdmin()),
            );
          },
          icon: const Icon(Icons.medical_services_outlined, color: AppColores.negro, size: 30),
          tooltip: 'Personal médico',
        ),
      ],
    ),
  );
}


