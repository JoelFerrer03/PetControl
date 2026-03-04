import 'package:flutter/material.dart';
import 'package:petcontrol/hex/infraestructura/mock/citas_mock.dart';
import 'package:petcontrol/hex/infraestructura/mock/cliente_home_mock.dart';
import 'package:petcontrol/hex/infraestructura/mock/mascotas_mock.dart';

const _idUsuarioFijoCliente = 'u_joel_ferrer';
const _estadoCitaFijoCliente = 'proxima';

String _formatearFechaHora(DateTime fechaHora) {
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

  final dia = fechaHora.day.toString().padLeft(2, '0');
  final hora = fechaHora.hour.toString().padLeft(2, '0');
  final minuto = fechaHora.minute.toString().padLeft(2, '0');
  final mes = meses[fechaHora.month - 1];
  return '$dia $mes ${fechaHora.year} $hora:$minuto';
}

class CitaCreacionData {
  const CitaCreacionData({
    required this.idMascota,
    required this.nombreMascota,
    required this.idUsuario,
    required this.nombreUsuario,
    required this.fechaHora,
    required this.motivo,
    required this.estado,
    required this.descripcion,
  });

  final String idMascota;
  final String nombreMascota;
  final String idUsuario;
  final String nombreUsuario;
  final DateTime fechaHora;
  final String motivo;
  final String estado;
  final String descripcion;

  String get fechaHoraFormateada => _formatearFechaHora(fechaHora);
}

class TarjetaCreacionCita extends StatefulWidget {
  const TarjetaCreacionCita({super.key, this.onCerrar, this.onRegistrar});

  final VoidCallback? onCerrar;
  final ValueChanged<CitaCreacionData>? onRegistrar;

  @override
  State<TarjetaCreacionCita> createState() => _TarjetaCreacionCitaState();
}

class _TarjetaCreacionCitaState extends State<TarjetaCreacionCita> {
  final _formKey = GlobalKey<FormState>();
  final _fechaHoraController = TextEditingController();
  final _descripcionController = TextEditingController();

  String? _mascotaSeleccionadaId;
  String? _motivoSeleccionado;
  DateTime? _fechaHoraSeleccionada;

  List<MascotaRegistradaMock> get _mascotasDisponibles =>
      mascotasClienteJoelMock;

  MascotaRegistradaMock? _mascotaPorId(String id) {
    for (final mascota in mascotasClienteJoelMock) {
      if (mascota.id == id) {
        return mascota;
      }
    }
    return null;
  }

