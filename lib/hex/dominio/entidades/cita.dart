import 'package:petcontrol/hex/dominio/enums/estado_cita.dart';
class Cita {
  final String id;
  final String idDueno;
  final String idMascota;
  final DateTime fechaHora;
  final String motivo;
  final EstadoCita estado;
  final String notas;
  final DateTime fechaCreacion;
  final DateTime? fechaActualizacion;

  Cita({
    required this.id,
    required this.idDueno,
    required this.idMascota,
    required this.fechaHora,
    required this.motivo,
    required this.estado,
    this.notas = '',
    required this.fechaCreacion,
    this.fechaActualizacion,
  });

  /// Método para copiar el objeto con cambios (útil para actualizar estado)
  Cita copyWith({
    String? id,
    String? idDueno,
    String? idMascota,
    DateTime? fechaHora,
    String? motivo,
    EstadoCita? estado,
    String? notas,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) {
    return Cita(
      id: id ?? this.id,
      idDueno: idDueno ?? this.idDueno,
      idMascota: idMascota ?? this.idMascota,
      fechaHora: fechaHora ?? this.fechaHora,
      motivo: motivo ?? this.motivo,
      estado: estado ?? this.estado,
      notas: notas ?? this.notas,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }
}