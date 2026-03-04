import 'package:flutter/material.dart';

class CitaVistaMock {
  const CitaVistaMock({
    required this.nombreMascota,
    required this.hora,
    required this.estado,
    required this.procedimiento,
    required this.descripcion,
    required this.icono,
    required this.iconoColor,
    required this.horaColor,
    required this.cajaHoraColor,
    required this.estadoBgColor,
    required this.estadoTextColor,
  });

  final String nombreMascota;
  final String hora;
  final String estado;
  final String procedimiento;
  final String descripcion;
  final IconData icono;
  final Color iconoColor;
  final Color horaColor;
  final Color cajaHoraColor;
  final Color estadoBgColor;
  final Color estadoTextColor;
}

const citasHoyMock = <CitaVistaMock>[
  CitaVistaMock(
    nombreMascota: 'Luna',
    hora: '10:30',
    estado: 'confirmada',
    procedimiento: 'Vacunacion',
    descripcion: 'Dr. Martinez | Maria Garcia',
    icono: Icons.schedule_rounded,
    iconoColor: Color(0xFF1D9A74),
    horaColor: Color(0xFF0E8C68),
    cajaHoraColor: Color(0xFFD6E2DD),
    estadoBgColor: Color(0xFFCFE5DD),
    estadoTextColor: Color(0xFF2D8A6C),
  ),
  CitaVistaMock(
    nombreMascota: 'Luna',
    hora: '10:30',
    estado: 'confirmada',
    procedimiento: 'Vacunacion',
    descripcion: 'Dr. Martinez | Maria Garcia',
    icono: Icons.schedule_rounded,
    iconoColor: Color(0xFF1D9A74),
    horaColor: Color(0xFF0E8C68),
    cajaHoraColor: Color(0xFFD6E2DD),
    estadoBgColor: Color(0xFFCFE5DD),
    estadoTextColor: Color(0xFF2D8A6C),
  ),
  CitaVistaMock(
    nombreMascota: 'Luna',
    hora: '10:30',
    estado: 'confirmada',
    procedimiento: 'Vacunacion',
    descripcion: 'Dr. Martinez | Maria Garcia',
    icono: Icons.schedule_rounded,
    iconoColor: Color(0xFF1D9A74),
    horaColor: Color(0xFF0E8C68),
    cajaHoraColor: Color(0xFFD6E2DD),
    estadoBgColor: Color(0xFFCFE5DD),
    estadoTextColor: Color(0xFF2D8A6C),
  ),
];

const citasProximasMock = <CitaVistaMock>[
  CitaVistaMock(
    nombreMascota: 'Max',
    hora: '10:00',
    estado: 'pendiente',
    procedimiento: 'Cirugia Menor',
    descripcion: '21 Feb 2026 | Dr. Martinez',
    icono: Icons.calendar_today_outlined,
    iconoColor: Color(0xFF63737D),
    horaColor: Color(0xFF334149),
    cajaHoraColor: Color(0xFFD5DDE0),
    estadoBgColor: Color(0xFFE9DBC7),
    estadoTextColor: Color(0xFF8A6A40),
  ),
  CitaVistaMock(
    nombreMascota: 'Max',
    hora: '10:00',
    estado: 'pendiente',
    procedimiento: 'Cirugia Menor',
    descripcion: '21 Feb 2026 | Dr. Martinez',
    icono: Icons.calendar_today_outlined,
    iconoColor: Color(0xFF63737D),
    horaColor: Color(0xFF334149),
    cajaHoraColor: Color(0xFFD5DDE0),
    estadoBgColor: Color(0xFFE9DBC7),
    estadoTextColor: Color(0xFF8A6A40),
  ),
  CitaVistaMock(
    nombreMascota: 'Max',
    hora: '10:00',
    estado: 'pendiente',
    procedimiento: 'Cirugia Menor',
    descripcion: '21 Feb 2026 | Dr. Martinez',
    icono: Icons.calendar_today_outlined,
    iconoColor: Color(0xFF63737D),
    horaColor: Color(0xFF334149),
    cajaHoraColor: Color(0xFFD5DDE0),
    estadoBgColor: Color(0xFFE9DBC7),
    estadoTextColor: Color(0xFF8A6A40),
  ),
];

const motivosGeneralesMock = <String>[
  'Vacunacion',
  'Control general',
  'Desparasitacion',
  'Chequeo de crecimiento',
  'Revision dermatologica',
  'Problemas digestivos',
  'Dolor o cojera',
  'Limpieza dental',
  'Seguimiento postoperatorio',
  'Esterilizacion o castracion',
  'Actualizacion de historia clinica',
  'Evaluacion de examenes',
  'Control de peso y nutricion',
  'Seguimiento de tratamiento',
];

const estadosCitaMock = <String>[
  'proxima',
  'pendiente',
  'completado',
  'reprogramada',
  'cancelada',
];

class MetricaAdminMock {
  const MetricaAdminMock({
    required this.icono,
    required this.numero,
    required this.etiqueta,
  });

  final IconData icono;
  final String numero;
  final String etiqueta;
}

const metricasHomeAdminMock = <MetricaAdminMock>[
  MetricaAdminMock(
    icono: Icons.pets_outlined,
    numero: '24',
    etiqueta: 'Pacientes',
  ),
  MetricaAdminMock(
    icono: Icons.event_note_outlined,
    numero: '8',
    etiqueta: 'Citas',
  ),
  MetricaAdminMock(
    icono: Icons.group_outlined,
    numero: '5',
    etiqueta: 'Personal',
  ),
];

