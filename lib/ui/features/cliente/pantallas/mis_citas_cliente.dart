import 'package:flutter/material.dart';
import 'package:petcontrol/hex/infraestructura/mock/cliente_home_mock.dart';
import 'package:petcontrol/ui/core/tema/app_colores.dart';
import 'package:petcontrol/ui/core/widgets/popup_detalle.dart';
import 'package:petcontrol/ui/features/cliente/widgets/tarjeta creacion cita.dart';

class MisCitasCliente extends StatelessWidget {
  const MisCitasCliente({super.key});

  @override
  Widget build(BuildContext context) {
    final totalCitas = citasClienteMock.length;
    final totalProximas = citasClienteMock
        .where((cita) => cita.estado.toLowerCase() == 'proxima')
        .length;
    final totalMascotasConCita = citasClienteMock
        .map((cita) => cita.idMascota)
        .toSet()
        .length;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FA),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SizedBox(
        width: 62,
        height: 62,
        child: FloatingActionButton(
          onPressed: () => _abrirCreacionCita(context),
          backgroundColor: const Color(0xFF153A5F),
          foregroundColor: Colors.white,
          child: const Icon(Icons.add, size: 34),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned.fill(child: _FondoMisCitas()),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _EncabezadoMisCitas(
                    onVolver: () => Navigator.of(context).pop(),
                    onNueva: () => _abrirCreacionCita(context),
                  ),
                  const SizedBox(height: 14),
                  _ResumenCitasCliente(
                    totalCitas: totalCitas,
                    totalProximas: totalProximas,
                    totalMascotasConCita: totalMascotasConCita,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFD),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFFC7D5E2),
                        width: 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A1A2B40),
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Agenda personal',
                          style: TextStyle(
                            color: Color(0xFF21354D),
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$totalCitas citas programadas para $nombreClienteHomeMock',
                          style: const TextStyle(
                            color: Color(0xFF5D6E80),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 14),
                        for (var i = 0; i < citasClienteMock.length; i++) ...[
                          _TarjetaCitaClienteRedisenada(
                            cita: citasClienteMock[i],
                            onTap: () =>
                                _abrirDetalleCita(context, citasClienteMock[i]),
                          ),
                          if (i < citasClienteMock.length - 1)
                            const SizedBox(height: 12),
                        ],
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

class _FondoMisCitas extends StatelessWidget {
  const _FondoMisCitas();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 286,
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF112F4F),
                      AppColores.azulOscuro,
                      AppColores.azul,
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
                right: -22,
                child: _CirculoDecorativo(diametro: 126, opacidad: 0.2),
              ),
              const Positioned(
                bottom: 18,
                left: -24,
                child: _CirculoDecorativo(diametro: 98, opacidad: 0.14),
              ),
            ],
          ),
        ),
        const Expanded(child: ColoredBox(color: Color(0xFFF2F5FA))),
      ],
    );
  }
}

class _CirculoDecorativo extends StatelessWidget {
  const _CirculoDecorativo({required this.diametro, required this.opacidad});

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

class _EncabezadoMisCitas extends StatelessWidget {
  const _EncabezadoMisCitas({required this.onVolver, required this.onNueva});

  final VoidCallback onVolver;
  final VoidCallback onNueva;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _BotonEncabezadoIcono(onTap: onVolver),
            const Spacer(),
            FilledButton.icon(
              onPressed: onNueva,
              style: FilledButton.styleFrom(
                minimumSize: const Size(116, 40),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                backgroundColor: const Color(0xFF0F2843),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                side: const BorderSide(color: Color(0x88FFFFFF)),
              ),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text(
                'Nueva cita',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Mis citas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 33,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Organiza tus citas veterinarias y revisa el detalle de cada atencion.',
          style: TextStyle(
            color: Color(0xFFDCE9FF),
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

class _ResumenCitasCliente extends StatelessWidget {
  const _ResumenCitasCliente({
    required this.totalCitas,
    required this.totalProximas,
    required this.totalMascotasConCita,
  });

  final int totalCitas;
  final int totalProximas;
  final int totalMascotasConCita;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TarjetaResumen(
          etiqueta: 'Citas',
          valor: '$totalCitas',
          icono: Icons.calendar_month_outlined,
        ),
        const SizedBox(width: 10),
        _TarjetaResumen(
          etiqueta: 'Proximas',
          valor: '$totalProximas',
          icono: Icons.schedule_outlined,
        ),
        const SizedBox(width: 10),
        _TarjetaResumen(
          etiqueta: 'Mascotas',
          valor: '$totalMascotasConCita',
          icono: Icons.pets_outlined,
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
                color: Color(0xD9E6F1FF),
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

class _TarjetaCitaClienteRedisenada extends StatelessWidget {
  const _TarjetaCitaClienteRedisenada({
    required this.cita,
    required this.onTap,
  });

  final CitaClienteMock cita;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final estiloEstado = _estiloEstado(cita.estado);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 122),
          child: Ink(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFFFFF), Color(0xFFF1F5FB)],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFC9D8E7), width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCE8F4),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.calendar_month_rounded,
                        color: Color(0xFF2D5C88),
                        size: 18,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        cita.hora,
                        style: const TextStyle(
                          color: Color(0xFF274C72),
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
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
                                color: Color(0xFF1E3248),
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                height: 1,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _ChipDato(
                            texto: cita.estado,
                            fondo: estiloEstado.fondo,
                            colorTexto: estiloEstado.texto,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _ChipDato(
                            texto: cita.especieMascota,
                            fondo: const Color(0xFFDDEAF8),
                            colorTexto: const Color(0xFF2D597E),
                          ),
                          _ChipDato(
                            texto: cita.fecha,
                            fondo: const Color(0xFFEAF1FA),
                            colorTexto: const Color(0xFF4E6781),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        cita.motivo,
                        style: const TextStyle(
                          color: Color(0xFF425B75),
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          height: 1.05,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF1FA),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Text(
                          '${cita.descripcion} ${cita.veterinario} | ${cita.sede}',
                          style: const TextStyle(
                            color: Color(0xFF5B7187),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
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

class _ChipDato extends StatelessWidget {
  const _ChipDato({
    required this.texto,
    required this.fondo,
    required this.colorTexto,
  });

  final String texto;
  final Color fondo;
  final Color colorTexto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        texto,
        style: TextStyle(
          color: colorTexto,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}

_EstiloEstado _estiloEstado(String estado) {
  switch (estado.toLowerCase()) {
    case 'proxima':
      return const _EstiloEstado(
        fondo: Color(0xFFD7EAF8),
        texto: Color(0xFF2F5D86),
      );
    case 'cancelada':
      return const _EstiloEstado(
        fondo: Color(0xFFE8D3D3),
        texto: Color(0xFFA33A3A),
      );
    case 'reprogramada':
      return const _EstiloEstado(
        fondo: Color(0xFFE7DEC8),
        texto: Color(0xFF88683C),
      );
    default:
      return const _EstiloEstado(
        fondo: Color(0xFFDDEAF8),
        texto: Color(0xFF355B80),
      );
  }
}

class _EstiloEstado {
  const _EstiloEstado({required this.fondo, required this.texto});

  final Color fondo;
  final Color texto;
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
