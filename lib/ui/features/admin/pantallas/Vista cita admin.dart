import 'package:flutter/material.dart';
import 'package:petcontrol/hex/infraestructura/mock/citas_mock.dart';
import 'package:petcontrol/ui/core/tema/app_colores.dart';
import 'package:petcontrol/ui/core/widgets/popup_detalle.dart';
import 'package:petcontrol/ui/features/admin/widgets/tarjeta creacion cita.dart';

class VistaCitaAdmin extends StatelessWidget {
  const VistaCitaAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final totalHoy = citasHoyMock.length;
    final totalProximas = citasProximasMock.length;
    final confirmadas = citasHoyMock
        .where((cita) => cita.estado.toLowerCase() == 'confirmada')
        .length;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F2),
      floatingActionButton: SizedBox(
        width: 62,
        height: 62,
        child: FloatingActionButton(
          onPressed: () => _abrirRegistroCita(context),
          backgroundColor: const Color(0xFF1E6246),
          foregroundColor: Colors.white,
          child: const Icon(Icons.add, size: 34),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned.fill(child: _FondoCitas()),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _EncabezadoCitas(
                    onVolver: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(height: 14),
                  _ResumenCitas(
                    totalHoy: totalHoy,
                    totalProximas: totalProximas,
                    confirmadas: confirmadas,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FBF9),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFFC0D2C8),
                        width: 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A183325),
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Agenda de citas',
                          style: TextStyle(
                            color: Color(0xFF22362C),
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${totalHoy + totalProximas} registros visibles',
                          style: const TextStyle(
                            color: Color(0xFF617468),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _SeccionAgenda(
                          titulo: 'Programadas para hoy',
                          cantidad: totalHoy,
                          citas: citasHoyMock,
                          bloqueAgenda: 'Hoy',
                        ),
                        const SizedBox(height: 12),
                        const Divider(color: Color(0xFFD8E4DE), thickness: 1),
                        const SizedBox(height: 12),
                        _SeccionAgenda(
                          titulo: 'Proximas citas',
                          cantidad: totalProximas,
                          citas: citasProximasMock,
                          bloqueAgenda: 'Proxima',
                        ),
                      ],
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

class _FondoCitas extends StatelessWidget {
  const _FondoCitas();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 280,
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1A6549),
                      AppColores.verdepacientes,
                      Color(0xFF72BE8D),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(38),
                    bottomRight: Radius.circular(38),
                  ),
                ),
              ),
              const Positioned(
                top: -34,
                right: -24,
                child: _CirculoDecorativoCitas(diametro: 126, opacidad: 0.2),
              ),
              const Positioned(
                bottom: 18,
                left: -24,
                child: _CirculoDecorativoCitas(diametro: 96, opacidad: 0.14),
              ),
            ],
          ),
        ),
        const Expanded(child: ColoredBox(color: Color(0xFFF1F5F2))),
      ],
    );
  }
}

class _CirculoDecorativoCitas extends StatelessWidget {
  const _CirculoDecorativoCitas({
    required this.diametro,
    required this.opacidad,
  });

  final double diametro;
  final double opacidad;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diametro,
      height: diametro,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: opacidad),
        shape: BoxShape.circle,
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

class _EncabezadoCitas extends StatelessWidget {
  const _EncabezadoCitas({required this.onVolver});

  final VoidCallback onVolver;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BotonEncabezadoIcono(onTap: onVolver),
        const SizedBox(height: 12),
        const Text(
          'Citas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 33,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Visualiza programacion diaria y seguimiento de agenda en tiempo real.',
          style: TextStyle(
            color: Color(0xFFE8F8EE),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _BotonEncabezadoIcono extends StatelessWidget {
  const _BotonEncabezadoIcono({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Ink(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0x22FFFFFF),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: const Color(0x55FFFFFF)),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }
}

class _ResumenCitas extends StatelessWidget {
  const _ResumenCitas({
    required this.totalHoy,
    required this.totalProximas,
    required this.confirmadas,
  });

  final int totalHoy;
  final int totalProximas;
  final int confirmadas;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TarjetaResumen(
          etiqueta: 'Hoy',
          valor: '$totalHoy',
          icono: Icons.today_outlined,
        ),
        const SizedBox(width: 10),
        _TarjetaResumen(
          etiqueta: 'Proximas',
          valor: '$totalProximas',
          icono: Icons.event_note_outlined,
        ),
        const SizedBox(width: 10),
        _TarjetaResumen(
          etiqueta: 'Confirmadas',
          valor: '$confirmadas',
          icono: Icons.check_circle_outline,
        ),
      ],
    );
  }
}

class _TarjetaResumen extends StatelessWidget {
  const _TarjetaResumen({
    required this.etiqueta,
    required this.valor,
    required this.icono,
  });

  final String etiqueta;
  final String valor;
  final IconData icono;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0x2FFFFFFF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x54FFFFFF)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icono, color: Colors.white, size: 18),
            const SizedBox(height: 8),
            Text(
              valor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              etiqueta,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xDBF4FFF7),
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SeccionAgenda extends StatelessWidget {
  const _SeccionAgenda({
    required this.titulo,
    required this.cantidad,
    required this.citas,
    required this.bloqueAgenda,
  });

  final String titulo;
  final int cantidad;
  final List<CitaVistaMock> citas;
  final String bloqueAgenda;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                titulo,
                style: const TextStyle(
                  color: Color(0xFF2A3F34),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFDDEDE5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$cantidad',
                style: const TextStyle(
                  color: Color(0xFF2D7C62),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < citas.length; i++) ...[
          _TarjetaCita(
            cita: citas[i],
            onTap: () => _abrirDetalleCitaPreview(
              context,
              citas[i],
              bloqueAgenda: bloqueAgenda,
            ),
          ),
          if (i < citas.length - 1) const SizedBox(height: 12),
        ],
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
        borderRadius: BorderRadius.circular(18),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 112),
          child: Ink(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFFFFF), Color(0xFFF0F7F3)],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFC7D8CE), width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: cita.cajaHoraColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(cita.icono, color: cita.iconoColor, size: 19),
                      const SizedBox(height: 4),
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
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              cita.nombreMascota,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF1E3027),
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                height: 1,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _ChipEstado(cita: cita),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        cita.procedimiento,
                        style: const TextStyle(
                          color: Color(0xFF4B5F55),
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F2ED),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Text(
                          cita.descripcion,
                          style: const TextStyle(
                            color: Color(0xFF587066),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 1.15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: cita.estadoBgColor,
        borderRadius: BorderRadius.circular(12),
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
