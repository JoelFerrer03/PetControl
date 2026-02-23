import 'package:petcontrol/hex/dominio/enums/rol_usuario.dart';

class Usuario {
  final String id;
  final String nombreCompleto;
  final String correo;
  final String telefono;
  final RolUsuario rol;
  final DateTime fechaCreacion;

  Usuario({
    required this.id,
    required this.nombreCompleto,
    required this.correo,
    required this.telefono,
    required this.rol,
    required this.fechaCreacion,
  });

  /// Permite crear una copia del usuario con cambios
  Usuario copyWith({
    String? id,
    String? nombreCompleto,
    String? correo,
    String? telefono,
    RolUsuario? rol,
    DateTime? fechaCreacion,
  }) {
    return Usuario(
      id: id ?? this.id,
      nombreCompleto: nombreCompleto ?? this.nombreCompleto,
      correo: correo ?? this.correo,
      telefono: telefono ?? this.telefono,
      rol: rol ?? this.rol,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }
}