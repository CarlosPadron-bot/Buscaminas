import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'highscore.dart';

class Botones extends StatefulWidget {
  final String titulo;
  final Widget contenidoDinamico;
  final double anchoCerrar;
  final String temaInicial;
  final Function(String)? onTemaChanged;

  const Botones({
    super.key,
    required this.titulo,
    required this.contenidoDinamico,
    this.anchoCerrar = 400,
    required this.temaInicial,
    this.onTemaChanged,
  });

  static void mostrar(
    BuildContext context, {
    required String titulo,
    required String temaInicial,
    required Function(String) onTemaChanged,
    required Widget contenido,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Botones(
            titulo: titulo,
            temaInicial: temaInicial,
            onTemaChanged: onTemaChanged,
            contenidoDinamico: contenido,
          ),
        );
      },
    );
  }

  @override
  State<Botones> createState() => BotonesState();
}

class BotonesState extends State<Botones> {
  bool animacionesActivas = true;

  @override
  Widget build(BuildContext context) {
    // Definimos los colores basados en el tema que viene de widget.temaInicial
    final bool esOscuro = widget.temaInicial == 'oscuro';
    final Color colorFondoMesa =
        esOscuro ? const Color(0xFF222831) : Colors.white;
    final Color colorBorde =
        esOscuro ? const Color(0xFF11141A) : Colors.grey.shade400;
    final Color colorTextoPrincipal = esOscuro ? Colors.white : Colors.black;
    final Color colorSombra =
        esOscuro ? Colors.black54 : Colors.grey.withOpacity(0.3);

    return BounceInUp(
      duration: const Duration(milliseconds: 800),
      from: 600,
      child: Container(
        width: 450,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: colorFondoMesa, // Se actualiza al cambiar el tema
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: colorBorde, width: 4),
          boxShadow: [
            BoxShadow(
                color: colorSombra, blurRadius: 10, offset: const Offset(0, 5))
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.titulo,
                  style: GoogleFonts.pressStart2p(
                      color: colorTextoPrincipal, fontSize: 18)),
              const SizedBox(height: 25),
              DefaultTextStyle(
                style: GoogleFonts.pressStart2p(
                    color: colorTextoPrincipal, fontSize: 10, height: 1.5),
                child: Center(child: widget.contenidoDinamico),
              ),
              if (widget.titulo == 'OPCIONES') ...[
                const SizedBox(height: 20),
                Divider(color: esOscuro ? Colors.white24 : Colors.black12),
                const SizedBox(height: 10),
                buildEtiqueta('TEMA', colorTextoPrincipal),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BotonMenuOpciones(
                      texto: 'CLARO',
                      colorBase: widget.temaInicial == 'claro'
                          ? Colors.cyan.shade600
                          : Colors.grey.shade700,
                      onPressed: () {
                        widget.onTemaChanged?.call('claro');
                        setState(() {});
                      },
                    ),
                    const SizedBox(width: 10),
                    BotonMenuOpciones(
                      texto: 'OSCURO',
                      colorBase: widget.temaInicial == 'oscuro'
                          ? Colors.cyan.shade600
                          : Colors.grey.shade700,
                      onPressed: () {
                        widget.onTemaChanged?.call('oscuro');
                        setState(() {});
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                buildEtiqueta('ANIMACIONES', colorTextoPrincipal),
                const SizedBox(height: 10),
                BotonMenuOpciones(
                  texto: animacionesActivas ? 'ACTIVADAS' : 'DESACTIVADAS',
                  colorBase: animacionesActivas
                      ? Colors.green.shade700
                      : Colors.red.shade900,
                  ancho: 220,
                  onPressed: () =>
                      setState(() => animacionesActivas = !animacionesActivas),
                ),
                const SizedBox(height: 25),
                BotonMenuOpciones(
                  texto: 'CLASIFICACIONES',
                  colorBase: const Color.fromARGB(255, 212, 151, 17),
                  ancho: 250,
                  fontSize: 10,
                  onPressed: () {
                    Navigator.of(context).pop();
                    HighScoreScreen.mostrar(context);
                  },
                ),
              ],
              const SizedBox(height: 30),
              BotonMenuOpciones(
                texto: 'CERRAR',
                colorBase: Colors.red.shade700,
                ancho: widget.anchoCerrar,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEtiqueta(String texto, Color color) {
    return Text(texto,
        style: GoogleFonts.pressStart2p(
            color: color.withOpacity(0.7), fontSize: 10));
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
              side: const BorderSide(color: Color(0xFF1A1A1A), width: 2),
            ),
          ),
          onPressed: widget.onPressed,
          child: Text(widget.texto,
              style: GoogleFonts.pressStart2p(
                  fontSize: widget.fontSize, color: Colors.white)),
        ),
      ),
    );
  }
}
