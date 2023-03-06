import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr/Presentation/global/widgets/colors.dart';
import 'package:qr/Presentation/pages/home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //!centralizando los colores de fondo de las páginas
      //! y el tipo de fuente de texto a usar en todo el proyecto
      theme: ThemeData(
        scaffoldBackgroundColor: kBrandSecondaryColor,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
