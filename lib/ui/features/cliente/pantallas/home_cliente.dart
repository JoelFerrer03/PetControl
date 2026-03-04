import 'package:flutter/material.dart';
import 'package:petcontrol/hex/infraestructura/mock/cliente_home_mock.dart';
import 'package:petcontrol/ui/core/rutas/rutas.dart';
import 'package:petcontrol/ui/core/tema/app_colores.dart';
import 'package:petcontrol/ui/core/widgets/popup_detalle.dart';
import 'package:petcontrol/ui/features/cliente/widgets/tarjetas_cliente.dart';
import 'package:petcontrol/ui/features/cliente/widgets/tarjeta creacion cita.dart';
import 'package:petcontrol/ui/features/cliente/widgets/tarjeta creacion paciente.dart';

class HomeCliente extends StatefulWidget {
  const HomeCliente({super.key});

  @override
  State<HomeCliente> createState() => _HomeClienteState();
}

class _HomeClienteState extends State<HomeCliente> {
  final GlobalKey _fabKey = GlobalKey();

  Future<void> _abrirMenuAcciones() async {
    final contextoFab = _fabKey.currentContext;
    if (contextoFab == null) {
      return;
    }

    final renderFab = contextoFab.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final posicionFab = renderFab.localToGlobal(Offset.zero, ancestor: overlay);

    final accion = await showMenu<String>(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFFE8ECEA),
      elevation: 3,
      position: RelativeRect.fromLTRB(
        posicionFab.dx,
        posicionFab.dy - 128,
        overlay.size.width - (posicionFab.dx + renderFab.size.width),
        overlay.size.height - posicionFab.dy,
      ),
      items: accionesRapidasClienteHomeMock
          .map(
            (item) => PopupMenuItem<String>(
              value: item.id,
              child: Row(
                children: [
                  Icon(item.icono, size: 18, color: const Color(0xFF23473F)),
                  const SizedBox(width: 10),
                  Text(item.titulo),
                ],
              ),
            ),
          )
          .toList(),
    );

    if (!mounted || accion == null) {
      return;
    }

