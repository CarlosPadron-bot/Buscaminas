import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Carga.dart';
// import 'main.dart'; // Eliminado para evitar imports circulares innecesarios si este ya es el main

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buscaminas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home:
          const VideoBackgroundScreen(), // Cambiado aquí para probar directamente tu pantalla
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
          // Se cambió print por debugPrint para solucionar el aviso 'avoid_print' en producción
          debugPrint("Error al cargar el video: $error");
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
                    // CORRECCIÓN: Agregado un Row para contener los botones horizontalmente
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: PixelButton(
                            text: 'OPCIONES',
                            baseColor: const Color.fromARGB(255, 179, 154, 113),
                            onPressed: () {
                              Botones.mostrar(
                                context,
                                titulo: 'OPCIONES',
                                contenido: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text(
                                      'Volumen: ||||||||||',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Dificultad: Normal',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: PixelButton(
                            text: 'INSTRUCCIONES',
                            baseColor: Colors.amber.shade700,
                            onPressed: () {
                              Botones.mostrar(
                                context,
                                titulo: 'INSTRUCCIONES',
                                contenido: const Text(
                                  '''Click Izq: Descubrir casilla\nClick Der: Colocar bandera\n\n¡Evita las minas para ganar!\n\nEl juego consiste en despejar todas las casillas que no oculten una mina.\n\nSi descubres una mina pierdes.''',
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
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: PixelButton(
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
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            },
                          ),
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
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 20,
            ), // Ajustado el padding excesivo para que quepan en pantalla
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
              side: const BorderSide(color: Color(0xFF1A1A1A), width: 2),
            ),
          ),
          onPressed: widget.onPressed,
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: GoogleFonts.pressStart2p(
              fontSize:
                  10, // Bajado un poco el tamaño de fuente para que no se desborde el texto pixelado
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// SOLUCIÓN: Clase 'Botones' encargada de fabricar y mostrar el mini menú
// =========================================================================
class Botones {
  static void mostrar(
    BuildContext context, {
    required String titulo,
    required Widget contenido,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF222831),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: const BorderSide(color: Color(0xFF11141A), width: 3),
          ),
          title: Text(
            titulo,
            textAlign: TextAlign.center,
            style: GoogleFonts.pressStart2p(color: Colors.amber, fontSize: 16),
          ),
          content: SingleChildScrollView(child: contenido),
          actions: [
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF11141A),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'CERRAR',
                  style: GoogleFonts.pressStart2p(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