  @override
  void dispose() {
    _fechaHoraController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  InputDecoration _decoracionCampo(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Color(0xFF6E7A78),
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: const Color(0xFFE8EBEA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFCDD4D1), width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF5ABF9A), width: 1.7),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFB53939), width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFB53939), width: 1.7),
      ),
      errorStyle: const TextStyle(height: 0.01),
    );
  }

  String? _validadorRequerido(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '';
    }
    return null;
  }

  String? _validadorDescripcion(String? value) {
    // Campo opcional: no bloquea el envio si esta vacio o corto.
    return null;
  }

  Future<void> _seleccionarFechaHora() async {
    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);
    final inicial =
        _fechaHoraSeleccionada ?? ahora.add(const Duration(hours: 1));

    final fecha = await showDatePicker(
      context: context,
      initialDate: inicial.isBefore(hoy) ? hoy : inicial,
      firstDate: hoy,
      lastDate: DateTime(ahora.year + 3),
      helpText: 'Selecciona la fecha de la cita',
    );
    if (fecha == null || !mounted) {
      return;
    }

    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(inicial),
      helpText: 'Selecciona la hora de la cita',
    );
    if (hora == null || !mounted) {
      return;
    }

    final fechaHora = DateTime(
      fecha.year,
      fecha.month,
      fecha.day,
      hora.hour,
      hora.minute,
    );

    if (fechaHora.isBefore(ahora)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'La cita debe programarse en una fecha y hora futuras.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _fechaHoraSeleccionada = fechaHora;
      _fechaHoraController.text = _formatearFechaHora(fechaHora);
    });
  }

  void _onMascotaChanged(String? mascotaId) {
    setState(() {
      _mascotaSeleccionadaId = mascotaId;
    });
  }

  void _registrar() {
    final esValido = _formKey.currentState?.validate() == true;
    if (!esValido) {
      setState(() {});
      return;
    }

    final mascotaId = _mascotaSeleccionadaId;
    final motivo = _motivoSeleccionado;
    final fechaHora = _fechaHoraSeleccionada;

    if (mascotaId == null || motivo == null || fechaHora == null) {
      setState(() {});
      return;
    }

    final mascota = _mascotaPorId(mascotaId);
    if (mascota == null) {
      return;
    }

    widget.onRegistrar?.call(
      CitaCreacionData(
        idMascota: mascota.id,
        nombreMascota: mascota.nombre,
        idUsuario: _idUsuarioFijoCliente,
        nombreUsuario: nombreClienteHomeMock,
        fechaHora: fechaHora,
        motivo: motivo,
        estado: _estadoCitaFijoCliente,
        descripcion: _descripcionController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alturaMaxima = MediaQuery.of(context).size.height * 0.82;

    return Container(
      constraints: BoxConstraints(maxHeight: alturaMaxima),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFDCDDDB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF1A95F7), width: 2),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Registrar Cita',
                      style: TextStyle(
                        color: Color(0xFF223633),
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onCerrar,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      child: Icon(
                        Icons.close,
                        color: Color(0xFF5E6A68),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const _EtiquetaCampo('Mascota registrada'),
              DropdownButtonFormField<String>(
                initialValue: _mascotaSeleccionadaId,
                validator: (value) => value == null ? '' : null,
                isExpanded: true,
                menuMaxHeight: 260,
                decoration: _decoracionCampo('Seleccionar mascota'),
                items: _mascotasDisponibles
                    .map(
                      (mascota) => DropdownMenuItem<String>(
                        value: mascota.id,
                        child: Text(
                          '${mascota.nombre} (${mascota.especie})',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: _mascotasDisponibles.isEmpty
                    ? null
                    : _onMascotaChanged,
              ),
              const SizedBox(height: 4),
              const Padding(
                padding: EdgeInsets.only(left: 2),
                child: Text(
                  'Se muestran las mascotas asociadas a tu cuenta.',
                  style: TextStyle(
                    color: Color(0xFF6A7674),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const _EtiquetaCampo('Usuario registrado'),
              TextFormField(
                initialValue: nombreClienteHomeMock,
                readOnly: true,
                enabled: false,
                decoration: _decoracionCampo(''),
              ),
              const SizedBox(height: 10),
              const _EtiquetaCampo('Fecha y hora de la proxima cita'),
              TextFormField(
                controller: _fechaHoraController,
                readOnly: true,
                validator: _validadorRequerido,
                decoration: _decoracionCampo('Seleccionar fecha y hora')
                    .copyWith(
                      suffixIcon: IconButton(
                        onPressed: _seleccionarFechaHora,
                        icon: const Icon(
                          Icons.event_available_outlined,
                          size: 20,
                        ),
                      ),
                    ),
                onTap: _seleccionarFechaHora,
              ),
              const SizedBox(height: 10),
              const _EtiquetaCampo('Motivo de la cita'),
              DropdownButtonFormField<String>(
                initialValue: _motivoSeleccionado,
                validator: (value) => value == null ? '' : null,
                isExpanded: true,
                menuMaxHeight: 300,
                decoration: _decoracionCampo('Seleccionar motivo'),
                items: motivosGeneralesMock
                    .map(
                      (motivo) => DropdownMenuItem<String>(
                        value: motivo,
                        child: Text(motivo, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _motivoSeleccionado = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              const _EtiquetaCampo('Estado de la cita'),
              TextFormField(
                initialValue: _estadoCitaFijoCliente,
                readOnly: true,
                enabled: false,
                decoration: _decoracionCampo(''),
              ),
              const SizedBox(height: 10),
              const _EtiquetaCampo('Descripcion de la cita'),
              TextFormField(
                controller: _descripcionController,
                validator: _validadorDescripcion,
                maxLines: 6,
                minLines: 4,
                textInputAction: TextInputAction.newline,
                decoration: _decoracionCampo(
                  'Describe con detalle lo que se evaluara o realizara.',
                ).copyWith(alignLabelWithHint: true),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _registrar,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFF0E8D63),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Crear Cita',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EtiquetaCampo extends StatelessWidget {
  const _EtiquetaCampo(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 5),
      child: Text(
        texto,
        style: const TextStyle(
          color: Color(0xFF4A5B58),
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
