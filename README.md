# petcontrol

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Explicacion de la estructura de la carpeta /lib
---
## 📂 Estructura del Proyecto – PetControl

Este proyecto sigue una **arquitectura modular** orientada a separación de responsabilidades, permitiendo **escalabilidad**, mantenimiento sencillo y futura integración con *Firebase*.

### 📁 lib/

Contiene todo el código fuente principal de la aplicación Flutter.

---

#### 📁 core/

Elementos globales reutilizables en toda la aplicación.

- **📁 rutas/**  
  Gestión de la navegación:
  - `rutas.dart`: Define los nombres de rutas (constantes String) utilizadas en la navegación.
  - `app_router.dart`: Configura la navegación general (`MaterialApp`, `onGenerateRoute`, etc.).
  - 👉 *Centraliza la navegación y evita errores por rutas duplicadas.*

- **📁 tema/**  
  Diseño visual global:
  - `tema_app.dart`: Define el `ThemeData`, colores, estilos de texto, botones, etc.
  - 👉 *Mantiene la consistencia visual en toda la app.*

- **📁 constantes/**  
  Valores constantes globales:
  - `constantes.dart`: Textos estáticos, claves, tamaños, configuraciones generales.
  - 👉 *Evita la duplicidad de "valores mágicos".*

- **📁 widgets/**  
  Componentes reutilizables:
  - Ejemplos:  
    - `boton_principal.dart`
    - `campo_texto.dart`
    - `tarjeta_cita.dart`
  - 👉 *Favorece la reutilización y coherencia visual.*

---

#### 📁 dominio/

Representa el **modelo conceptual** del sistema (basado en el diagrama de clases UML). Define la lógica estructural **independiente de la UI y la base de datos**.

- **📁 modelos/**  
  Entidades principales del dominio:
  - `usuario.dart`
  - `mascota.dart`
  - `cita.dart`
  - 👉 *Clases alineadas con el modelo UML.*

- **📁 enums/**  
  Tipos enumerados del sistema:
  - `rol_usuario.dart`, `especie.dart`, `sexo_mascota.dart`, `estado_cita.dart`
  - 👉 *Controla valores válidos, evita el uso de strings sueltos.*

---

#### 📁 features/

Módulos organizados por **características** del sistema. Cada feature contiene sus propias pantallas y widgets.

- **📁 autenticacion/**
  - **pantallas/**
    - `login_pantalla.dart`
    - `registro_pantalla.dart`
  - **widgets/**
    - `formulario_login.dart`
  - 👉 *Controla acceso según rol (admin o cliente).*

- **📁 cliente/**
  - **pantallas/**
    - `home_cliente.dart`, `mascotas_pantalla.dart`, `mascota_formulario.dart`, `detalle_mascota.dart`
    - `citas_pantalla.dart`, `cita_formulario.dart`, `detalle_cita.dart`
  - **widgets/**
    - `tarjeta_mascota.dart`, `chip_estado_cita.dart`
  - 👉 *Registrar mascotas, agendar citas, ver historial.*

- **📁 admin/**
  - **pantallas/**
    - `home_admin.dart`, `agenda_pantalla.dart`, `calendario_pantalla.dart`, `detalle_cita_admin.dart`
  - **widgets/**
    - `tarjeta_cita_admin.dart`
  - 👉 *Gestiona citas programadas y su estado.*

---

#### 📁 data/

Manejo y acceso a los datos (independiente de UI y dominio).

- **📁 mock/**  
  Datos simulados para el desarrollo frontend:
  - `usuarios_mock.dart`, `mascotas_mock.dart`, `citas_mock.dart`
  - 👉 *Permite desarrollar la interfaz sin depender de Firebase.*

- **📁 repositorios/**  
  Clases para acceso/manipulación de datos:
  - `usuario_repo.dart`, `mascota_repo.dart`, `cita_repo.dart`
  - 👉 *Intermediario entre la UI y la fuente de datos.*

---

### 🎯 Beneficios de esta Arquitectura

- Separación clara entre **UI**, **dominio** y **datos**
- Escalable para integración con **Firebase**
- Mantenimiento sencillo y modularidad
- Profesional y alineada con buenas prácticas (Clean Architecture ready)
- Facilita pruebas y futuros cambios

---