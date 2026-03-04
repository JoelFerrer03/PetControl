import 'package:flutter/material.dart';
import 'package:petcontrol/hex/infraestructura/mock/citas_mock.dart';
import 'package:petcontrol/ui/core/tema/app_colores.dart';
import 'package:petcontrol/ui/core/widgets/popup_detalle.dart';
import 'package:petcontrol/ui/features/admin/widgets/tarjeta creacion cita.dart';

class VistaCitaAdmin extends StatelessWidget {
  const VistaCitaAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final alturaCurva = (size.height * 0.56).clamp(430.0, 650.0);

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
                clipper: _CurvaFondoCitasClipper(),
                child: Container(
                  color: const Color(0xFFECECEC),
                  height: alturaCurva,
                  width: double.infinity,
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 34),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _EncabezadoCitas(
                    onVolver: () => Navigator.of(context).pop(),
                    onNuevo: () => _abrirRegistroCita(context),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Citas programadas para hoy',
                    style: TextStyle(
                      color: AppColores.textoNegro,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 20),
                  for (var i = 0; i < citasHoyMock.length; i++) ...[
                    _TarjetaCita(
                      cita: citasHoyMock[i],
                      onTap: () => _abrirDetalleCitaPreview(
                        context,
                        citasHoyMock[i],
                        bloqueAgenda: 'Hoy',
                      ),
                    ),
                    if (i < citasHoyMock.length - 1) const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 22),
                  const Text(
                    'Proximas citas',
                    style: TextStyle(
                      color: AppColores.textoNegro,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      height: 1,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  for (var i = 0; i < citasProximasMock.length; i++) ...[
                    _TarjetaCita(
                      cita: citasProximasMock[i],
                      onTap: () => _abrirDetalleCitaPreview(
                        context,
                        citasProximasMock[i],
                        bloqueAgenda: 'Proxima',
                      ),
                    ),
                    if (i < citasProximasMock.length - 1)
                      const SizedBox(height: 16),
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

void _abrirRegistroCita(BuildContext context) {
  showGeneralDialog<void>(
    context: context,
    barrierLabel: 'registro_cita',
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
                child: TarjetaCreacionCita(
                  onCerrar: () => Navigator.of(dialogContext).pop(),
                  onRegistrar: (data) {
                    Navigator.of(dialogContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Cita creada para ${data.nombreMascota} (${data.fechaHoraFormateada}) - ${data.estado}',
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

void _abrirDetalleCitaPreview(
  BuildContext context,
  CitaVistaMock cita, {
  required String bloqueAgenda,
}) {
  mostrarPopupDetalle(
    context,
    ConfigPopupDetalle(
      titulo: cita.nombreMascota,
      subtitulo: 'Detalle completo de la cita',
      icono: cita.icono,
      colorAcento: cita.estadoTextColor,
      chips: <String>[cita.estado, bloqueAgenda],
      campos: <DetalleCampo>[
        DetalleCampo(etiqueta: 'Mascota', valor: cita.nombreMascota),
        DetalleCampo(etiqueta: 'Bloque', valor: bloqueAgenda),
        DetalleCampo(etiqueta: 'Hora', valor: cita.hora),
        DetalleCampo(etiqueta: 'Estado', valor: cita.estado),
        DetalleCampo(etiqueta: 'Procedimiento', valor: cita.procedimiento),
        DetalleCampo(etiqueta: 'Descripcion', valor: cita.descripcion),
      ],
    ),
  );
}

class _CurvaFondoCitasClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.19);
    path.quadraticBezierTo(
      size.width * 0.16,
      size.height * 0.36,
      size.width * 0.46,
      size.height * 0.42,
    );
    path.quadraticBezierTo(
      size.width * 0.78,
      size.height * 0.49,
      size.width,
      size.height * 0.37,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _EncabezadoCitas extends StatelessWidget {
  const _EncabezadoCitas({required this.onVolver, required this.onNuevo});

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
            size: 22,
          ),
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text(
            'Citas',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
              height: 1,
            ),
          ),
        ),
        FilledButton(
          onPressed: onNuevo,
          style: FilledButton.styleFrom(
            minimumSize: const Size(74, 30),
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 2),
            backgroundColor: AppColores.verdepacientes,
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.black87, width: 1),
            shape: const StadiumBorder(),
          ),
          child: const Text(
            '+ nuevo',
            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _TarjetaCita extends StatelessWidget {
  const _TarjetaCita({required this.cita, required this.onTap});

  final CitaVistaMock cita;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          constraints: const BoxConstraints(minHeight: 98),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFF373737), width: 1.1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: cita.cajaHoraColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(cita.icono, color: cita.iconoColor, size: 18),
                    const SizedBox(height: 3),
                    Text(
                      cita.hora,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: cita.horaColor,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          cita.nombreMascota,
                          style: const TextStyle(
                            color: Color(0xFF1D2730),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                        _ChipEstado(cita: cita),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      cita.procedimiento,
                      style: const TextStyle(
                        color: Color(0xFF5E6970),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      cita.descripcion,
                      style: const TextStyle(
                        color: Color(0xFF5E6970),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.05,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChipEstado extends StatelessWidget {
  const _ChipEstado({required this.cita});

  final CitaVistaMock cita;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: cita.estadoBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        cita.estado,
        style: TextStyle(
          color: cita.estadoTextColor,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}
