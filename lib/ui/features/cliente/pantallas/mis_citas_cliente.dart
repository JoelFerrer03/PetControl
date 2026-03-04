import 'package:flutter/material.dart';
import 'package:petcontrol/hex/infraestructura/mock/cliente_home_mock.dart';
import 'package:petcontrol/ui/core/tema/app_colores.dart';
import 'package:petcontrol/ui/core/widgets/popup_detalle.dart';
import 'package:petcontrol/ui/features/cliente/widgets/tarjeta creacion cita.dart';
import 'package:petcontrol/ui/features/cliente/widgets/tarjetas_cliente.dart';

class MisCitasCliente extends StatelessWidget {
  const MisCitasCliente({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final alturaCurva = (size.height * 0.78).clamp(560.0, 820.0);

    return Scaffold(
      backgroundColor: const Color(0xFFECECEC),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SizedBox(
        width: 62,
        height: 62,
        child: FloatingActionButton(
          onPressed: () => _abrirCreacionCita(context),
          backgroundColor: AppColores.azulOscuro,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add, size: 34),
        ),
      ),
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
                    colors: [AppColores.azulOscuro, AppColores.azul],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipPath(
                clipper: _CurvaClienteClipper(),
                child: Container(
                  color: const Color(0xFFECECEC),
                  height: alturaCurva,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                      const SizedBox(width: 4),
                      const Expanded(
                        child: Text(
                          'Mis citas',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${citasClienteMock.length} programadas para $nombreClienteHomeMock',
                    style: const TextStyle(
                      color: Color(0xFFDCE8FF),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      itemCount: citasClienteMock.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final cita = citasClienteMock[index];
                        return TarjetaCitaCliente(
                          cita: cita,
                          onTap: () => _abrirDetalleCita(context, cita),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurvaClienteClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.22);
    path.quadraticBezierTo(
      size.width * 0.16,
      size.height * 0.38,
      size.width * 0.46,
      size.height * 0.44,
    );
    path.quadraticBezierTo(
      size.width * 0.79,
      size.height * 0.52,
      size.width,
      size.height * 0.38,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

void _abrirCreacionCita(BuildContext context) {
  showGeneralDialog<void>(
    context: context,
    barrierLabel: 'crear_cita_cliente',
    barrierDismissible: true,
    barrierColor: Colors.black38,
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
                child: TarjetaCreacionCita(
                  onCerrar: () => Navigator.of(dialogContext).pop(),
                  onRegistrar: (data) {
                    Navigator.of(dialogContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Cita para ${data.nombreMascota} creada (${data.fechaHoraFormateada})',
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

void _abrirDetalleCita(BuildContext context, CitaClienteMock cita) {
  mostrarPopupDetalle(
    context,
    ConfigPopupDetalle(
      titulo: cita.nombreMascota,
      subtitulo: 'Detalle completo de cita',
      icono: Icons.calendar_month_outlined,
      colorAcento: const Color(0xFF2D7C62),
      chips: <String>[cita.estado, cita.especieMascota],
      campos: <DetalleCampo>[
        DetalleCampo(etiqueta: 'Mascota', valor: cita.nombreMascota),
        DetalleCampo(etiqueta: 'Especie', valor: cita.especieMascota),
        DetalleCampo(etiqueta: 'Fecha', valor: cita.fecha),
        DetalleCampo(etiqueta: 'Hora', valor: cita.hora),
        DetalleCampo(etiqueta: 'Motivo', valor: cita.motivo),
        DetalleCampo(etiqueta: 'Estado', valor: cita.estado),
        DetalleCampo(etiqueta: 'Veterinario', valor: cita.veterinario),
        DetalleCampo(etiqueta: 'Sede', valor: cita.sede),
        DetalleCampo(etiqueta: 'Descripcion', valor: cita.descripcion),
        const DetalleCampo(
          etiqueta: 'Propietario',
          valor: nombreClienteHomeMock,
        ),
      ],
    ),
  );
}
