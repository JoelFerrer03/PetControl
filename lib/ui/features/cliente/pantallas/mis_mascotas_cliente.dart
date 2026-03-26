import 'package:flutter/material.dart';
import 'package:petcontrol/hex/infraestructura/mock/cliente_home_mock.dart';
import 'package:petcontrol/ui/core/tema/app_colores.dart';
import 'package:petcontrol/ui/core/widgets/popup_detalle.dart';
import 'package:petcontrol/ui/features/cliente/widgets/tarjeta creacion paciente.dart';

class MisMascotasCliente extends StatelessWidget {
  const MisMascotasCliente({super.key});

  @override
  Widget build(BuildContext context) {
    final totalMascotas = mascotasClienteMock.length;
    final totalEspecies = mascotasClienteMock
        .map((mascota) => mascota.especie.toLowerCase())
        .toSet()
        .length;
    final proximaVacuna = _proximaVacunaCercana(mascotasClienteMock);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FA),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SizedBox(
        width: 62,
        height: 62,
        child: FloatingActionButton(
          onPressed: () => _abrirRegistroMascota(context),
          backgroundColor: const Color(0xFF153A5F),
          foregroundColor: Colors.white,
          child: const Icon(Icons.add, size: 34),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned.fill(child: _FondoMisMascotas()),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _EncabezadoMisMascotas(
                    onVolver: () => Navigator.of(context).pop(),
                    onNueva: () => _abrirRegistroMascota(context),
                  ),
                  const SizedBox(height: 14),
                  _ResumenMascotasCliente(
                    totalMascotas: totalMascotas,
                    totalEspecies: totalEspecies,
                    proximaVacuna: proximaVacuna,
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
                          'Mis mascotas',
                          style: TextStyle(
                            color: Color(0xFF21354D),
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$totalMascotas registradas a nombre de $nombreClienteHomeMock',
                          style: const TextStyle(
                            color: Color(0xFF5D6E80),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 14),
                        for (
                          var i = 0;
                          i < mascotasClienteMock.length;
                          i++
                        ) ...[
                          _TarjetaMascotaClienteRedisenada(
                            mascota: mascotasClienteMock[i],
                            onTap: () => _abrirDetalleMascota(
                              context,
                              mascotasClienteMock[i],
                            ),
                          ),
                          if (i < mascotasClienteMock.length - 1)
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

class _FondoMisMascotas extends StatelessWidget {
  const _FondoMisMascotas();

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
                      Color(0xFF0F3457),
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
                child: _CirculoDecorativoMascotas(diametro: 126, opacidad: 0.2),
              ),
              const Positioned(
                bottom: 18,
                left: -24,
                child: _CirculoDecorativoMascotas(diametro: 98, opacidad: 0.14),
              ),
            ],
          ),
        ),
        const Expanded(child: ColoredBox(color: Color(0xFFF2F5FA))),
      ],
    );
  }
}

