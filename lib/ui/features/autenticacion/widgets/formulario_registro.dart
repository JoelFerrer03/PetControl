import 'package:flutter/material.dart';
import 'package:petcontrol/ui/core/tema/app_colores.dart';

class FormularioRegistro extends StatefulWidget {
  const FormularioRegistro({super.key});

  @override
  State<FormularioRegistro> createState() => _FormularioRegistroState();
}

class _FormularioRegistroState extends State<FormularioRegistro> {
  final _nombresCtrl = TextEditingController();
  final _numeroDocumentoCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  final _contrasenaCtrl = TextEditingController();
  final _confirmarContrasenaCtrl = TextEditingController();

  bool _ocultarContrasena = true;
  bool _ocultarConfirmacion = true;
  bool _isLoading = false;

  // Se muestran fuera del TextField para que la sombra del campo no cambie de alto.
  String? _errorNombres;
  String? _errorNumeroDocumento;
  String? _errorCorreo;
  String? _errorContrasena;
  String? _errorConfirmacion;

  @override
  void dispose() {
    _nombresCtrl.dispose();
    _numeroDocumentoCtrl.dispose();
    _correoCtrl.dispose();
    _contrasenaCtrl.dispose();
    _confirmarContrasenaCtrl.dispose();
    super.dispose();
  }

  Future<void> _registrarse() async {
    final errorNombres = _validarNombres(_nombresCtrl.text);
    final errorNumeroDocumento = _validarNumeroDocumento(_numeroDocumentoCtrl.text);
    final errorCorreo = _validarCorreo(_correoCtrl.text);
    final errorContrasena = _validarContrasena(_contrasenaCtrl.text);
    final errorConfirmacion = _validarConfirmacion(
      _confirmarContrasenaCtrl.text,
      _contrasenaCtrl.text,
    );

    setState(() {
      _errorNombres = errorNombres;
      _errorNumeroDocumento = errorNumeroDocumento;
      _errorCorreo = errorCorreo;
      _errorContrasena = errorContrasena;
      _errorConfirmacion = errorConfirmacion;
    });

    final hayErrores = [
      errorNombres,
      errorNumeroDocumento,
      errorCorreo,
      errorContrasena,
      errorConfirmacion,
    ].any((error) => error != null);

    if (hayErrores) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registro mock correcto')),
    );
  }

  String? _validarNombres(String value) {
    final nombres = value.trim();
    if (nombres.isEmpty) return 'Ingresa tus nombres y apellidos';
    if (nombres.length < 3) return 'Nombre muy corto';
    return null;
  }

  String? _validarNumeroDocumento(String value) {
    final numero = value.trim();
    if (numero.isEmpty) return 'Campo requerido';
    final regex = RegExp(r'^\d+$');
    if (!regex.hasMatch(numero)) return 'Solo números';
    return null;
  }

  String? _validarCorreo(String value) {
    final correo = value.trim();
    if (correo.isEmpty) return 'Ingresa tu correo';
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!regex.hasMatch(correo)) return 'Correo no válido';
    return null;
  }

  String? _validarContrasena(String value) {
    if (value.isEmpty) return 'Ingresa tu contraseña';
    if (value.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  String? _validarConfirmacion(String confirmacion, String contrasena) {
    if (confirmacion.isEmpty) return 'Confirma tu contraseña';
    if (confirmacion != contrasena) return 'Las contraseñas no coinciden';
    return null;
  }

  InputDecoration _decoracionCampo({Widget? suffixIcon}) {
    final borde = OutlineInputBorder(
      borderRadius: BorderRadius.circular(36),
      borderSide: const BorderSide(color: Colors.black, width: 1),
    );

    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFD9D9D9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      enabledBorder: borde,
      focusedBorder: borde,
      suffixIcon: suffixIcon,
    );
  }

  Widget _etiqueta(String texto) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, bottom: 8),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _campoConSombra({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _mensajeError(String? mensaje, {double leftPadding = 12}) {
    return SizedBox(
      height: 16,
      child: mensaje == null
          ? const SizedBox.shrink()
          : Padding(
              padding: EdgeInsets.only(left: leftPadding, top: 2),
              child: Text(
                mensaje,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _etiqueta('Nombres y Apellidos'),
        _campoConSombra(
          child: TextField(
            controller: _nombresCtrl,
            onChanged: (value) {
              if (_errorNombres != null) {
                setState(() {
                  _errorNombres = _validarNombres(value);
                });
              }
            },
            decoration: _decoracionCampo(),
          ),
        ),
        _mensajeError(_errorNombres),
        const SizedBox(height: 4),

        _etiqueta('Número de documento'),
        _campoConSombra(
          child: TextField(
            controller: _numeroDocumentoCtrl,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              if (_errorNumeroDocumento != null) {
                setState(() {
                  _errorNumeroDocumento = _validarNumeroDocumento(value);
                });
              }
            },
            decoration: _decoracionCampo(),
          ),
        ),
        _mensajeError(_errorNumeroDocumento),
        const SizedBox(height: 4),

        _etiqueta('Correo Electronico'),
        _campoConSombra(
          child: TextField(
            controller: _correoCtrl,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              if (_errorCorreo != null) {
                setState(() {
                  _errorCorreo = _validarCorreo(value);
                });
              }
            },
            decoration: _decoracionCampo(),
          ),
        ),
        _mensajeError(_errorCorreo),
        const SizedBox(height: 4),

        _etiqueta('Contraseña'),
        _campoConSombra(
          child: TextField(
            controller: _contrasenaCtrl,
            obscureText: _ocultarContrasena,
            onChanged: (value) {
              if (_errorContrasena != null || _errorConfirmacion != null) {
                setState(() {
                  _errorContrasena = _validarContrasena(value);
                  _errorConfirmacion = _validarConfirmacion(
                    _confirmarContrasenaCtrl.text,
                    value,
                  );
                });
              }
            },
            decoration: _decoracionCampo(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() => _ocultarContrasena = !_ocultarContrasena);
                },
                icon: Icon(
                  _ocultarContrasena
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),
          ),
        ),
        _mensajeError(_errorContrasena),
        const SizedBox(height: 4),

        _etiqueta('Confirmar Contraseña'),
        _campoConSombra(
          child: TextField(
            controller: _confirmarContrasenaCtrl,
            obscureText: _ocultarConfirmacion,
            onChanged: (value) {
              if (_errorConfirmacion != null) {
                setState(() {
                  _errorConfirmacion = _validarConfirmacion(
                    value,
                    _contrasenaCtrl.text,
                  );
                });
              }
            },
            decoration: _decoracionCampo(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() => _ocultarConfirmacion = !_ocultarConfirmacion);
                },
                icon: Icon(
                  _ocultarConfirmacion
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),
          ),
        ),
        _mensajeError(_errorConfirmacion),
        const SizedBox(height: 12),

        SizedBox(
          height: 64,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _registrarse,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColores.verde,
              foregroundColor: Colors.black,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
                side: const BorderSide(color: Colors.black, width: 1),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'REGISTRARSE',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
