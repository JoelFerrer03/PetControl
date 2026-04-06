import 'package:flutter/material.dart';
import 'package:petcontrol/ui/core/tema/app_colores.dart';
import 'package:petcontrol/ui/core/widgets/popup_detalle.dart';
import 'package:petcontrol/ui/features/admin/widgets/tarjeta creacion paciente.dart';

class VistaPacientesAdmin extends StatelessWidget {
  const VistaPacientesAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final totalEspecies = _pacientes
        .map((paciente) => paciente.especie.toLowerCase())
        .toSet()
        .length;
    final pesoPromedio = _pacientes.isEmpty
        ? 0.0
        : _pacientes.fold<int>(0, (total, paciente) => total + paciente.peso) /
              _pacientes.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F2),
      floatingActionButton: SizedBox(
        width: 62,
        height: 62,
        child: FloatingActionButton(
          onPressed: () => _abrirRegistroPaciente(context),
          backgroundColor: const Color(0xFF1E6246),
          foregroundColor: Colors.white,
          child: const Icon(Icons.add, size: 34),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned.fill(child: _FondoPacientes()),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Encabezado(
                    onVolver: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(height: 14),
                  _ResumenPacientes(
                    totalPacientes: _pacientes.length,
                    totalEspecies: totalEspecies,
                    pesoPromedio: pesoPromedio,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FBF9),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFFC0D2C8),
                        width: 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A183325),
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Listado de pacientes',
                          style: TextStyle(
                            color: Color(0xFF22362C),
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_pacientes.length} registros activos',
                          style: const TextStyle(
                            color: Color(0xFF617468),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const _BuscadorPacientes(),
                        const SizedBox(height: 14),
                        for (var i = 0; i < _pacientes.length; i++) ...[
                          _TarjetaPaciente(
                            paciente: _pacientes[i],
                            onTap: () => _abrirDetallePacientePreview(
                              context,
                              _pacientes[i],
                            ),
                          ),
                          if (i < _pacientes.length - 1)
                            const SizedBox(height: 12),
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

class _FondoPacientes extends StatelessWidget {
  const _FondoPacientes();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 280,
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1F6C4C),
                      AppColores.verdepacientes,
                      Color(0xFF73C08F),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(38),
                    bottomRight: Radius.circular(38),
                  ),
                ),
              ),
              const Positioned(
                top: -36,
                right: -24,
                child: _CirculoDecorativo(diametro: 126, opacidad: 0.2),
              ),
              const Positioned(
                bottom: 16,
                left: -28,
                child: _CirculoDecorativo(diametro: 104, opacidad: 0.14),
              ),
            ],
          ),
        ),
        const Expanded(child: ColoredBox(color: Color(0xFFF1F5F2))),
      ],
    );
  }
}

class _CirculoDecorativo extends StatelessWidget {
  const _CirculoDecorativo({required this.diametro, required this.opacidad});

  final double diametro;
  final double opacidad;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diametro,
      height: diametro,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: opacidad),
        shape: BoxShape.circle,
      ),
    );
  }
}

void _abrirRegistroPaciente(BuildContext context) {
  showGeneralDialog<void>(
    context: context,
    barrierLabel: 'registro_paciente',
    barrierColor: Colors.black38,
    barrierDismissible: true,
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
                          'Paciente ${data.nombre} registrado (${data.sexo})',
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

void _abrirDetallePacientePreview(
  BuildContext context,
  _PacienteVista paciente,
) {
  mostrarPopupDetalle(
    context,
    ConfigPopupDetalle(
      titulo: paciente.nombre,
      subtitulo: 'Ficha completa del paciente',
      icono: Icons.pets_outlined,
      colorAcento: const Color(0xFF2D7C62),
      chips: <String>[paciente.especie],
      campos: <DetalleCampo>[
        DetalleCampo(etiqueta: 'Nombre', valor: paciente.nombre),
        DetalleCampo(etiqueta: 'Especie', valor: paciente.especie),
        DetalleCampo(etiqueta: 'Raza', valor: paciente.raza),
        DetalleCampo(etiqueta: 'Edad', valor: '${paciente.edad} años'),
        DetalleCampo(etiqueta: 'Peso', valor: '${paciente.peso} kg'),
        DetalleCampo(etiqueta: 'Dueño', valor: paciente.dueno),
      ],
    ),
  );
}

class _Encabezado extends StatelessWidget {
  const _Encabezado({required this.onVolver});

  final VoidCallback onVolver;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BotonEncabezadoIcono(onTap: onVolver),
        const SizedBox(height: 12),
        const Text(
          'Pacientes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 33,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Gestiona el historial, datos de contacto y seguimiento de tus mascotas.',
          style: TextStyle(
            color: Color(0xFFE8F8EE),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _BotonEncabezadoIcono extends StatelessWidget {
  const _BotonEncabezadoIcono({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Ink(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0x22FFFFFF),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: const Color(0x55FFFFFF)),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }
}

class _ResumenPacientes extends StatelessWidget {
  const _ResumenPacientes({
    required this.totalPacientes,
    required this.totalEspecies,
    required this.pesoPromedio,
  });

  final int totalPacientes;
  final int totalEspecies;
  final double pesoPromedio;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TarjetaResumen(
            etiqueta: 'Pacientes',
            valor: '$totalPacientes',
            icono: Icons.pets_outlined,
          ),
          const SizedBox(width: 10),
          _TarjetaResumen(
            etiqueta: 'Especies',
            valor: '$totalEspecies',
            icono: Icons.category_outlined,
          ),
        ],
      ),
    );
  }
}
class _TarjetaResumen extends StatelessWidget {
  const _TarjetaResumen({
    required this.etiqueta,
    required this.valor,
    required this.icono,
  });

  final String etiqueta;
  final String valor;
  final IconData icono;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0x2FFFFFFF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x54FFFFFF)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icono, color: Colors.white, size: 18),
            const SizedBox(height: 8),
            Text(
              valor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              etiqueta,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xDBF4FFF7),
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuscadorPacientes extends StatelessWidget {
  const _BuscadorPacientes();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: TextField(
        cursorColor: AppColores.negro,
        decoration: InputDecoration(
          hintText: 'Buscar por nombre, dueño o raza...',
          hintStyle: const TextStyle(color: Color(0xFF627269), fontSize: 14),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 20,
            color: Color(0xFF5F7066),
          ),
          suffixIcon: const Icon(
            Icons.tune_rounded,
            size: 20,
            color: Color(0xFF5F7066),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFCAD9D0), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF2A6F4D), width: 1.3),
          ),
        ),
      ),
    );
  }
}