class ProximaCitaHomeAdminMock {
  const ProximaCitaHomeAdminMock({required this.titulo, required this.detalle});

  final String titulo;
  final String detalle;
}

const proximasCitasHomeAdminMock = <ProximaCitaHomeAdminMock>[
  ProximaCitaHomeAdminMock(
    titulo: 'Freya - Vacunación',
    detalle: 'Hoy 10:30 AM - Dr. GUERRA',
  ),
  ProximaCitaHomeAdminMock(
    titulo: 'Luna - Control General',
    detalle: 'Hoy 2:15 PM - Dr. GUERRA',
  ),
];

const inicialDoctorHomeAdminMock = 'N';
const nombreDoctorHomeAdminMock = 'Dr. Naymar Guerra';

class HistorialCitaMock {
  const HistorialCitaMock({
    required this.id,
    required this.nombreMascota,
    required this.especie,
    required this.estado,
    required this.procedimiento,
    required this.descripcion,
    required this.doctor,
    required this.dueno,
    required this.fechaHora,
  });

  final String id;
  final String nombreMascota;
  final String especie;
  final String estado;
  final String procedimiento;
  final String descripcion;
  final String doctor;
  final String dueno;
  final DateTime fechaHora;
}

const estadoTodosHistorialMock = 'Todos';
const especieTodasHistorialMock = 'Todas';
const fechaTodoHistorialMock = 'Todo el historial';

const estadosFiltroHistorialMock = <String>[
  estadoTodosHistorialMock,
  'finalizada',
  'cancelada',
  'reprogramada',
];

const especiesFiltroHistorialMock = <String>[
  especieTodasHistorialMock,
  'Perro',
  'Gato',
  'Conejo',
];

const fechasFiltroHistorialMock = <String>[
  fechaTodoHistorialMock,
  'Ultimos 7 dias',
  'Ultimos 30 dias',
  'Ultimos 90 dias',
];

List<HistorialCitaMock> crearHistorialCitasMock([DateTime? referencia]) {
  final hoy = referencia ?? DateTime.now();
  final base = DateTime(hoy.year, hoy.month, hoy.day, 10, 0);

  return <HistorialCitaMock>[
    HistorialCitaMock(
      id: 'hc-001',
      nombreMascota: 'Luna',
      especie: 'Perro',
      estado: 'finalizada',
      procedimiento: 'Vacunacion anual',
      descripcion: 'Sin novedades. Se aplico refuerzo y control general.',
      doctor: 'Dr. Guerra',
      dueno: 'Maria Garcia',
      fechaHora: base.subtract(const Duration(days: 2, hours: 1)),
    ),
    HistorialCitaMock(
      id: 'hc-002',
      nombreMascota: 'Max',
      especie: 'Gato',
      estado: 'cancelada',
      procedimiento: 'Revision dermatologica',
      descripcion: 'Cancelada por el usuario el mismo dia de la cita.',
      doctor: 'Dra. Salazar',
      dueno: 'Carlos Rodriguez',
      fechaHora: base.subtract(const Duration(days: 4, hours: 3)),
    ),
    HistorialCitaMock(
      id: 'hc-003',
      nombreMascota: 'Rocky',
      especie: 'Perro',
      estado: 'finalizada',
      procedimiento: 'Limpieza dental',
      descripcion: 'Buena recuperacion post procedimiento.',
      doctor: 'Dr. Martinez',
      dueno: 'Carlos Rodriguez',
      fechaHora: base.subtract(const Duration(days: 9, hours: 2)),
    ),
    HistorialCitaMock(
      id: 'hc-004',
      nombreMascota: 'Nala',
      especie: 'Gato',
      estado: 'reprogramada',
      procedimiento: 'Control de peso y nutricion',
      descripcion: 'Se movio a la siguiente semana por ajuste de agenda.',
      doctor: 'Dra. Salazar',
      dueno: 'Ana Torres',
      fechaHora: base.subtract(const Duration(days: 16, hours: 4)),
    ),
    HistorialCitaMock(
      id: 'hc-005',
      nombreMascota: 'Toby',
      especie: 'Conejo',
      estado: 'finalizada',
      procedimiento: 'Desparasitacion',
      descripcion: 'Evolucion favorable y sin signos de alarma.',
      doctor: 'Dr. Guerra',
      dueno: 'Luis Perez',
      fechaHora: base.subtract(const Duration(days: 34, hours: 2)),
    ),
    HistorialCitaMock(
      id: 'hc-006',
      nombreMascota: 'Mia',
      especie: 'Perro',
      estado: 'finalizada',
      procedimiento: 'Seguimiento postoperatorio',
      descripcion: 'Cicatrizacion correcta.',
      doctor: 'Dr. Martinez',
      dueno: 'Paula Gomez',
      fechaHora: base.subtract(const Duration(days: 63, hours: 1)),
    ),
    HistorialCitaMock(
      id: 'hc-007',
      nombreMascota: 'Bruno',
      especie: 'Perro',
      estado: 'cancelada',
      procedimiento: 'Control general',
      descripcion: 'No asistio, se contacto al propietario para reagendar.',
      doctor: 'Dr. Guerra',
      dueno: 'Paula Gomez',
      fechaHora: base.subtract(const Duration(days: 88, hours: 3)),
    ),
  ];
}
