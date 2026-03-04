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
    final size = MediaQuery.of(context).size;
    final alturaCurva = (size.height * 0.62).clamp(540.0, 760.0);
    final lista = _personalFiltrado;

    return Scaffold(
      backgroundColor: const Color(0xFFECECEC),
      floatingActionButton: SizedBox(
        width: 62,
        height: 62,
        child: FloatingActionButton(
          onPressed: _abrirFormularioNuevoMedico,
          backgroundColor: AppColores.verdepacientes,
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
                    colors: [
                      AppColores.verdepacientes,
                      AppColores.verdepacientes,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipPath(
                clipper: _CurvaPersonalClipper(),
                child: Container(
                  color: const Color(0xFFECECEC),
                  height: alturaCurva,
                  width: double.infinity,
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 22,
                        ),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 24,
                          minHeight: 24,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Personal medico',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _ResumenBox(
                        valor: '${_personal.length}',
                        etiqueta: 'Total',
                        color: AppColores.textoAzul,
                      ),
                      const SizedBox(width: 10),
                      _ResumenBox(
                        valor: '${_conteoEstado('Activo')}',
                        etiqueta: 'Activos',
                        color: AppColores.verdepacientes,
                      ),
                      const SizedBox(width: 10),
                      _ResumenBox(
                        valor: '${_conteoEstado('Vacaciones')}',
                        etiqueta: 'Vacaciones',
                        color: const Color(0xFF8A6A40),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 44,
                    child: TextField(
                      controller: _busquedaCtrl,
                      onChanged: (_) => setState(() {}),
                      cursorColor: AppColores.negro,
                      decoration: InputDecoration(
                        hintText: 'Buscar por nombre, especialidad o correo...',
                        hintStyle: const TextStyle(
                          color: Color(0xFF5C646A),
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 20,
                          color: Color(0xFF5C646A),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFEAEAEA),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.black87,
                            width: 1.05,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1.25,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
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
                      if (i < lista.length - 1) const SizedBox(height: 14),
                    ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurvaPersonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.30);
    path.quadraticBezierTo(
      size.width * 0.20,
      size.height * 0.44,
      size.width * 0.50,
      size.height * 0.54,
    );
    path.quadraticBezierTo(
      size.width * 0.80,
      size.height * 0.63,
      size.width,
      size.height * 0.51,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _ResumenBox extends StatelessWidget {
  const _ResumenBox({
    required this.valor,
    required this.etiqueta,
    required this.color,
  });

  final String valor;
  final String etiqueta;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        constraints: const BoxConstraints(minHeight: 86),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFE6EAEA),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black38, width: 1.05),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              valor,
              style: TextStyle(
                color: color,
                fontSize: 28,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              etiqueta,
              style: const TextStyle(
                color: Color(0xFF5B656B),
                fontSize: 13,
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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF4B4B4B), width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
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
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        Text(
                          medico.nombreCompleto,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1D2730),
                            height: 1,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9E8E1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            medico.especialidad,
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2D7C62),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colorBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            medico.estado,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: colorText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      medico.correo,
                      style: const TextStyle(
                        color: Color(0xFF4F5A61),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      medico.telefono,
                      style: const TextStyle(
                        color: Color(0xFF637077),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
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

class _VacioPersonal extends StatelessWidget {
  const _VacioPersonal();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB6B6B6)),
      ),
      child: const Column(
        children: [
          Icon(Icons.search_off_rounded, color: Color(0xFF5E6970), size: 30),
          SizedBox(height: 12),
          Text(
            'No hay personal medico para los filtros actuales.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF5E6970),
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
      fillColor: const Color(0xFFE8EBEA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFCDD4D1), width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF5ABF9A), width: 1.7),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFB53939), width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
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
        color: const Color(0xFFDCDDDB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF1A95F7), width: 2),
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
                        color: Color(0xFF223633),
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
                    backgroundColor: const Color(0xFF0E8D63),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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
