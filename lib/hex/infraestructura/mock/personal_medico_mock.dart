class MedicoMock {
  const MedicoMock({
    required this.id,
    required this.nombreCompleto,
    required this.correo,
    required this.telefono,
    required this.documento,
    required this.especialidad,
    required this.jornada,
    required this.estado,
    required this.fechaIngreso,
  });

  final String id;
  final String nombreCompleto;
  final String correo;
  final String telefono;
  final String documento;
  final String especialidad;
  final String jornada;
  final String estado;
  final DateTime fechaIngreso;
}

const especialidadesMedicasMock = <String>[
  'Medicina General',
  'Cirugia Veterinaria',
  'Dermatologia',
  'Odontologia',
  'Cardiologia',
  'Neurologia',
  'Nutrición Animal',
  'Etologia',
  'Urgencias',
];

const jornadasMedicasMock = <String>['Manana', 'Tarde', 'Noche', 'Mixta'];

const estadosMedicoMock = <String>['Activo', 'Vacaciones', 'Inactivo'];

List<MedicoMock> crearPersonalMedicoMock([DateTime? referencia]) {
  final hoy = referencia ?? DateTime.now();
  return <MedicoMock>[
    MedicoMock(
      id: 'med-001',
      nombreCompleto: 'Naymar Guerra',
      correo: 'naymar.guerra@vetmanager.com',
      telefono: '+57 315 457 2110',
      documento: '1020304050',
      especialidad: 'Medicina General',
      jornada: 'Manana',
      estado: 'Activo',
      fechaIngreso: DateTime(hoy.year - 3, 4, 12),
    ),
    MedicoMock(
      id: 'med-002',
      nombreCompleto: 'Sofia Martinez',
      correo: 'sofia.martinez@vetmanager.com',
      telefono: '+57 310 888 7731',
      documento: '8090706050',
      especialidad: 'Cirugia Veterinaria',
      jornada: 'Tarde',
      estado: 'Activo',
      fechaIngreso: DateTime(hoy.year - 5, 8, 3),
    ),
    MedicoMock(
      id: 'med-003',
      nombreCompleto: 'Laura Salazar',
      correo: 'laura.salazar@vetmanager.com',
      telefono: '+57 312 401 9902',
      documento: '5234567890',
      especialidad: 'Dermatologia',
      jornada: 'Mixta',
      estado: 'Vacaciones',
      fechaIngreso: DateTime(hoy.year - 2, 10, 19),
    ),
    MedicoMock(
      id: 'med-004',
      nombreCompleto: 'Camilo Rojas',
      correo: 'camilo.rojas@vetmanager.com',
      telefono: '+57 301 123 4567',
      documento: '1002003004',
      especialidad: 'Urgencias',
      jornada: 'Noche',
      estado: 'Activo',
      fechaIngreso: DateTime(hoy.year - 1, 2, 7),
    ),
  ];
}
