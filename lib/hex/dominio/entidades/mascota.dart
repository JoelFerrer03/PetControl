class Mascota {
  final String id;
  final String idDueno;
  final String nombre;
  final String especie;
  final String raza;
  final int edad;
  final String sexo;
  final bool tieneCitaActiva;
  final DateTime fechaCreacion;

  Mascota({
    required this.id,
    required this.idDueno,
    required this.nombre,
    required this.especie,
    required this.raza,
    required this.edad,
    required this.sexo,
    required this.tieneCitaActiva,
    required this.fechaCreacion,
  });
}