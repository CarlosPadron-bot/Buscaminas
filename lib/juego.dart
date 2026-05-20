import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'logica.dart';
import 'highscore.dart';
import 'historial.dart';

class ConfiguracionJuego {
  final int filas;
  final int columnas;
  final int minas;

  ConfiguracionJuego({
    required this.filas,
    required this.columnas,
    required this.minas,
  });
}

class TableroJuego extends StatefulWidget {
  final ConfiguracionJuego configuracion;
  final VoidCallback onBack;
  final String temaActual;

  const TableroJuego({
    super.key,
    required this.configuracion,
    required this.onBack,
    required this.temaActual,
  });

  @override
  State<TableroJuego> createState() => _TableroJuegoState();
}

class _TableroJuegoState extends State<TableroJuego> {
  late BuscaminasLogica juego;
  Timer? _timer;
  int _segundos = 0;
  int _intentos = 0;

  @override
  void initState() {
    super.initState();
    _iniciarJuego();
  }

  void _iniciarJuego() {
    juego = BuscaminasLogica(
      filas: widget.configuracion.filas,
      columnas: widget.configuracion.columnas,
      totalMinas: widget.configuracion.minas,
    );
    _segundos = 0;
    _intentos = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _segundos++);
      }
    });
  }

  void _perderJuego() {
    _timer?.cancel();
    _registrarPartida();
    setState(() {
      juego.juegoTerminado = true;
    });
  }

  void _registrarPartida() {
    historialPartidas.add(Partida(
      fecha: DateTime.now(),
      segundos: _segundos,
      intentos: _intentos,
    ));
  }

  Color _obtenerColorNumero(int n) {
    switch (n) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      case 4:
        return Colors.purple;
      default:
        return Colors.amber;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool esOscuro = widget.temaActual == 'oscuro';
    final Color colorFondoTablero = esOscuro
        ? const Color(0xFF222831).withOpacity(0.85)
        : Colors.white.withOpacity(0.9);
    final Color colorBordeTablero =
        esOscuro ? const Color(0xFF11141A) : Colors.grey.shade400;

    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _infoCuadro("TIEMPO", _segundos.toString().padLeft(3, '0')),
                const SizedBox(width: 30),
                _infoCuadro("MINAS", widget.configuracion.minas.toString()),
                const SizedBox(width: 30),
                _infoCuadro("INTENTOS", _intentos.toString()),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: FadeInDown(
                  from: 600,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: colorFondoTablero,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colorBordeTablero, width: 4),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black54,
                            blurRadius: 15,
                            offset: Offset(0, 8)),
                      ],
                    ),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: widget.configuracion.columnas,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemCount: widget.configuracion.filas *
                            widget.configuracion.columnas,
                        itemBuilder: (context, index) {
                          final int f = index ~/ widget.configuracion.columnas;
                          final int c = index % widget.configuracion.columnas;
                          final casilla = juego.tablero[f][c];

                          return GestureDetector(
                            onTap: () {
                              if (!juego.juegoTerminado) {
                                setState(() {
                                  _intentos++;
                                  if (juego.revelarCasilla(f, c)) {
                                    _perderJuego();
                                  }
                                });
                              }
                            },
                            onSecondaryTap: () {
                              if (!juego.juegoTerminado) {
                                setState(() => juego.alternarBandera(f, c));
                              }
                            },
                            child: _buildCasilla(casilla),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.black, width: 2),
                  ),
                ),
                onPressed: widget.onBack,
                child: Text(
                  'VOLVER AL MENÚ',
                  style: GoogleFonts.pressStart2p(
                      fontSize: 10, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        if (juego.juegoTerminado) _buildGameOverOverlay(),
      ],
    );
  }

  Widget _buildCasilla(Casilla c) {
    if (!c.revelada) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF393E46),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFF1A1A1A), width: 2),
        ),
        child: c.tieneBandera
            ? const Icon(Icons.flag, color: Colors.red, size: 16)
            : null,
      );
    }

    return FadeIn(
      duration: const Duration(milliseconds: 300),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.black12, width: 1),
        ),
        child: Center(
          child: c.tieneBomba
              ? Image.asset('assets/imagenes/Bomba.png')
              : c.bombasAdyacentes > 0
                  ? Text(
                      '${c.bombasAdyacentes}',
                      style: GoogleFonts.pressStart2p(
                        fontSize: 14,
                        color: _obtenerColorNumero(c.bombasAdyacentes),
                      ),
                    )
                  : null,
        ),
      ),
    );
  }

  Widget _buildGameOverOverlay() {
    return Container(
      color: Colors.black87,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ZoomIn(
            child: Text('GAME OVER',
                style:
                    GoogleFonts.pressStart2p(color: Colors.red, fontSize: 40)),
          ),
          const SizedBox(height: 40),

          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade800),
            onPressed: () =>
                HighScoreScreen.mostrar(context, tiempo: _segundos),
            child: Text('VER CLASIFICACIÓN',
                style: GoogleFonts.pressStart2p(
                    fontSize: 10, color: Colors.white)),
          ),

          const SizedBox(height: 15),

          // Botón Reintentar
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF393E46)),
            onPressed: () => setState(() => _iniciarJuego()),
            child: Text('REINTENTAR',
                style: GoogleFonts.pressStart2p(
                    fontSize: 10, color: Colors.white)),
          ),

          const SizedBox(height: 15),

          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.red.shade900),
            onPressed: widget.onBack,
            child: Text('VOLVER AL MENÚ',
                style: GoogleFonts.pressStart2p(
                    fontSize: 10, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _infoCuadro(String etiqueta, String valor) {
    return Column(
      children: [
        Text(etiqueta,
            style:
                GoogleFonts.pressStart2p(color: Colors.white54, fontSize: 8)),
        const SizedBox(height: 5),
        Text(valor,
            style: GoogleFonts.pressStart2p(color: Colors.white, fontSize: 16)),
      ],
    );
  }
}