class _CirculoDecorativoMascotas extends StatelessWidget {
  const _CirculoDecorativoMascotas({
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

class _EncabezadoMisMascotas extends StatelessWidget {
  const _EncabezadoMisMascotas({required this.onVolver, required this.onNueva});

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
                minimumSize: const Size(136, 40),
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
                'Nueva mascota',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Mis mascotas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 33,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Consulta sus datos clinicos, vacunas y estado general en un solo lugar.',
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

class _ResumenMascotasCliente extends StatelessWidget {
  const _ResumenMascotasCliente({
    required this.totalMascotas,
    required this.totalEspecies,
    required this.proximaVacuna,
  });

  final int totalMascotas;
  final int totalEspecies;
  final String proximaVacuna;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TarjetaResumen(
          etiqueta: 'Mascotas',
          valor: '$totalMascotas',
          icono: Icons.pets_outlined,
        ),
        const SizedBox(width: 10),
        _TarjetaResumen(
          etiqueta: 'Especies',
          valor: '$totalEspecies',
          icono: Icons.category_outlined,
        ),
        const SizedBox(width: 10),
        _TarjetaResumen(
          etiqueta: 'Prox. vacuna',
          valor: proximaVacuna,
          icono: Icons.vaccines_outlined,
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

class _TarjetaMascotaClienteRedisenada extends StatelessWidget {
  const _TarjetaMascotaClienteRedisenada({
    required this.mascota,
    required this.onTap,
  });

  final MascotaClienteMock mascota;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconoEspecie = _iconoEspecie(mascota.especie);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 126),
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
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCE8F4),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        iconoEspecie,
                        color: const Color(0xFF2D5C88),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mascota.nombre,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF1E3248),
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _ChipDato(
                                texto: mascota.especie,
                                fondo: const Color(0xFFDDEAF8),
                                colorTexto: const Color(0xFF2D597E),
                              ),
                              _ChipDato(
                                texto: mascota.raza,
                                fondo: const Color(0xFFEAF1FA),
                                colorTexto: const Color(0xFF4E6781),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF72869B),
                      size: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _ChipDato(
                      texto: mascota.edad,
                      fondo: const Color(0xFFEAF1FA),
                      colorTexto: const Color(0xFF4E6781),
                    ),
                    _ChipDato(
                      texto: mascota.peso,
                      fondo: const Color(0xFFEAF1FA),
                      colorTexto: const Color(0xFF4E6781),
                    ),
                    _ChipDato(
                      texto: 'Vacuna: ${mascota.proximaVacuna}',
                      fondo: const Color(0xFFEAF1FA),
                      colorTexto: const Color(0xFF4E6781),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconoEspecie(String especie) {
    switch (especie.toLowerCase()) {
      case 'gato':
        return Icons.pets_rounded;
      case 'conejo':
        return Icons.cruelty_free_outlined;
      default:
        return Icons.pets_outlined;
    }
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

String _proximaVacunaCercana(List<MascotaClienteMock> mascotas) {
  DateTime? fechaMinima;
  String fechaTexto = '-';

  for (final mascota in mascotas) {
    final fecha = _parseFechaCorta(mascota.proximaVacuna);
    if (fecha == null) {
      continue;
    }
    if (fechaMinima == null || fecha.isBefore(fechaMinima)) {
      fechaMinima = fecha;
      fechaTexto = mascota.proximaVacuna;
    }
  }
  return fechaTexto;
}

DateTime? _parseFechaCorta(String valor) {
  final partes = valor.toLowerCase().trim().split(RegExp(r'\s+'));
  if (partes.length != 3) {
    return null;
  }

  final dia = int.tryParse(partes[0]);
  final anio = int.tryParse(partes[2]);
  const meses = <String, int>{
    'ene': 1,
    'feb': 2,
    'mar': 3,
    'abr': 4,
    'may': 5,
    'jun': 6,
    'jul': 7,
    'ago': 8,
    'sep': 9,
    'oct': 10,
    'nov': 11,
    'dic': 12,
  };
  final mes = meses[partes[1]];

  if (dia == null || anio == null || mes == null) {
    return null;
  }
  return DateTime(anio, mes, dia);
}

void _abrirRegistroMascota(BuildContext context) {
  showGeneralDialog<void>(
    context: context,
    barrierLabel: 'registro_mascota_cliente',
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
                child: TarjetaCreacionPaciente(
                  onCerrar: () => Navigator.of(dialogContext).pop(),
                  onRegistrar: (data) {
                    Navigator.of(dialogContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Mascota ${data.nombre} registrada (${data.sexo})',
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

void _abrirDetalleMascota(BuildContext context, MascotaClienteMock mascota) {
  mostrarPopupDetalle(
    context,
    ConfigPopupDetalle(
      titulo: mascota.nombre,
      subtitulo: 'Detalle completo de mascota',
      icono: Icons.pets_outlined,
      colorAcento: const Color(0xFF2D7C62),
      chips: <String>[mascota.especie],
      campos: <DetalleCampo>[
        DetalleCampo(etiqueta: 'Nombre', valor: mascota.nombre),
        DetalleCampo(etiqueta: 'Especie', valor: mascota.especie),
        DetalleCampo(etiqueta: 'Raza', valor: mascota.raza),
        DetalleCampo(etiqueta: 'Edad', valor: mascota.edad),
        DetalleCampo(etiqueta: 'Peso', valor: mascota.peso),
        DetalleCampo(etiqueta: 'Sexo', valor: mascota.sexo),
        DetalleCampo(etiqueta: 'Color', valor: mascota.color),
        DetalleCampo(etiqueta: 'Proxima vacuna', valor: mascota.proximaVacuna),
        const DetalleCampo(
          etiqueta: 'Propietario',
          valor: nombreClienteHomeMock,
        ),
      ],
    ),
  );
}