    if (accion == 'registrar_mascota') {
      _abrirRegistroMascota();
      return;
    }
    if (accion == 'crear_cita') {
      _abrirCreacionCita();
    }
  }

  void _irAResumen(ResumenClienteMock resumen) {
    if (resumen.id == 'mis_mascotas') {
      Navigator.pushNamed(context, Rutas.clienteMisMascotasPage);
      return;
    }
    if (resumen.id == 'mis_citas') {
      Navigator.pushNamed(context, Rutas.clienteMisCitasPage);
    }
  }

  void _abrirRegistroMascota() {
    showGeneralDialog<void>(
      context: context,
      barrierLabel: 'registro_mascota',
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

  void _abrirCreacionCita() {
    showGeneralDialog<void>(
      context: context,
      barrierLabel: 'crear_cita',
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
                  child: TarjetaCreacionCita(
                    onCerrar: () => Navigator.of(dialogContext).pop(),
                    onRegistrar: (data) {
                      Navigator.of(dialogContext).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Cita para ${data.nombreMascota} creada (${data.fechaHoraFormateada})',
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

  void _abrirDetalleCita(CitaClienteMock cita) {
    mostrarPopupDetalle(
      context,
      ConfigPopupDetalle(
        titulo: cita.nombreMascota,
        subtitulo: 'Detalle completo de cita',
        icono: Icons.calendar_month_outlined,
        colorAcento: const Color(0xFF2D7C62),
        chips: <String>[cita.estado, cita.especieMascota],
        campos: <DetalleCampo>[
          DetalleCampo(etiqueta: 'Mascota', valor: cita.nombreMascota),
          DetalleCampo(etiqueta: 'Especie', valor: cita.especieMascota),
          DetalleCampo(etiqueta: 'Fecha', valor: cita.fecha),
          DetalleCampo(etiqueta: 'Hora', valor: cita.hora),
          DetalleCampo(etiqueta: 'Motivo', valor: cita.motivo),
          DetalleCampo(etiqueta: 'Estado', valor: cita.estado),
          DetalleCampo(etiqueta: 'Veterinario', valor: cita.veterinario),
          DetalleCampo(etiqueta: 'Sede', valor: cita.sede),
          DetalleCampo(etiqueta: 'Descripcion', valor: cita.descripcion),
          const DetalleCampo(
            etiqueta: 'Propietario',
            valor: nombreClienteHomeMock,
          ),
        ],
      ),
    );
  }

  void _abrirDetalleMascota(MascotaClienteMock mascota) {
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
          DetalleCampo(
            etiqueta: 'Proxima vacuna',
            valor: mascota.proximaVacuna,
          ),
          const DetalleCampo(
            etiqueta: 'Propietario',
            valor: nombreClienteHomeMock,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final alturaCurva = (size.height * 0.75).clamp(560.0, 860.0);

    return Scaffold(
      backgroundColor: const Color(0xFFECECEC),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SizedBox(
        key: _fabKey,
        width: 62,
        height: 62,
        child: FloatingActionButton(
          onPressed: _abrirMenuAcciones,
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
                clipper: _CurvaHomeClienteClipper(),
                child: Container(
                  color: const Color(0xFFECECEC),
                  height: alturaCurva,
                  width: double.infinity,
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 92),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(context),
                  const SizedBox(height: 8),
                  const Text(
                    'Gestiona tus citas y mascotas desde un solo lugar.',
                    style: TextStyle(
                      color: Color(0xFFDCE8FF),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _resumenCard(
                        resumenesClienteHomeMock[0],
                        onTap: () => _irAResumen(resumenesClienteHomeMock[0]),
                      ),
                      const SizedBox(width: 12),
                      _resumenCard(
                        resumenesClienteHomeMock[1],
                        onTap: () => _irAResumen(resumenesClienteHomeMock[1]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _PanelSeccion(
                    titulo: 'Mis proximas citas',
                    icono: Icons.calendar_month_outlined,
                    onVerTodo: () => _irAResumen(resumenesClienteHomeMock[1]),
                    child: citasClienteMock.isEmpty
                        ? const _MensajeVacio(
                            texto: 'No tienes citas programadas.',
                          )
                        : Column(
                            children: [
                              for (
                                var i = 0;
                                i < citasClienteMock.length;
                                i++
                              ) ...[
                                TarjetaCitaCliente(
                                  cita: citasClienteMock[i],
                                  mostrarDescripcion: false,
                                  onTap: () =>
                                      _abrirDetalleCita(citasClienteMock[i]),
                                ),
                                if (i < citasClienteMock.length - 1)
                                  const SizedBox(height: 10),
                              ],
                            ],
                          ),
                  ),
                  const SizedBox(height: 14),
                  _PanelSeccion(
                    titulo: 'Mis mascotas registradas',
                    icono: Icons.pets_outlined,
                    onVerTodo: () => _irAResumen(resumenesClienteHomeMock[0]),
                    child: mascotasClienteMock.isEmpty
                        ? const _MensajeVacio(
                            texto: 'No tienes mascotas registradas.',
                          )
                        : Column(
                            children: [
                              for (
                                var i = 0;
                                i < mascotasClienteMock.length;
                                i++
                              ) ...[
                                TarjetaMascotaCliente(
                                  mascota: mascotasClienteMock[i],
                                  onTap: () => _abrirDetalleMascota(
                                    mascotasClienteMock[i],
                                  ),
                                ),
                                if (i < mascotasClienteMock.length - 1)
                                  const SizedBox(height: 10),
                              ],
                            ],
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

class _CurvaHomeClienteClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.2);
    path.quadraticBezierTo(
      size.width * 0.17,
      size.height * 0.36,
      size.width * 0.46,
      size.height * 0.43,
    );
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.52,
      size.width,
      size.height * 0.39,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

Widget _header(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0x22FFFFFF),
            child: Text(
              inicialClienteHomeMock,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Bienvenido',
                style: TextStyle(fontSize: 14, color: Color(0xFFDCE8FF)),
              ),
              Text(
                nombreClienteHomeMock,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
      Container(
        decoration: BoxDecoration(
          color: const Color(0x22FFFFFF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x55FFFFFF)),
        ),
        child: IconButton(
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          icon: const Icon(Icons.logout, color: Colors.white),
          tooltip: 'Salir',
        ),
      ),
    ],
  );
}

Widget _resumenCard(ResumenClienteMock resumen, {required VoidCallback onTap}) {
  return Expanded(
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 112),
          child: Ink(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF9FBFF), Color(0xFFE7EDF6)],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF516377), width: 1.05),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x260D1A2A),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 3,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4D6A89),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 7),
                Icon(resumen.icono, size: 24, color: const Color(0xFF1F3045)),
                const SizedBox(height: 8),
                Text(
                  resumen.valor,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E2A36),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  resumen.etiqueta,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF586572),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _PanelSeccion extends StatelessWidget {
  const _PanelSeccion({
    required this.titulo,
    required this.icono,
    required this.onVerTodo,
    required this.child,
  });

  final String titulo;
  final IconData icono;
  final VoidCallback onVerTodo;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F5FA),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF93A2B2), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x220E1C2F),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFDFE8F5),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icono, color: const Color(0xFF1E3D63), size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    color: Color(0xFF1F2730),
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ),
              TextButton(
                onPressed: onVerTodo,
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF1A6C90),
                  textStyle: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                child: const Text('Ver todo'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _MensajeVacio extends StatelessWidget {
  const _MensajeVacio({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF4F4F4F), width: 1),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          color: Color(0xFF616A71),
          fontSize: 13.5,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
