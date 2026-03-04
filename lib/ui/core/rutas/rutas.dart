abstract final class Rutas {
  static const raiz = '/';
  static const bienvenidaPage = '/WelcomePage';
  static const loginPage = '/LoginPage';
  static const registerPage = '/RegisterPage';
  static const homeAdminPage = '/HomeAdminPage';
  static const adminPacientesPage = '$homeAdminPage/Pacientes';
  static const adminCitasPage = '$homeAdminPage/Citas';
  static const adminHistorialCitasPage = '$homeAdminPage/HistorialCitas';
  static const adminPersonalMedicoPage = '$homeAdminPage/PersonalMedico';
  static const homeClientePage = '/HomeClientePage';
  static const clienteMisMascotasPage = '$homeClientePage/MisMascotas';
  static const clienteMisCitasPage = '$homeClientePage/MisCitas';
}
