

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petcontrol/ui/core/tema/app_colores.dart';

final ThemeData temaApp = ThemeData(
  scaffoldBackgroundColor: AppColores.blanco,
  textTheme: GoogleFonts.montserratTextTheme(
    ThemeData.light().textTheme,
  ),
);