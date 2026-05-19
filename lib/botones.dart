import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Esta es tu clase "Botones"
class Botones extends StatelessWidget {
  final String titulo;
  final Widget contenido;

  const Botones({super.key, required this.titulo, required this.contenido});

  // El método estático para invocarlo desde fuera
  static void mostrar(
    BuildContext context, {
    required String titulo,
    required Widget contenido,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Botones(titulo: titulo, contenido: contenido);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: const Color(0xFF222831),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: const Color(0xFF11141A), width: 4),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              titulo,
              style: GoogleFonts.pressStart2p(
                color: Colors.white,
                fontSize: 18,
                shadows: const [
                  Shadow(
                    blurRadius: 5.0,
                    color: Colors.black,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            contenido, // Recibe el texto de opciones/créditos desde el main

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  side: const BorderSide(color: Color(0xFF1A1A1A), width: 2),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'CERRAR',
                style: GoogleFonts.pressStart2p(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
