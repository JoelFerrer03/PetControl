import 'package:flutter/material.dart';
import 'package:petcontrol/ui/core/rutas/rutas.dart';
import 'package:petcontrol/ui/features/admin/pantallas/Historial%20de%20citas.dart';
import 'package:petcontrol/ui/features/admin/pantallas/Personal%20medico.dart';
import 'package:petcontrol/ui/features/admin/pantallas/Vista%20cita%20admin.dart';
import 'package:petcontrol/ui/features/admin/pantallas/Vista%20pacientes%20admin.dart';
import 'package:petcontrol/ui/features/admin/pantallas/home_admin.dart';
import 'package:petcontrol/ui/features/autenticacion/pantallas/bienvenida_pantalla.dart';
import 'package:petcontrol/ui/features/autenticacion/pantallas/login_pantalla.dart';
import 'package:petcontrol/ui/features/autenticacion/pantallas/registro_pantalla.dart';
import 'package:petcontrol/ui/features/cliente/pantallas/home_cliente.dart';
import 'package:petcontrol/ui/features/cliente/pantallas/mis_citas_cliente.dart';
import 'package:petcontrol/ui/features/cliente/pantallas/mis_mascotas_cliente.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Rutas.raiz:
      case Rutas.bienvenidaPage:
        return _ruta(const BienvenidaPantalla(), Rutas.bienvenidaPage);
      case Rutas.loginPage:
        return _ruta(const LoginPantalla(), Rutas.loginPage);
      case Rutas.registerPage:
        return _ruta(const RegistroPantalla(), Rutas.registerPage);
      case Rutas.homeAdminPage:
        return _ruta(const HomeAdmin(), Rutas.homeAdminPage);
      case Rutas.adminPacientesPage:
        return _ruta(const VistaPacientesAdmin(), Rutas.adminPacientesPage);
      case Rutas.adminCitasPage:
        return _ruta(const VistaCitaAdmin(), Rutas.adminCitasPage);
      case Rutas.adminHistorialCitasPage:
        return _ruta(
          const HistorialMedicoAdmin(),
          Rutas.adminHistorialCitasPage,
        );
      case Rutas.adminPersonalMedicoPage:
        return _ruta(
          const PersonalMedicoAdmin(),
          Rutas.adminPersonalMedicoPage,
        );
      case Rutas.homeClientePage:
        return _ruta(const HomeCliente(), Rutas.homeClientePage);
      case Rutas.clienteMisMascotasPage:
        return _ruta(const MisMascotasCliente(), Rutas.clienteMisMascotasPage);
      case Rutas.clienteMisCitasPage:
        return _ruta(const MisCitasCliente(), Rutas.clienteMisCitasPage);
      default:
        return _ruta(const BienvenidaPantalla(), Rutas.bienvenidaPage);
    }
  }

  static MaterialPageRoute<dynamic> _ruta(Widget screen, String routeName) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => screen,
    );
  }
}
