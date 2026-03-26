import 'package:flutter/material.dart';
import 'package:petcontrol/hex/infraestructura/mock/citas_mock.dart';
import 'package:petcontrol/ui/core/tema/app_colores.dart';
import 'package:petcontrol/ui/core/widgets/popup_detalle.dart';

class HistorialMedicoAdmin extends StatefulWidget {
  const HistorialMedicoAdmin({super.key});

  @override
  State<HistorialMedicoAdmin> createState() => _HistorialMedicoAdminState();
}

class _HistorialMedicoAdminState extends State<HistorialMedicoAdmin> {
  final List<HistorialCitaMock> _historialCitas = crearHistorialCitasMock();

  String _estadoSeleccionado = estadoTodosHistorialMock;
  String _especieSeleccionada = especieTodasHistorialMock;
  String _fechaSeleccionada = fechaTodoHistorialMock;

  int? _diasParaRango(String rango) {
    switch (rango) {
      case 'Ultimos 7 dias':
        return 7;
      case 'Ultimos 30 dias':
        return 30;
      case 'Ultimos 90 dias':
        return 90;
      default:
        return null;
    }
  }

  List<HistorialCitaMock> get _historialFiltrado {
    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);
    final diasFiltro = _diasParaRango(_fechaSeleccionada);

    final filtradas = _historialCitas.where((cita) {
      final coincideEstado =
          _estadoSeleccionado == estadoTodosHistorialMock ||
          cita.estado == _estadoSeleccionado;
      final coincideEspecie =
          _especieSeleccionada == especieTodasHistorialMock ||
          cita.especie == _especieSeleccionada;
      final coincideFecha = diasFiltro == null
          ? true
          : !cita.fechaHora.isBefore(hoy.subtract(Duration(days: diasFiltro)));
      return coincideEstado && coincideEspecie && coincideFecha;
    }).toList();

