import 'package:flutter/material.dart';
import 'package:petcontrol/ui/core/tema/app_colores.dart';

class DetalleCampo {
  const DetalleCampo({required this.etiqueta, required this.valor});

  final String etiqueta;
  final String valor;
}

class ConfigPopupDetalle {
  const ConfigPopupDetalle({
    required this.titulo,
    required this.icono,
    required this.campos,
    this.subtitulo,
    this.chips = const <String>[],
    this.colorAcento = AppColores.verdepacientes,
  });

  final String titulo;
  final String? subtitulo;
  final IconData icono;
  final List<String> chips;
  final List<DetalleCampo> campos;
  final Color colorAcento;
}

Future<void> mostrarPopupDetalle(
  BuildContext context,
  ConfigPopupDetalle config,
) async {
  await showGeneralDialog<void>(
    context: context,
    barrierLabel: 'popup_detalle',
    barrierDismissible: true,
    barrierColor: Colors.black45,
    transitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 24),
            child: Material(
              color: Colors.transparent,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(dialogContext).size.height * 0.86,
                  ),
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8EBEA),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.black87, width: 1),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: config.colorAcento.withValues(alpha: 0.18),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              config.icono,
                              color: config.colorAcento,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  config.titulo,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1F2A2D),
                                    height: 1.05,
                                  ),
                                ),
                                if (config.subtitulo != null &&
                                    config.subtitulo!.trim().isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    config.subtitulo!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF5B666B),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            icon: const Icon(Icons.close, size: 20),
                            visualDensity: VisualDensity.compact,
                            tooltip: 'Cerrar',
                          ),
                        ],
                      ),
                      if (config.chips.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: config.chips
                              .where((chip) => chip.trim().isNotEmpty)
                              .map(
                                (chip) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD9E5E0),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: const Color(0xFF8AA195),
                                    ),
                                  ),
                                  child: Text(
                                    chip,
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF355046),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            children: config.campos
                                .where((campo) => campo.valor.trim().isNotEmpty)
                                .map(
                                  (campo) => _CampoDetalle(
                                    etiqueta: campo.etiqueta,
                                    valor: campo.valor,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
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

class _CampoDetalle extends StatelessWidget {
  const _CampoDetalle({required this.etiqueta, required this.valor});

  final String etiqueta;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD3DAD6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            etiqueta,
            style: const TextStyle(
              color: Color(0xFF596467),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            valor,
            style: const TextStyle(
              color: Color(0xFF2C3438),
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
