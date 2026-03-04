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

    // Nuevo: filtros combinados (estado, especie y fecha) aplicados sobre mocks.
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
      backgroundColor: const Color(0xFFE7EBE9),
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
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColores.textoNegro,
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
                              foregroundColor: Colors.black87,
                              side: const BorderSide(color: Colors.black54),
                              minimumSize: const Size.fromHeight(44),
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
                              backgroundColor: AppColores.verdepacientes,
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(44),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Aplicar filtros',
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
      fillColor: const Color(0xFFF0F3F1),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFB9C3BF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
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
          DetalleCampo(etiqueta: 'Dueño', valor: cita.dueno),
          DetalleCampo(etiqueta: 'Descripcion', valor: cita.descripcion),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final historialFiltrado = _historialFiltrado;
    final size = MediaQuery.of(context).size;
    final alturaCurva = (size.height * 0.64).clamp(560.0, 760.0);

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
                clipper: _CurvaFondoHistorialClipper(),
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
                  _EncabezadoHistorial(
                    onVolver: () => Navigator.of(context).pop(),
                    onFiltrar: _abrirFiltroPopup,
                  ),
                  const SizedBox(height: 16),
                  _ResumenHistorial(
                    total: historialFiltrado.length,
                    finalizadas: _contarEstado('finalizada'),
                    canceladas: _contarEstado('cancelada'),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _ChipFiltroActivo(texto: 'Estado: $_estadoSeleccionado'),
                      _ChipFiltroActivo(
                        texto: 'Especie: $_especieSeleccionada',
                      ),
                      _ChipFiltroActivo(texto: 'Fecha: $_fechaSeleccionada'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (historialFiltrado.isEmpty)
                    const _EstadoVacioHistorial()
                  else
                    for (var i = 0; i < historialFiltrado.length; i++) ...[
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
                        iconoEstado: _iconoEstado(historialFiltrado[i].estado),
                        onTap: () =>
                            _abrirDetalleHistorial(historialFiltrado[i]),
                      ),
                      if (i < historialFiltrado.length - 1)
                        const SizedBox(height: 14),
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

class _CurvaFondoHistorialClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.28);
    path.quadraticBezierTo(
      size.width * 0.20,
      size.height * 0.42,
      size.width * 0.50,
      size.height * 0.52,
    );
    path.quadraticBezierTo(
      size.width * 0.78,
      size.height * 0.61,
      size.width,
      size.height * 0.49,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _EncabezadoHistorial extends StatelessWidget {
  const _EncabezadoHistorial({required this.onVolver, required this.onFiltrar});

  final VoidCallback onVolver;
  final VoidCallback onFiltrar;

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
            'Historial de citas',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
              height: 1,
            ),
          ),
        ),
        IconButton.filledTonal(
          onPressed: onFiltrar,
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFFDCE5E1),
            foregroundColor: const Color(0xFF20473E),
            side: const BorderSide(color: Color(0xFF648278), width: 1),
          ),
          icon: const Icon(Icons.tune_rounded, size: 20),
          tooltip: 'Filtrar',
        ),
      ],
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
          color: AppColores.textoAzul,
        ),
        const SizedBox(width: 12),
        _ItemResumen(
          valor: '$finalizadas',
          etiqueta: 'Finalizadas',
          color: AppColores.verdepacientes,
        ),
        const SizedBox(width: 12),
        _ItemResumen(
          valor: '$canceladas',
          etiqueta: 'Canceladas',
          color: const Color(0xFF9D3B3B),
        ),
      ],
    );
  }
}

class _ItemResumen extends StatelessWidget {
  const _ItemResumen({
    required this.valor,
    required this.etiqueta,
    required this.color,
  });

  final String valor;
  final String etiqueta;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        constraints: const BoxConstraints(minHeight: 96),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFE6EAEA),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black38, width: 1.1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              valor,
              style: TextStyle(
                color: color,
                fontSize: 30,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              etiqueta,
              style: const TextStyle(
                color: Color(0xFF5B656B),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.1,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFDDE5E1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF8CA198)),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2F4A42),
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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF4B4B4B), width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colorFondoEstado,
                  shape: BoxShape.circle,
                ),
                child: Icon(iconoEstado, color: colorTextoEstado, size: 20),
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
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1D2730),
                            height: 1,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9E8E1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            cita.especie,
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2D7C62),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colorFondoEstado,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            cita.estado,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: colorTextoEstado,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      cita.procedimiento,
                      style: const TextStyle(
                        color: Color(0xFF4F5A61),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$fechaFormateada | ${cita.doctor}',
                      style: const TextStyle(
                        color: Color(0xFF637077),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Dueño: ${cita.dueno}',
                      style: const TextStyle(
                        color: Color(0xFF637077),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
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

class _EstadoVacioHistorial extends StatelessWidget {
  const _EstadoVacioHistorial();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB6B6B6)),
      ),
      child: const Column(
        children: [
          Icon(Icons.search_off_rounded, color: Color(0xFF5E6970), size: 30),
          SizedBox(height: 12),
          Text(
            'No hay citas que coincidan con los filtros.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF5E6970),
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
