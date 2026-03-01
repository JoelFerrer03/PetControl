import 'package:flutter/material.dart';
import 'package:petcontrol/ui/core/tema/app_colores.dart';
import 'package:petcontrol/ui/features/admin/pantallas/home_admin.dart';
import 'package:petcontrol/ui/features/autenticacion/pantallas/registro_pantalla.dart';

class FormularioLogin extends StatefulWidget {
  const FormularioLogin({super.key});

  @override
  State<FormularioLogin> createState() => _FormularioLoginState();
}

class _FormularioLoginState extends State<FormularioLogin> {
  static const _correoAdmin = 'admin@admin.com';
  static const _contrasenaAdmin = 'admin';

  final _correoCtrl = TextEditingController();
  final _contrasenaCtrl = TextEditingController();

  bool _ocultarContrasena = true;
  bool _isLoading = false;
  // Estos errores se pintan fuera del TextField para no agrandar el contenedor con sombra.
  String? _errorCorreo;
  String? _errorContrasena;

  @override
  void dispose() {
    _correoCtrl.dispose();
    _contrasenaCtrl.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    // Validación manual al presionar el botón.
    final errorCorreo = _validarCorreo(_correoCtrl.text);
    final errorContrasena = _validarContrasena(_contrasenaCtrl.text);

    setState(() {
      _errorCorreo = errorCorreo;
      _errorContrasena = errorContrasena;
    });

    // Si hay errores, se corta el flujo antes de intentar autenticar.
    if (errorCorreo != null || errorContrasena != null) {
      return;
    }

    setState(() => _isLoading = true);

    // TODO: reemplazar por tu login real (repo/api)
    await Future.delayed(const Duration(milliseconds: 900));

    final correoIngresado = _correoCtrl.text.trim().toLowerCase();
    final contrasenaIngresada = _contrasenaCtrl.text;

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (correoIngresado == _correoAdmin &&
        contrasenaIngresada == _contrasenaAdmin) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HomeAdmin()),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Credenciales incorrectas'),
      backgroundColor: Colors.red,
    ));
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
    if (value != _contrasenaAdmin && value.length < 6) {
      return 'Mínimo 6 caracteres';
    }
    return null;
  }

  InputDecoration _decoracionCampo({
    required String hint,
    Widget? suffixIcon,
  }) {
    final borde = OutlineInputBorder(
      borderRadius: BorderRadius.circular(36),
      borderSide: const BorderSide(color: Colors.black, width: 1),
    );

    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFD9D9D9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
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

  Widget _mensajeError(String? mensaje) {
    return SizedBox(
      // Reserva espacio fijo para evitar saltos de layout al mostrar/ocultar errores.
      height: 20,
      child: mensaje == null
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(left: 12, top: 4),
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
        const Text(
          'Bienvenido a\nVetManager',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            height: 1.1,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 36),

        _etiqueta('Correo Electronico'),
        Container(
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
          child: TextField(
            controller: _correoCtrl,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              // Revalida en vivo solo si ya había error mostrado.
              if (_errorCorreo != null) {
                setState(() {
                  _errorCorreo = _validarCorreo(value);
                });
              }
            },
            decoration: _decoracionCampo(hint: ''),
          ),
        ),
        _mensajeError(_errorCorreo),
        const SizedBox(height: 12),

        _etiqueta('Contraseña'),
        Container(
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
          child: TextField(
            controller: _contrasenaCtrl,
            obscureText: _ocultarContrasena,
            onChanged: (value) {
              // Revalida en vivo solo si ya había error mostrado.
              if (_errorContrasena != null) {
                setState(() {
                  _errorContrasena = _validarContrasena(value);
                });
              }
            },
            decoration: _decoracionCampo(
              hint: '',
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
        const SizedBox(height: 24),

        SizedBox(
          height: 64,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _iniciarSesion,
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
                    'INICIAR SESIÓN',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 24),

        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegistroPantalla()),
            );
          },
          child: const Text(
            'Registrate',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColores.textoAzul,
            ),
          ),
        ),
      ],
    );
  }
}
