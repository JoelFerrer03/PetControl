import 'package:flutter/material.dart';

const nombreClienteHomeMock = 'Joel Ferrer';
const inicialClienteHomeMock = 'J';

class ResumenClienteMock {
  const ResumenClienteMock({
    required this.id,
    required this.icono,
    required this.valor,
    required this.etiqueta,
  });

  final String id;
  final IconData icono;
  final String valor;
  final String etiqueta;
}

class MascotaClienteMock {
  const MascotaClienteMock({
    required this.id,
    required this.nombre,
    required this.especie,
    required this.raza,
    required this.edad,
    required this.peso,
    required this.sexo,
    required this.color,
    required this.proximaVacuna,
  });

  final String id;
  final String nombre;
  final String especie;
  final String raza;
  final String edad;
  final String peso;
  final String sexo;
  final String color;
  final String proximaVacuna;
}

class CitaClienteMock {
  const CitaClienteMock({
    required this.id,
    required this.idMascota,
    required this.nombreMascota,
    required this.especieMascota,
    required this.fecha,
    required this.hora,
    required this.motivo,
    required this.estado,
    required this.veterinario,
    required this.sede,
    required this.descripcion,
  });

  final String id;
  final String idMascota;
  final String nombreMascota;
  final String especieMascota;
  final String fecha;
  final String hora;
  final String motivo;
  final String estado;
  final String veterinario;
  final String sede;
  final String descripcion;
}

const mascotasClienteMock = <MascotaClienteMock>[
  MascotaClienteMock(
    id: 'm_joel_01',
    nombre: 'Luna',
    especie: 'Perro',
    raza: 'Border Collie',
    edad: '3 anios',
    peso: '19 kg',
    sexo: 'Hembra',
    color: 'Negro y blanco',
    proximaVacuna: '12 abr 2026',
  ),
  MascotaClienteMock(
    id: 'm_joel_02',
    nombre: 'Milo',
    especie: 'Gato',
    raza: 'Siames',
    edad: '2 anios',
    peso: '4.8 kg',
    sexo: 'Macho',
    color: 'Crema',
    proximaVacuna: '25 mar 2026',
  ),
  MascotaClienteMock(
    id: 'm_joel_03',
    nombre: 'Kiara',
    especie: 'Conejo',
    raza: 'Mini Lop',
    edad: '1 anio',
    peso: '2.2 kg',
    sexo: 'Hembra',
    color: 'Marron',
    proximaVacuna: '08 may 2026',
  ),
];

const citasClienteMock = <CitaClienteMock>[
  CitaClienteMock(
    id: 'cj-001',
    idMascota: 'm_joel_01',
    nombreMascota: 'Luna',
    especieMascota: 'Perro',
    fecha: '08 mar 2026',
    hora: '09:00',
    motivo: 'Vacunacion anual',
    estado: 'proxima',
    veterinario: 'Dr. Naymar Guerra',
    sede: 'Sede Principal',
    descripcion: 'Refuerzo anual y control general.',
  ),
  CitaClienteMock(
    id: 'cj-002',
    idMascota: 'm_joel_02',
    nombreMascota: 'Milo',
    especieMascota: 'Gato',
    fecha: '11 mar 2026',
    hora: '11:30',
    motivo: 'Control general',
    estado: 'proxima',
    veterinario: 'Dra. Salazar',
    sede: 'Sede Norte',
    descripcion: 'Revision preventiva y control de peso.',
  ),
  CitaClienteMock(
    id: 'cj-003',
    idMascota: 'm_joel_03',
    nombreMascota: 'Kiara',
    especieMascota: 'Conejo',
    fecha: '15 mar 2026',
    hora: '16:00',
    motivo: 'Desparasitacion',
    estado: 'proxima',
    veterinario: 'Dr. Martinez',
    sede: 'Sede Centro',
    descripcion: 'Aplicacion de dosis y seguimiento.',
  ),
];

final resumenesClienteHomeMock = <ResumenClienteMock>[
  ResumenClienteMock(
    id: 'mis_mascotas',
    icono: Icons.pets_outlined,
    valor: mascotasClienteMock.length.toString(),
    etiqueta: 'Mis mascotas',
  ),
  ResumenClienteMock(
    id: 'mis_citas',
    icono: Icons.event_note_outlined,
    valor: citasClienteMock.length.toString(),
    etiqueta: 'Mis citas',
  ),
];

class AccionRapidaClienteMock {
  const AccionRapidaClienteMock({
    required this.id,
    required this.titulo,
    required this.icono,
  });

  final String id;
  final String titulo;
  final IconData icono;
}

const accionesRapidasClienteHomeMock = <AccionRapidaClienteMock>[
  AccionRapidaClienteMock(
    id: 'registrar_mascota',
    titulo: 'Registrar mascota',
    icono: Icons.pets,
  ),
  AccionRapidaClienteMock(
    id: 'crear_cita',
    titulo: 'Crear cita',
    icono: Icons.calendar_month_outlined,
  ),
];
