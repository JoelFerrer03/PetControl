class MascotaRegistradaMock {
  const MascotaRegistradaMock({
    required this.id,
    required this.usuarioId,
    required this.nombre,
    required this.especie,
  });

  final String id;
  final String usuarioId;
  final String nombre;
  final String especie;
}

const mascotasRegistradasMock = <MascotaRegistradaMock>[
  MascotaRegistradaMock(
    id: 'm1',
    usuarioId: 'u1',
    nombre: 'Luna',
    especie: 'Perro',
  ),
  MascotaRegistradaMock(
    id: 'm2',
    usuarioId: 'u2',
    nombre: 'Max',
    especie: 'Gato',
  ),
  MascotaRegistradaMock(
    id: 'm3',
    usuarioId: 'u2',
    nombre: 'Rocky',
    especie: 'Perro',
  ),
  MascotaRegistradaMock(
    id: 'm4',
    usuarioId: 'u3',
    nombre: 'Nala',
    especie: 'Gato',
  ),
  MascotaRegistradaMock(
    id: 'm5',
    usuarioId: 'u4',
    nombre: 'Toby',
    especie: 'Conejo',
  ),
  MascotaRegistradaMock(
    id: 'm6',
    usuarioId: 'u5',
    nombre: 'Mia',
    especie: 'Perro',
  ),
  MascotaRegistradaMock(
    id: 'm7',
    usuarioId: 'u5',
    nombre: 'Bruno',
    especie: 'Perro',
  ),
];

const mascotasClienteJoelMock = <MascotaRegistradaMock>[
  MascotaRegistradaMock(
    id: 'm_joel_01',
    usuarioId: 'u_joel_ferrer',
    nombre: 'Luna',
    especie: 'Perro',
  ),
  MascotaRegistradaMock(
    id: 'm_joel_02',
    usuarioId: 'u_joel_ferrer',
    nombre: 'Milo',
    especie: 'Gato',
  ),
  MascotaRegistradaMock(
    id: 'm_joel_03',
    usuarioId: 'u_joel_ferrer',
    nombre: 'Kiara',
    especie: 'Conejo',
  ),
];

class PacienteVistaMock {
  const PacienteVistaMock({
    required this.nombre,
    required this.especie,
    required this.raza,
    required this.edad,
    required this.peso,
    required this.dueno,
  });

  final String nombre;
  final String especie;
  final String raza;
  final int edad;
  final int peso;
  final String dueno;
}

const pacientesMock = <PacienteVistaMock>[
  PacienteVistaMock(
    nombre: 'Luna',
    especie: 'Perro',
    raza: 'Golden Retriever',
    edad: 3,
    peso: 28,
    dueno: 'Maria Garcia',
  ),
  PacienteVistaMock(
    nombre: 'Luna',
    especie: 'Perro',
    raza: 'Golden Retriever',
    edad: 3,
    peso: 28,
    dueno: 'Maria Garcia',
  ),
  PacienteVistaMock(
    nombre: 'Luna',
    especie: 'Perro',
    raza: 'Golden Retriever',
    edad: 3,
    peso: 28,
    dueno: 'Maria Garcia',
  ),
  PacienteVistaMock(
    nombre: 'Luna',
    especie: 'Perro',
    raza: 'Golden Retriever',
    edad: 3,
    peso: 28,
    dueno: 'Maria Garcia',
  ),
  PacienteVistaMock(
    nombre: 'Luna',
    especie: 'Perro',
    raza: 'Golden Retriever',
    edad: 3,
    peso: 28,
    dueno: 'Maria Garcia',
  ),
];
