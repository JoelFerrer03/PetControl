import 'package:flutter/material.dart';
import 'package:petcontrol/hex/infraestructura/mock/cliente_home_mock.dart';

class TarjetaCitaCliente extends StatelessWidget {
  const TarjetaCitaCliente({
    super.key,
    required this.cita,
    required this.onTap,
    this.mostrarDescripcion = true,
  });

  final CitaClienteMock cita;
  final VoidCallback onTap;
  final bool mostrarDescripcion;

  @override
  Widget build(BuildContext context) {
    final estiloEstado = _estiloEstado(cita.estado);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: const Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF4F4F4F), width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFD6E3DE),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: Color(0xFF2D7C62),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            cita.nombreMascota,
                            style: const TextStyle(
                              color: Color(0xFF1F2428),
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              height: 1,
                            ),
                          ),
                        ),
                        _ChipDato(
                          texto: cita.estado,
                          fondo: estiloEstado.fondo,
                          colorTexto: estiloEstado.texto,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        _ChipDato(
                          texto: cita.especieMascota,
                          fondo: const Color(0xFFD9E5E0),
                          colorTexto: const Color(0xFF355046),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          '${cita.fecha} - ${cita.hora}',
                          style: const TextStyle(
                            color: Color(0xFF576067),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      cita.motivo,
                      style: const TextStyle(
                        color: Color(0xFF2A3238),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                      ),
                    ),
                    if (mostrarDescripcion) ...[
                      const SizedBox(height: 4),
                      Text(
                        cita.descripcion,
                        style: const TextStyle(
                          color: Color(0xFF626C72),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TarjetaMascotaCliente extends StatelessWidget {
  const TarjetaMascotaCliente({
    super.key,
    required this.mascota,
    required this.onTap,
  });

  final MascotaClienteMock mascota;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: const Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF4F4F4F), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFFD6E3DE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pets_outlined,
                  color: Color(0xFF2D7C62),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            mascota.nombre,
                            style: const TextStyle(
                              color: Color(0xFF1F2428),
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              height: 1,
                            ),
                          ),
                        ),
                        _ChipDato(
                          texto: mascota.especie,
                          fondo: const Color(0xFFD9E5E0),
                          colorTexto: const Color(0xFF355046),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mascota.raza,
                      style: const TextStyle(
                        color: Color(0xFF5D676E),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${mascota.edad} | ${mascota.peso}',
                      style: const TextStyle(
                        color: Color(0xFF5D676E),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChipDato extends StatelessWidget {
  const _ChipDato({
    required this.texto,
    required this.fondo,
    required this.colorTexto,
  });

  final String texto;
  final Color fondo;
  final Color colorTexto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Text(
        texto,
        style: TextStyle(
          color: colorTexto,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}

_EstiloEstado _estiloEstado(String estado) {
  switch (estado.toLowerCase()) {
    case 'proxima':
      return const _EstiloEstado(
        fondo: Color(0xFFCFE5DD),
        texto: Color(0xFF2E7E62),
      );
    case 'cancelada':
      return const _EstiloEstado(
        fondo: Color(0xFFE8D3D3),
        texto: Color(0xFFA33A3A),
      );
    case 'reprogramada':
      return const _EstiloEstado(
        fondo: Color(0xFFE7DEC8),
        texto: Color(0xFF88683C),
      );
    default:
      return const _EstiloEstado(
        fondo: Color(0xFFD9E5E0),
        texto: Color(0xFF355046),
      );
  }
}

class _EstiloEstado {
  const _EstiloEstado({required this.fondo, required this.texto});

  final Color fondo;
  final Color texto;
}