class _TarjetaPaciente extends StatelessWidget {
  const _TarjetaPaciente({required this.paciente, required this.onTap});

  final _PacienteVista paciente;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconoEspecie = _iconoEspecie(paciente.especie);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 114),
          child: Ink(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFFFFF), Color(0xFFF0F7F3)],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFC7D8CE), width: 1),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD6E8DE),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        iconoEspecie,
                        color: const Color(0xFF2A6F4D),
                        size: 24,
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
                                  paciente.nombre,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1F3028),
                                    height: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              _ChipEspecie(especie: paciente.especie),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            paciente.raza,
                            style: const TextStyle(
                              color: Color(0xFF637268),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF6A7D72),
                      size: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _ChipDatoPaciente(
                      icono: Icons.cake_outlined,
                      valor: '${paciente.edad} años',
                    ),
                    _ChipDatoPaciente(
                      icono: Icons.monitor_weight_outlined,
                      valor: '${paciente.peso} kg',
                    ),
                    _ChipDatoPaciente(
                      icono: Icons.person_outline_rounded,
                      valor: paciente.dueno,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconoEspecie(String especie) {
    switch (especie.toLowerCase()) {
      case 'gato':
        return Icons.pets_rounded;
      case 'conejo':
        return Icons.cruelty_free_outlined;
      case 'ave':
        return Icons.flutter_dash_rounded;
      default:
        return Icons.pets_outlined;
    }
  }
}

class _ChipEspecie extends StatelessWidget {
  const _ChipEspecie({required this.especie});

  final String especie;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFDAEFE4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        especie,
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFF2F7452),
          height: 1,
        ),
      ),
    );
  }
}

class _ChipDatoPaciente extends StatelessWidget {
  const _ChipDatoPaciente({required this.icono, required this.valor});

  final IconData icono;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F1EB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 14, color: const Color(0xFF3A7157)),
          const SizedBox(width: 6),
          Text(
            valor,
            style: const TextStyle(
              color: Color(0xFF416955),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _PacienteVista {
  const _PacienteVista({
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

const _pacientes = <_PacienteVista>[
  _PacienteVista(
    nombre: 'Luna',
    especie: 'Perro',
    raza: 'Golden Retriever',
    edad: 3,
    peso: 28,
    dueno: 'Maria Garcia',
  ),
  _PacienteVista(
    nombre: 'Milo',
    especie: 'Gato',
    raza: 'Siames',
    edad: 2,
    peso: 5,
    dueno: 'Carlos Perez',
  ),
  _PacienteVista(
    nombre: 'Nala',
    especie: 'Perro',
    raza: 'Border Collie',
    edad: 4,
    peso: 22,
    dueno: 'Laura Diaz',
  ),
  _PacienteVista(
    nombre: 'Coco',
    especie: 'Conejo',
    raza: 'Mini Lop',
    edad: 1,
    peso: 2,
    dueno: 'Juan Torres',
  ),
  _PacienteVista(
    nombre: 'Simba',
    especie: 'Gato',
    raza: 'Maine Coon',
    edad: 5,
    peso: 8,
    dueno: 'Ana Ruiz',
  ),
];
