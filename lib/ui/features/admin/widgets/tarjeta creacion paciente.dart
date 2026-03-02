import 'package:flutter/material.dart';

class PacienteCreacionData {
  const PacienteCreacionData({
    required this.nombre,
    required this.especie,
    required this.raza,
    required this.edad,
    required this.peso,
    required this.sexo,
  });

  final String nombre;
  final String especie;
  final String raza;
  final String edad;
  final String peso;
  final String sexo;
}

class TarjetaCreacionPaciente extends StatefulWidget {
  const TarjetaCreacionPaciente({super.key, this.onCerrar, this.onRegistrar});

  final VoidCallback? onCerrar;
  final ValueChanged<PacienteCreacionData>? onRegistrar;

  @override
  State<TarjetaCreacionPaciente> createState() =>
      _TarjetaCreacionPacienteState();
}

class _TarjetaCreacionPacienteState extends State<TarjetaCreacionPaciente> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _especieController = TextEditingController();
  final _razaController = TextEditingController();
  final _edadController = TextEditingController();
  final _pesoController = TextEditingController();

  String? _sexoSeleccionado;

  @override
  void dispose() {
    _nombreController.dispose();
    _especieController.dispose();
    _razaController.dispose();
    _edadController.dispose();
    _pesoController.dispose();
    super.dispose();
  }

  InputDecoration _decoracionCampo({
    required String hintText,
    Color colorBorde = const Color(0xFFCDD4D1),
    Color colorFondo = const Color(0xFFE8EBEA),
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Color(0xFF6E7A78),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: colorFondo,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorBorde, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorBorde, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFB53939), width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFB53939), width: 1.8),
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

  void _registrar() {
    final esValido =
        _formKey.currentState?.validate() == true && _sexoSeleccionado != null;
    if (!esValido) {
      setState(() {});
      return;
    }

    widget.onRegistrar?.call(
      PacienteCreacionData(
        nombre: _nombreController.text.trim(),
        especie: _especieController.text.trim(),
        raza: _razaController.text.trim(),
        edad: _edadController.text.trim(),
        peso: _pesoController.text.trim(),
        sexo: _sexoSeleccionado!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFDCDDDB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF1A95F7), width: 2),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Registrar Paciente',
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
            const SizedBox(height: 8),
            const _EtiquetaCampo('Nombre'),
            TextFormField(
              controller: _nombreController,
              validator: _validadorRequerido,
              decoration: _decoracionCampo(
                hintText: 'Nombre de la mascota',
                colorBorde: const Color(0xFF5ABF9A),
                colorFondo: const Color(0xFFE5E8E7),
              ),
            ),
            const SizedBox(height: 10),
            const _EtiquetaCampo('Especie'),
            TextFormField(
              controller: _especieController,
              validator: _validadorRequerido,
              decoration: _decoracionCampo(hintText: 'Ej: Perro'),
            ),
            const SizedBox(height: 10),
            const _EtiquetaCampo('Sexo'),
            DropdownButtonFormField<String>(
              initialValue: _sexoSeleccionado,
              validator: (value) => value == null ? '' : null,
              decoration: _decoracionCampo(hintText: 'Seleccionar sexo'),
              hint: const Text(
                'Seleccionar sexo',
                style: TextStyle(
                  color: Color(0xFF6E7A78),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              borderRadius: BorderRadius.circular(12),
              items: const [
                DropdownMenuItem(value: 'Hembra', child: Text('Hembra')),
                DropdownMenuItem(value: 'Macho', child: Text('Macho')),
              ],
              onChanged: (value) {
                setState(() {
                  _sexoSeleccionado = value;
                });
              },
            ),
            const SizedBox(height: 10),
            const _EtiquetaCampo('Raza'),
            TextFormField(
              controller: _razaController,
              validator: _validadorRequerido,
              decoration: _decoracionCampo(hintText: 'Raza'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _EtiquetaCampo('Edad'),
                      TextFormField(
                        controller: _edadController,
                        validator: _validadorRequerido,
                        decoration: _decoracionCampo(hintText: 'Ej: 3 años'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _EtiquetaCampo('Peso'),
                      TextFormField(
                        controller: _pesoController,
                        validator: _validadorRequerido,
                        decoration: _decoracionCampo(hintText: 'Ej: 12 kg'),
                      ),
                    ],
                  ),
                ),
              ],
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
                  'Registrar Paciente',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
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
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        texto,
        style: const TextStyle(
          color: Color(0xFF2D3D3B),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
