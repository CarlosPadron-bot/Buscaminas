import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'botones.dart';

class HighScoreScreen extends StatelessWidget {
  const HighScoreScreen({super.key});

  static void mostrar(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const HighScoreScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: BounceInUp(
        duration: const Duration(milliseconds: 800),
        from: 600,
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(30.0),
          decoration: BoxDecoration(
            color: const Color(0xFF222831),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: const Color(0xFF11141A), width: 4),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'CLASIFICACIONES',
                style: GoogleFonts.pressStart2p(
                  color: Colors.amber.shade600,
                  fontSize: 20,
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
              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Todavía no hay records disponibles, ¡juega una partida y supera tus records!',
                  style: GoogleFonts.pressStart2p(
                    color: Colors.white70,
                    fontSize: 10,
                    height: 2.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 50),

              BotonMenuOpciones(
                texto: 'VOLVER',
                colorBase: Colors.red.shade700,
                ancho: 200,
                fontSize: 12,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
