import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Carga.dart';
import 'botones.dart'; // Tu clase de menú flotante

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buscaminas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CargaPantalla(),
    );
  }
}

class VideoBackgroundScreen extends StatefulWidget {
  const VideoBackgroundScreen({super.key});

  @override
  State<VideoBackgroundScreen> createState() => _VideoBackgroundScreenState();
}

class _VideoBackgroundScreenState extends State<VideoBackgroundScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  // --- VARIABLES DE ESTADO PARA LAS OPCIONES ---
  int _volumen = 80; // Inicia en 80%
  String _dificultad = 'MEDIO'; // Inicia en MEDIO

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/PantallaInicial.mp4');
    _controller.setVolume(0.0);
    _controller
        .initialize()
        .then((_) {
          _controller.setLooping(true);
          _controller.play();
          setState(() {
            _isInitialized = true;
          });
        })
        .catchError((error) {
          print("Error al cargar el video: $error");
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                alignment: Alignment.center,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
            )
          else
            Container(color: Colors.black),

          SafeArea(
            child: Column(
              children: [
                const Expanded(
                  child: Center(
                    child: Text(
                      'BUSCAMINAS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                        shadows: [
                          Shadow(
                            blurRadius: 15.0,
                            color: Colors.black,
                            offset: Offset(3.0, 3.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                BounceInUp(
                  duration: const Duration(milliseconds: 900),
                  delay: const Duration(seconds: 2),
                  from: 400,
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 50.0,
                      left: 20.0,
                      right: 20.0,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 22.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF222831),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: const Color(0xFF11141A),
                        width: 4,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PixelButton(
                          text: 'JUGAR',
                          baseColor: Colors.green.shade600,
                          onPressed: () {},
                        ),
                        const SizedBox(width: 12),

                        // --- MENÚ OPCIONES INTERACTIVO ---
                        PixelButton(
                          text: 'OPCIONES',
                          baseColor: const Color.fromARGB(255, 179, 154, 113),
                          onPressed: () {
                            Botones.mostrar(
                              context,
                              titulo: 'OPCIONES',
                              // El StatefulBuilder permite actualizar el estado del diálogo en tiempo real
                              contenido: StatefulBuilder(
                                builder:
                                    (
                                      BuildContext context,
                                      StateSetter setDialogState,
                                    ) {
                                      // Genera dinámicamente las barras del volumen (ej: 80% = ||||||||)
                                      String barrasVolumen =
                                          '|' * (_volumen ~/ 10);

                                      return Column(
                                        children: [
                                          // Control de Volumen
                                          Text(
                                            'VOLUMEN',
                                            style: GoogleFonts.pressStart2p(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              _miniBotonRetro('-', () {
                                                if (_volumen > 0) {
                                                  setDialogState(() {
                                                    _volumen -= 10;
                                                  });
                                                }
                                              }),
                                              const SizedBox(width: 15),
                                              SizedBox(
                                                width:
                                                    160, // Ancho fijo para evitar que los botones se muevan
                                                child: Text(
                                                  '$barrasVolumen $_volumen%',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Colors.greenAccent,
                                                    fontFamily: 'Courier',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 15),
                                              _miniBotonRetro('+', () {
                                                if (_volumen < 100) {
                                                  setDialogState(() {
                                                    _volumen += 10;
                                                  });
                                                }
                                              }),
                                            ],
                                          ),
                                          const SizedBox(height: 25),

                                          // Control de Dificultad
                                          Text(
                                            'DIFICULTAD',
                                            style: GoogleFonts.pressStart2p(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Wrap(
                                            spacing: 10,
                                            runSpacing: 10,
                                            alignment: WrapAlignment.center,
                                            children: [
                                              _miniBotonRetro(
                                                'FÁCIL',
                                                () {
                                                  setDialogState(() {
                                                    _dificultad = 'FÁCIL';
                                                  });
                                                },
                                                activo: _dificultad == 'FÁCIL',
                                              ),

                                              _miniBotonRetro(
                                                'MEDIO',
                                                () {
                                                  setDialogState(() {
                                                    _dificultad = 'MEDIO';
                                                  });
                                                },
                                                activo: _dificultad == 'MEDIO',
                                              ),

                                              _miniBotonRetro(
                                                'DIFÍCIL',
                                                () {
                                                  setDialogState(() {
                                                    _dificultad = 'DIFÍCIL';
                                                  });
                                                },
                                                activo:
                                                    _dificultad == 'DIFÍCIL',
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 12),

                        PixelButton(
                          text: 'INSTRUCCIONES',
                          baseColor: Colors.amber.shade700,
                          onPressed: () {
                            Botones.mostrar(
                              context,
                              titulo: 'INSTRUCCIONES',
                              contenido: const Text(
                                'Click Izq: Descubrir casilla\nClick Der: Colocar bandera\n\n¡Evita las minas para ganar!\n\nEl juego consiste en despejar todas las casillas que no oculten una mina.\n\nLos números indican cuántas minas hay a su alrededor.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 12),

                        PixelButton(
                          text: 'CRÉDITOS',
                          baseColor: Colors.blue.shade700,
                          onPressed: () {
                            Botones.mostrar(
                              context,
                              titulo: 'CRÉDITOS',
                              contenido: const Text(
                                'Desarrollado por:\nAntonio Barriola y Carlos Padron\n\nMotor: Flutter\n\n¡Gracias por jugar!',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Generador de mini botones para la interfaz interna de opciones
  Widget _miniBotonRetro(
    String texto,
    VoidCallback accion, {
    bool activo = false,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: activo
            ? Colors.cyan.shade700
            : const Color(0xFF393E46),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
          side: BorderSide(
            color: activo ? Colors.white : const Color(0xFF11141A),
            width: 2,
          ),
        ),
        elevation: 2,
      ),
      onPressed: accion,
      child: Text(texto, style: GoogleFonts.pressStart2p(fontSize: 10)),
    );
  }
}

class PixelButton extends StatefulWidget {
  final String text;
  final Color baseColor;
  final VoidCallback onPressed;

  const PixelButton({
    super.key,
    required this.text,
    required this.baseColor,
    required this.onPressed,
  });

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final Color finalColor = _isHovered
        ? BorderSide.lerp(
            BorderSide(color: widget.baseColor),
            const BorderSide(color: Colors.black),
            0.25,
          ).color
        : widget.baseColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: finalColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 50),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
              side: const BorderSide(color: Color(0xFF1A1A1A), width: 2),
            ),
          ),
          onPressed: widget.onPressed,
          child: Text(
            widget.text,
            style: GoogleFonts.pressStart2p(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
