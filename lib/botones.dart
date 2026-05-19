import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'highscore.dart';

class Botones extends StatefulWidget {
  final String titulo;
  final Widget contenidoDinamico;
  final double anchoCerrar;

  const Botones({
    super.key,
    required this.titulo,
    required this.contenidoDinamico,
    this.anchoCerrar = 400,
  });

  static void mostrar(
    BuildContext context, {
    required String titulo,
    required Widget contenido,
    double anchoCerrar = 400,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Botones(
          titulo: titulo,
          contenidoDinamico: contenido,
          anchoCerrar: anchoCerrar,
        );
      },
    );
  }

  @override
  State<Botones> createState() => BotonesState();
}

class BotonesState extends State<Botones> {
  bool animacionesActivas = true;
  String temaSeleccionado = 'oscuro';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: BounceInUp(
        duration: const Duration(milliseconds: 800),
        from: 600,
        child: Container(
          width: 450,
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.titulo,
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

                widget.contenidoDinamico,

                if (widget.titulo == 'OPCIONES') ...[
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 10),
                  buildEtiqueta('TEMA'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BotonMenuOpciones(
                        texto: 'CLARO',
                        colorBase: temaSeleccionado == 'claro'
                            ? Colors.cyan.shade600
                            : Colors.grey.shade700,
                        ancho: 110,
                        onPressed: () =>
                            setState(() => temaSeleccionado = 'claro'),
                      ),
                      const SizedBox(width: 10),
                      BotonMenuOpciones(
                        texto: 'OSCURO',
                        colorBase: temaSeleccionado == 'oscuro'
                            ? Colors.cyan.shade600
                            : Colors.grey.shade700,
                        ancho: 110,
                        onPressed: () =>
                            setState(() => temaSeleccionado = 'oscuro'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  buildEtiqueta('ANIMACIONES'),
                  const SizedBox(height: 10),
                  BotonMenuOpciones(
                    texto: animacionesActivas ? 'ACTIVADAS' : 'DESACTIVADAS',
                    colorBase: animacionesActivas
                        ? Colors.green.shade700
                        : Colors.red.shade900,
                    ancho: 220,
                    onPressed: () => setState(
                      () => animacionesActivas = !animacionesActivas,
                    ),
                  ),
                  const SizedBox(height: 25),
                  BotonMenuOpciones(
                    texto: 'CLASIFICACIONES',
                    colorBase: const Color.fromARGB(255, 212, 151, 17),
                    ancho: 250,
                    fontSize: 10,
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pop(); // Cerramos primero el menú de Opciones
                      HighScoreScreen.mostrar(context);
                    },
                  ),
                ],
                const SizedBox(height: 30),
                BotonMenuOpciones(
                  texto: 'CERRAR',
                  colorBase: Colors.red.shade700,
                  ancho: widget.anchoCerrar,
                  fontSize: 12,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEtiqueta(String texto) {
    return Text(
      texto,
      style: GoogleFonts.pressStart2p(color: Colors.white70, fontSize: 10),
    );
  }
}

class BotonMenuOpciones extends StatefulWidget {
  final String texto;
  final Color colorBase;
  final VoidCallback onPressed;
  final double ancho;
  final double fontSize;

  const BotonMenuOpciones({
    super.key,
    required this.texto,
    required this.colorBase,
    required this.onPressed,
    this.ancho = 110,
    this.fontSize = 10,
  });

  @override
  State<BotonMenuOpciones> createState() => _BotonMenuOpcionesState();
}

class _BotonMenuOpcionesState extends State<BotonMenuOpciones> {
  bool estaEncima = false;

  @override
  Widget build(BuildContext context) {
    final Color colorFinal = estaEncima
        ? Color.lerp(widget.colorBase, Colors.black, 0.25)!
        : widget.colorBase;

    return MouseRegion(
      onEnter: (_) => setState(() => estaEncima = true),
      onExit: (_) => setState(() => estaEncima = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.ancho,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorFinal,
            padding: const EdgeInsets.symmetric(vertical: 15),
            elevation: estaEncima ? 8 : 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
              side: const BorderSide(color: Color(0xFF1A1A1A), width: 2),
            ),
          ),
          onPressed: widget.onPressed,
          child: Text(
            widget.texto,
            style: GoogleFonts.pressStart2p(
              fontSize: widget.fontSize,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
