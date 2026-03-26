import 'package:flutter/material.dart';
import 'package:petcontrol/hex/infraestructura/mock/personal_medico_mock.dart';
import 'package:petcontrol/ui/core/tema/app_colores.dart';
import 'package:petcontrol/ui/core/widgets/popup_detalle.dart';

class PersonalMedicoAdmin extends StatefulWidget {
  const PersonalMedicoAdmin({super.key});

  @override
  State<PersonalMedicoAdmin> createState() => _PersonalMedicoAdminState();
}

class _PersonalMedicoAdminState extends State<PersonalMedicoAdmin> {
  final TextEditingController _busquedaCtrl = TextEditingController();
  final List<MedicoMock> _personal = <MedicoMock>[];

  @override
  void initState() {
    super.initState();
    _personal.addAll(crearPersonalMedicoMock());
  }

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    super.dispose();
  }

  List<MedicoMock> get _personalFiltrado {
    final q = _busquedaCtrl.text.trim().toLowerCase();
    return _personal.where((m) {
      final okTexto =
          q.isEmpty ||
          m.nombreCompleto.toLowerCase().contains(q) ||
          m.especialidad.toLowerCase().contains(q) ||
          m.correo.toLowerCase().contains(q);
      return okTexto;
    }).toList()..sort((a, b) => a.nombreCompleto.compareTo(b.nombreCompleto));
  }

  int _conteoEstado(String estado) {
    return _personal.where((m) => m.estado == estado).length;
  }

  String _iniciales(String nombre) {
    final p = nombre.trim().split(RegExp(r'\s+'));
    if (p.isEmpty || p.first.isEmpty) {
      return 'M';
    }
    if (p.length == 1) {
      return p.first.substring(0, 1).toUpperCase();
    }
    return '${p[0][0]}${p[1][0]}'.toUpperCase();
  }

  Color _estadoBg(String estado) {
    switch (estado) {
      case 'Activo':
        return const Color(0xFFCFE5DD);
      case 'Vacaciones':
        return const Color(0xFFE9DBC7);
      default:
        return const Color(0xFFF1D1D1);
    }
  }

  Color _estadoText(String estado) {
    switch (estado) {
      case 'Activo':
        return const Color(0xFF2D8A6C);
      case 'Vacaciones':
        return const Color(0xFF8A6A40);
      default:
        return const Color(0xFF9D3B3B);
    }
  }

  String _fecha(DateTime f) {
    const meses = <String>[
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];
    return '${f.day.toString().padLeft(2, '0')} ${meses[f.month - 1]} ${f.year}';
  }

  void _verDetalle(MedicoMock m) {
    mostrarPopupDetalle(
      context,
      ConfigPopupDetalle(
        titulo: m.nombreCompleto,
        subtitulo: m.especialidad,
        icono: Icons.medical_services_outlined,
        colorAcento: _estadoText(m.estado),
        chips: <String>[m.estado, m.jornada],
        campos: <DetalleCampo>[
          DetalleCampo(etiqueta: 'Correo', valor: m.correo),
          DetalleCampo(etiqueta: 'Telefono', valor: m.telefono),
          DetalleCampo(etiqueta: 'Documento', valor: m.documento),
          DetalleCampo(etiqueta: 'Especialidad', valor: m.especialidad),
          DetalleCampo(
            etiqueta: 'Fecha de ingreso',
            valor: _fecha(m.fechaIngreso),
          ),
        ],
      ),
    );
  }

  Future<void> _abrirFormularioNuevoMedico() async {
    final input = await showGeneralDialog<NuevoMedicoInput>(
      context: context,
      barrierLabel: 'nuevo_medico',
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
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: _FormularioNuevoMedico(
                    onCerrar: () => Navigator.of(dialogContext).pop(),
                    onGuardar: (value) =>
                        Navigator.of(dialogContext).pop(value),
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

    if (input == null || !mounted) {
      return;
    }
    final id = 'med-${(_personal.length + 1).toString().padLeft(3, '0')}';
    setState(() {
      _personal.add(
        MedicoMock(
          id: id,
          nombreCompleto: input.nombreCompleto,
          correo: input.correo,
          telefono: input.telefono,
          documento: input.documento,
          especialidad: input.especialidad,
          jornada: input.jornada,
          estado: input.estado,
          fechaIngreso: DateTime.now(),
        ),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Medico ${input.nombreCompleto} agregado')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lista = _personalFiltrado;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F2),
      floatingActionButton: SizedBox(
        width: 62,
        height: 62,
        child: FloatingActionButton(
          onPressed: _abrirFormularioNuevoMedico,
          backgroundColor: const Color(0xFF1E6246),
          foregroundColor: Colors.white,
          child: const Icon(Icons.add, size: 34),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned.fill(child: _FondoPersonal()),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _EncabezadoPersonal(
                    onVolver: () => Navigator.of(context).pop(),
                    totalResultados: lista.length,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _ResumenBox(
                        valor: '${_personal.length}',
                        etiqueta: 'Total',
                        icono: Icons.badge_outlined,
                      ),
                      const SizedBox(width: 10),
                      _ResumenBox(
                        valor: '${_conteoEstado('Activo')}',
                        etiqueta: 'Activos',
                        icono: Icons.check_circle_outline,
                      ),
                      const SizedBox(width: 10),
                      _ResumenBox(
                        valor: '${_conteoEstado('Vacaciones')}',
                        etiqueta: 'Vacaciones',
                        icono: Icons.beach_access_outlined,
                      ),
                    ],
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
                          'Equipo medico',
                          style: TextStyle(
                            color: Color(0xFF22362C),
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${lista.length} profesionales visibles',
                          style: const TextStyle(
                            color: Color(0xFF617468),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _BuscadorPersonal(
                          controller: _busquedaCtrl,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 14),
                        if (lista.isEmpty)
                          const _VacioPersonal()
                        else
                          for (var i = 0; i < lista.length; i++) ...[
                            _TarjetaMedico(
                              medico: lista[i],
                              iniciales: _iniciales(lista[i].nombreCompleto),
                              colorBg: _estadoBg(lista[i].estado),
                              colorText: _estadoText(lista[i].estado),
                              onTap: () => _verDetalle(lista[i]),
                            ),
                            if (i < lista.length - 1)
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

class _FondoPersonal extends StatelessWidget {
  const _FondoPersonal();

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
                      Color(0xFF1B664A),
                      AppColores.verdepacientes,
                      Color(0xFF6EBC89),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(38),
                    bottomRight: Radius.circular(38),
                  ),
                ),
              ),
              const Positioned(
                top: -34,
                right: -24,
                child: _CirculoDecorativoPersonal(diametro: 126, opacidad: 0.2),
              ),
              const Positioned(
                bottom: 18,
                left: -24,
                child: _CirculoDecorativoPersonal(diametro: 96, opacidad: 0.14),
              ),
            ],
          ),
        ),
        const Expanded(child: ColoredBox(color: Color(0xFFF1F5F2))),
      ],
    );
  }
}

class _CirculoDecorativoPersonal extends StatelessWidget {
  const _CirculoDecorativoPersonal({
    required this.diametro,
    required this.opacidad,
  });

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

class _EncabezadoPersonal extends StatelessWidget {
  const _EncabezadoPersonal({
    required this.onVolver,
    required this.totalResultados,
  });

  final VoidCallback onVolver;
  final int totalResultados;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _BotonEncabezadoIcono(onTap: onVolver),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0x2FFFFFFF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0x55FFFFFF)),
              ),
              child: Text(
                '$totalResultados resultados',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Personal medico',
          style: TextStyle(
            color: Colors.white,
            fontSize: 33,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Gestiona especialistas, jornadas y disponibilidad del equipo clinico.',
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

class _BuscadorPersonal extends StatelessWidget {
  const _BuscadorPersonal({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        cursorColor: AppColores.negro,
        decoration: InputDecoration(
          hintText: 'Buscar por nombre, especialidad o correo...',
          hintStyle: const TextStyle(color: Color(0xFF627269), fontSize: 14),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 20,
            color: Color(0xFF5F7066),
          ),
          suffixIcon: const Icon(
            Icons.local_hospital_outlined,
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

class _ResumenBox extends StatelessWidget {
  const _ResumenBox({
    required this.valor,
    required this.etiqueta,
    required this.icono,
  });

  final String valor;
  final String etiqueta;
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

class _TarjetaMedico extends StatelessWidget {
  const _TarjetaMedico({
    required this.medico,
    required this.iniciales,
    required this.colorBg,
    required this.colorText,
    required this.onTap,
  });

  final MedicoMock medico;
  final String iniciales;
  final Color colorBg;
  final Color colorText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 122),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFFD7E5DE),
                      child: Text(
                        iniciales,
                        style: const TextStyle(
                          color: Color(0xFF1D4E3E),
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            medico.nombreCompleto,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1F3028),
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _ChipMedico(
                                color: const Color(0xFFDAEFE4),
                                textColor: const Color(0xFF2F7452),
                                texto: medico.especialidad,
                              ),
                              _ChipMedico(
                                color: colorBg,
                                textColor: colorText,
                                texto: medico.estado,
                              ),
                            ],
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
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _ChipInfoMedico(
                      icono: Icons.mail_outline_rounded,
                      valor: medico.correo,
                    ),
                    _ChipInfoMedico(
                      icono: Icons.phone_outlined,
                      valor: medico.telefono,
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
}

class _ChipMedico extends StatelessWidget {
  const _ChipMedico({
    required this.color,
    required this.textColor,
    required this.texto,
  });

  final Color color;
  final Color textColor;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: textColor,
          height: 1,
        ),
      ),
    );
  }
}

class _ChipInfoMedico extends StatelessWidget {
  const _ChipInfoMedico({required this.icono, required this.valor});

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
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 195),
            child: Text(
              valor,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF416955),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VacioPersonal extends StatelessWidget {
  const _VacioPersonal();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF5F1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC6D6CD)),
      ),
      child: const Column(
        children: [
          Icon(Icons.search_off_rounded, color: Color(0xFF60786C), size: 32),
          SizedBox(height: 12),
          Text(
            'No hay personal medico para los filtros actuales.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF5E756A),
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class NuevoMedicoInput {
  const NuevoMedicoInput({
    required this.nombreCompleto,
    required this.correo,
    required this.telefono,
    required this.documento,
    required this.especialidad,
    required this.jornada,
    required this.estado,
  });

  final String nombreCompleto;
  final String correo;
  final String telefono;
  final String documento;
  final String especialidad;
  final String jornada;
  final String estado;
}

class _FormularioNuevoMedico extends StatefulWidget {
  const _FormularioNuevoMedico({
    required this.onCerrar,
    required this.onGuardar,
  });

  final VoidCallback onCerrar;
  final ValueChanged<NuevoMedicoInput> onGuardar;

  @override
  State<_FormularioNuevoMedico> createState() => _FormularioNuevoMedicoState();
}

class _FormularioNuevoMedicoState extends State<_FormularioNuevoMedico> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _correo = TextEditingController();
  final _telefono = TextEditingController();
  final _documento = TextEditingController();

  String? _especialidad;
  String? _jornada;
  String? _estado;

  @override
  void initState() {
    super.initState();
    _especialidad = especialidadesMedicasMock.first;
    _jornada = jornadasMedicasMock.first;
    _estado = estadosMedicoMock.first;
  }

  @override
  void dispose() {
    _nombre.dispose();
    _correo.dispose();
    _telefono.dispose();
    _documento.dispose();
    super.dispose();
  }

  InputDecoration _d(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF6E7A78),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCAD9D0), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2A6F4D), width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFB53939), width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFB53939), width: 1.7),
      ),
      errorStyle: const TextStyle(height: 0.01),
    );
  }

  String? _r(String? v) => (v == null || v.trim().isEmpty) ? '' : null;

  String? _c(String? v) {
    final correo = v?.trim() ?? '';
    if (correo.isEmpty) return '';
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return regex.hasMatch(correo) ? null : '';
  }

  void _guardar() {
    if (!(_formKey.currentState?.validate() == true) ||
        _especialidad == null ||
        _jornada == null ||
        _estado == null) {
      setState(() {});
      return;
    }
    widget.onGuardar(
      NuevoMedicoInput(
        nombreCompleto: _nombre.text.trim(),
        correo: _correo.text.trim(),
        telefono: _telefono.text.trim(),
        documento: _documento.text.trim(),
        especialidad: _especialidad!,
        jornada: _jornada!,
        estado: _estado!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height * 0.86;
    return Container(
      constraints: BoxConstraints(maxHeight: h),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F7F4),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFC6D7CE), width: 1.2),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Registrar nuevo medico',
                      style: TextStyle(
                        color: Color(0xFF22362C),
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onCerrar,
                    icon: const Icon(Icons.close),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const _ET('Nombre completo'),
              TextFormField(
                controller: _nombre,
                validator: _r,
                decoration: _d('Nombre y apellidos'),
              ),
              const SizedBox(height: 10),
              const _ET('Correo'),
              TextFormField(
                controller: _correo,
                validator: _c,
                keyboardType: TextInputType.emailAddress,
                decoration: _d('correo@dominio.com'),
              ),
              const SizedBox(height: 10),
              const _ET('Telefono'),
              TextFormField(
                controller: _telefono,
                validator: _r,
                keyboardType: TextInputType.phone,
                decoration: _d('Telefono de contacto'),
              ),
              const SizedBox(height: 10),
              const _ET('Documento'),
              TextFormField(
                controller: _documento,
                validator: _r,
                decoration: _d('Numero'),
              ),
              const SizedBox(height: 10),
              const _ET('Especialidad'),
              DropdownButtonFormField<String>(
                initialValue: _especialidad,
                validator: (v) => v == null ? '' : null,
                decoration: _d('Seleccionar especialidad'),
                items: especialidadesMedicasMock
                    .map(
                      (v) => DropdownMenuItem<String>(value: v, child: Text(v)),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _especialidad = v),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _ET('Jornada'),
                        DropdownButtonFormField<String>(
                          initialValue: _jornada,
                          validator: (v) => v == null ? '' : null,
                          decoration: _d('Jornada'),
                          items: jornadasMedicasMock
                              .map(
                                (v) => DropdownMenuItem<String>(
                                  value: v,
                                  child: Text(v),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _jornada = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _ET('Estado'),
                        DropdownButtonFormField<String>(
                          initialValue: _estado,
                          validator: (v) => v == null ? '' : null,
                          decoration: _d('Estado'),
                          items: estadosMedicoMock
                              .map(
                                (v) => DropdownMenuItem<String>(
                                  value: v,
                                  child: Text(v),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _estado = v),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _guardar,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFF1E6246),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Guardar medico',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ET extends StatelessWidget {
  const _ET(this.t);
  final String t;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 5),
      child: Text(
        t,
        style: const TextStyle(
          color: Color(0xFF4A5B58),
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
