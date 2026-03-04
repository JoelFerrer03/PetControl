class UsuarioRegistradoMock {
  const UsuarioRegistradoMock({
    required this.id,
    required this.nombre,
  });

  final String id;
  final String nombre;
}

const usuariosRegistradosMock = <UsuarioRegistradoMock>[
  UsuarioRegistradoMock(id: 'u1', nombre: 'Maria Garcia'),
  UsuarioRegistradoMock(id: 'u2', nombre: 'Carlos Rodriguez'),
  UsuarioRegistradoMock(id: 'u3', nombre: 'Ana Torres'),
  UsuarioRegistradoMock(id: 'u4', nombre: 'Luis Perez'),
  UsuarioRegistradoMock(id: 'u5', nombre: 'Paula Gomez'),
];

const correoAdminMock = 'admin@admin.com';
const contrasenaAdminMock = 'admin';
const correoUserMock = 'user@user.com';
const contrasenaUserMock = 'user';

const duracionSimulacionAuthMock = Duration(milliseconds: 900);
const mensajeCredencialesInvalidasMock = 'Credenciales incorrectas';
const mensajeRegistroExitosoMock = 'Registro mock correcto';