    filtradas.sort((a, b) => b.fechaHora.compareTo(a.fechaHora));
    return filtradas;
  }

  int _contarEstado(String estado) {
    return _historialFiltrado.where((cita) => cita.estado == estado).length;
  }

  String _formatearFecha(DateTime fecha) {
    const meses = <String>[
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = meses[fecha.month - 1];
    final anio = fecha.year.toString();
    final hora = fecha.hour.toString().padLeft(2, '0');
    final minuto = fecha.minute.toString().padLeft(2, '0');
    return '$dia $mes $anio - $hora:$minuto';
  }

  Color _colorFondoEstado(String estado) {
    switch (estado) {
      case 'finalizada':
        return const Color(0xFFCFE5DD);
      case 'cancelada':
        return const Color(0xFFF1D1D1);
      case 'reprogramada':
        return const Color(0xFFE9DBC7);
      default:
        return const Color(0xFFD8DEE2);
    }
  }

  Color _colorTextoEstado(String estado) {
    switch (estado) {
      case 'finalizada':
        return const Color(0xFF2D8A6C);
      case 'cancelada':
        return const Color(0xFF9D3B3B);
      case 'reprogramada':
        return const Color(0xFF8A6A40);
      default:
        return const Color(0xFF4E5A62);
    }
  }

  IconData _iconoEstado(String estado) {
    switch (estado) {
      case 'finalizada':
        return Icons.check_circle_outline_rounded;
      case 'cancelada':
        return Icons.cancel_outlined;
      case 'reprogramada':
        return Icons.event_repeat_outlined;
      default:
        return Icons.event_note_outlined;
    }
  }

  Future<void> _abrirFiltroPopup() async {
    var estadoTemp = _estadoSeleccionado;
    var especieTemp = _especieSeleccionada;
    var fechaTemp = _fechaSeleccionada;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF2F6F4),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                14,
                16,
                MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filtrar historial',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F352B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _CampoFiltro(
                      etiqueta: 'Estado',
                      child: DropdownButtonFormField<String>(
                        initialValue: estadoTemp,
                        decoration: _decoracionFiltro(),
                        items: estadosFiltroHistorialMock
                            .map(
                              (estado) => DropdownMenuItem<String>(
                                value: estado,
                                child: Text(estado),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setModalState(() => estadoTemp = value);
                        },
                      ),
                    ),
                    _CampoFiltro(
                      etiqueta: 'Especie',
                      child: DropdownButtonFormField<String>(
                        initialValue: especieTemp,
                        decoration: _decoracionFiltro(),
                        items: especiesFiltroHistorialMock
                            .map(
                              (especie) => DropdownMenuItem<String>(
                                value: especie,
                                child: Text(especie),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setModalState(() => especieTemp = value);
                        },
                      ),
                    ),
                    _CampoFiltro(
                      etiqueta: 'Fecha',
                      child: DropdownButtonFormField<String>(
                        initialValue: fechaTemp,
                        decoration: _decoracionFiltro(),
                        items: fechasFiltroHistorialMock
                            .map(
                              (fecha) => DropdownMenuItem<String>(
                                value: fecha,
                                child: Text(fecha),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setModalState(() => fechaTemp = value);
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _estadoSeleccionado = estadoTodosHistorialMock;
                                _especieSeleccionada =
                                    especieTodasHistorialMock;
                                _fechaSeleccionada = fechaTodoHistorialMock;
                              });
                              Navigator.of(context).pop();
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF2A3E35),
                              side: const BorderSide(color: Color(0xFF8BA49A)),
                              minimumSize: const Size.fromHeight(44),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Limpiar'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _estadoSeleccionado = estadoTemp;
                                _especieSeleccionada = especieTemp;
                                _fechaSeleccionada = fechaTemp;
                              });
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E6246),
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(44),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Aplicar',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  InputDecoration _decoracionFiltro() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCAD9D0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2D8A6C), width: 1.4),
      ),
    );
  }

  void _abrirDetalleHistorial(HistorialCitaMock cita) {
    final fechaFormateada = _formatearFecha(cita.fechaHora);
    mostrarPopupDetalle(
      context,
      ConfigPopupDetalle(
        titulo: cita.nombreMascota,
        subtitulo: 'Detalle completo de cita pasada',
        icono: _iconoEstado(cita.estado),
        colorAcento: _colorTextoEstado(cita.estado),
        chips: <String>[cita.estado, cita.especie],
        campos: <DetalleCampo>[
          DetalleCampo(etiqueta: 'Mascota', valor: cita.nombreMascota),
          DetalleCampo(etiqueta: 'Especie', valor: cita.especie),
          DetalleCampo(etiqueta: 'Estado', valor: cita.estado),
          DetalleCampo(etiqueta: 'Procedimiento', valor: cita.procedimiento),
          DetalleCampo(etiqueta: 'Fecha y hora', valor: fechaFormateada),
          DetalleCampo(etiqueta: 'Doctor', valor: cita.doctor),
          DetalleCampo(etiqueta: 'Dueno', valor: cita.dueno),
          DetalleCampo(etiqueta: 'Descripcion', valor: cita.descripcion),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final historialFiltrado = _historialFiltrado;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F2),
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned.fill(child: _FondoHistorial()),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _EncabezadoHistorial(
                    onVolver: () => Navigator.of(context).pop(),
                    onFiltrar: _abrirFiltroPopup,
                  ),
                  const SizedBox(height: 14),
                  _ResumenHistorial(
                    total: historialFiltrado.length,
                    finalizadas: _contarEstado('finalizada'),
                    canceladas: _contarEstado('cancelada'),
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
                          'Historial de citas',
                          style: TextStyle(
                            color: Color(0xFF22362C),
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${historialFiltrado.length} registros para los filtros actuales',
                          style: const TextStyle(
                            color: Color(0xFF617468),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _ChipFiltroActivo(
                              texto: 'Estado: $_estadoSeleccionado',
                            ),
                            _ChipFiltroActivo(
                              texto: 'Especie: $_especieSeleccionada',
                            ),
                            _ChipFiltroActivo(
                              texto: 'Fecha: $_fechaSeleccionada',
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        if (historialFiltrado.isEmpty)
                          const _EstadoVacioHistorial()
                        else
                          for (
                            var i = 0;
                            i < historialFiltrado.length;
                            i++
                          ) ...[
                            _TarjetaHistorialCita(
                              cita: historialFiltrado[i],
                              fechaFormateada: _formatearFecha(
                                historialFiltrado[i].fechaHora,
                              ),
                              colorFondoEstado: _colorFondoEstado(
                                historialFiltrado[i].estado,
                              ),
                              colorTextoEstado: _colorTextoEstado(
                                historialFiltrado[i].estado,
                              ),
                              iconoEstado: _iconoEstado(
                                historialFiltrado[i].estado,
                              ),
                              onTap: () =>
                                  _abrirDetalleHistorial(historialFiltrado[i]),
                            ),
                            if (i < historialFiltrado.length - 1)
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

class _FondoHistorial extends StatelessWidget {
  const _FondoHistorial();

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
                      Color(0xFF1B664A),
                      AppColores.verdepacientes,
                      Color(0xFF6EBC89),
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
                child: _CirculoDecorativoHistorial(
                  diametro: 126,
                  opacidad: 0.2,
                ),
              ),
              const Positioned(
                bottom: 18,
                left: -24,
                child: _CirculoDecorativoHistorial(
                  diametro: 96,
                  opacidad: 0.14,
                ),
              ),
            ],
          ),
        ),
        const Expanded(child: ColoredBox(color: Color(0xFFF1F5F2))),
      ],
    );
  }
}

class _CirculoDecorativoHistorial extends StatelessWidget {
  const _CirculoDecorativoHistorial({
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

class _EncabezadoHistorial extends StatelessWidget {
  const _EncabezadoHistorial({required this.onVolver, required this.onFiltrar});

  final VoidCallback onVolver;
  final VoidCallback onFiltrar;

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
              onPressed: onFiltrar,
              style: FilledButton.styleFrom(
                minimumSize: const Size(108, 40),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                backgroundColor: const Color(0xFF143B2A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                side: const BorderSide(color: Color(0x88FFFFFF)),
              ),
              icon: const Icon(Icons.tune_rounded, size: 18),
              label: const Text(
                'Filtros',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Historial de citas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 33,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Consulta el historial clinico y filtra eventos por estado, fecha y especie.',
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

class _ResumenHistorial extends StatelessWidget {
  const _ResumenHistorial({
    required this.total,
    required this.finalizadas,
    required this.canceladas,
  });

  final int total;
  final int finalizadas;
  final int canceladas;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ItemResumen(
          valor: '$total',
          etiqueta: 'Total',
          icono: Icons.inventory_2_outlined,
        ),
        const SizedBox(width: 10),
        _ItemResumen(
          valor: '$finalizadas',
          etiqueta: 'Finalizadas',
          icono: Icons.check_circle_outline,
        ),
        const SizedBox(width: 10),
        _ItemResumen(
          valor: '$canceladas',
          etiqueta: 'Canceladas',
          icono: Icons.cancel_outlined,
        ),
      ],
    );
  }
}

class _ItemResumen extends StatelessWidget {
  const _ItemResumen({
    required this.valor,
    required this.etiqueta,
    required this.icono,
  });

  final String valor;
  final String etiqueta;
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

class _ChipFiltroActivo extends StatelessWidget {
  const _ChipFiltroActivo({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F1EB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFF3C6651),
          height: 1,
        ),
      ),
    );
  }
}

class _TarjetaHistorialCita extends StatelessWidget {
  const _TarjetaHistorialCita({
    required this.cita,
    required this.fechaFormateada,
    required this.colorFondoEstado,
    required this.colorTextoEstado,
    required this.iconoEstado,
    required this.onTap,
  });

  final HistorialCitaMock cita;
  final String fechaFormateada;
  final Color colorFondoEstado;
  final Color colorTextoEstado;
  final IconData iconoEstado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 124),
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
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: colorFondoEstado,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(iconoEstado, color: colorTextoEstado, size: 21),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          Text(
                            cita.nombreMascota,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1F3028),
                              height: 1,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDAEFE4),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              cita.especie,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2F7452),
                                height: 1,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colorFondoEstado,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              cita.estado,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: colorTextoEstado,
                                height: 1,
                              ),
                            ),
                          ),
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
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F2ED),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Text(
                          '$fechaFormateada | ${cita.doctor}\nDueno: ${cita.dueno}',
                          style: const TextStyle(
                            color: Color(0xFF587066),
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

class _EstadoVacioHistorial extends StatelessWidget {
  const _EstadoVacioHistorial();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF5F1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC6D6CD)),
      ),
      child: const Column(
        children: [
          Icon(Icons.search_off_rounded, color: Color(0xFF60786C), size: 32),
          SizedBox(height: 12),
          Text(
            'No hay citas que coincidan con los filtros.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF5E756A),
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CampoFiltro extends StatelessWidget {
  const _CampoFiltro({required this.etiqueta, required this.child});

  final String etiqueta;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            etiqueta,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3C4A47),
            ),
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}
