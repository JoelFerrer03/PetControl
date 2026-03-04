import 'package:flutter/material.dart';
import 'package:petcontrol/hex/infraestructura/mock/cliente_home_mock.dart';
import 'package:petcontrol/ui/core/tema/app_colores.dart';
import 'package:petcontrol/ui/core/widgets/popup_detalle.dart';
import 'package:petcontrol/ui/features/cliente/widgets/tarjeta creacion paciente.dart';
import 'package:petcontrol/ui/features/cliente/widgets/tarjetas_cliente.dart';

class MisMascotasCliente extends StatelessWidget {
  const MisMascotasCliente({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final alturaCurva = (size.height * 0.78).clamp(560.0, 820.0);

    return Scaffold(
      backgroundColor: const Color(0xFFECECEC),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SizedBox(
        width: 62,
        height: 62,
        child: FloatingActionButton(
          onPressed: () => _abrirRegistroMascota(context),
          backgroundColor: AppColores.azulOscuro,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add, size: 34),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned.fill(child: ColoredBox(color: Color(0xFFECECEC))),
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [AppColores.azulOscuro, AppColores.azul],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipPath(
                clipper: _CurvaClienteClipper(),
                child: Container(
                  color: const Color(0xFFECECEC),
                  height: alturaCurva,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                      const SizedBox(width: 4),
                      const Expanded(
                        child: Text(
                          'Mis mascotas',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${mascotasClienteMock.length} registradas a nombre de $nombreClienteHomeMock',
                    style: const TextStyle(
                      color: Color(0xFFDCE8FF),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      itemCount: mascotasClienteMock.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final mascota = mascotasClienteMock[index];
                        return TarjetaMascotaCliente(
                          mascota: mascota,
                          onTap: () => _abrirDetalleMascota(context, mascota),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurvaClienteClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.22);
    path.quadraticBezierTo(
      size.width * 0.16,
      size.height * 0.38,
      size.width * 0.46,
      size.height * 0.44,
    );
    path.quadraticBezierTo(
      size.width * 0.79,
      size.height * 0.52,
      size.width,
      size.height * 0.38,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

void _abrirRegistroMascota(BuildContext context) {
  showGeneralDialog<void>(
    context: context,
    barrierLabel: 'registro_mascota_cliente',
    barrierDismissible: true,
    barrierColor: Colors.black38,
    transitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Material(
              type: MaterialType.transparency,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: TarjetaCreacionPaciente(
                  onCerrar: () => Navigator.of(dialogContext).pop(),
                  onRegistrar: (data) {
                    Navigator.of(dialogContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Mascota ${data.nombre} registrada (${data.sexo})',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curva = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curva,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.97, end: 1).animate(curva),
          child: child,
        ),
      );
    },
  );
}

void _abrirDetalleMascota(BuildContext context, MascotaClienteMock mascota) {
  mostrarPopupDetalle(
    context,
    ConfigPopupDetalle(
      titulo: mascota.nombre,
      subtitulo: 'Detalle completo de mascota',
      icono: Icons.pets_outlined,
      colorAcento: const Color(0xFF2D7C62),
      chips: <String>[mascota.especie],
      campos: <DetalleCampo>[
        DetalleCampo(etiqueta: 'Nombre', valor: mascota.nombre),
        DetalleCampo(etiqueta: 'Especie', valor: mascota.especie),
        DetalleCampo(etiqueta: 'Raza', valor: mascota.raza),
        DetalleCampo(etiqueta: 'Edad', valor: mascota.edad),
        DetalleCampo(etiqueta: 'Peso', valor: mascota.peso),
        DetalleCampo(etiqueta: 'Sexo', valor: mascota.sexo),
        DetalleCampo(etiqueta: 'Color', valor: mascota.color),
        DetalleCampo(etiqueta: 'Proxima vacuna', valor: mascota.proximaVacuna),
        const DetalleCampo(
          etiqueta: 'Propietario',
          valor: nombreClienteHomeMock,
        ),
      ],
    ),
  );
}
