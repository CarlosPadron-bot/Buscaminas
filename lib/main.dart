import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Carga.dart';
import 'botones.dart';

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
                  duration: const Duration(
                    milliseconds: 900,
                  ), //Duracion de la animacion
                  delay: const Duration(
                    seconds: 2,
                  ), //TIEMPO DE APARICION DE LA ANIMACION
                  from: 400, // altura de donde empieza la animacion
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
                      color: const Color(
                        0xFF222831,
                      ), // Gris oscuro texturizado de fondo
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: const Color(
                          0xFF11141A,
                        ), // Borde exterior más oscuro
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
                      mainAxisSize: MainAxisSize
                          .min, // Se ajusta al tamaño de los botones juntos
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PixelButton(
                          text: 'JUGAR',
                          baseColor: Colors.green.shade600,
                          onPressed: () {},
                        ),
                        const SizedBox(width: 12),
                        PixelButton(
                          text: 'OPCIONES',
                          baseColor: const Color.fromARGB(255, 179, 154, 113),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 12),
                        PixelButton(
                          text: 'INSTRUCCIONES',
                          baseColor: Colors.amber.shade700,
                          onPressed: () {},
                        ),
                        const SizedBox(width: 12),
                        PixelButton(
                          text: 'CRÉDITOS',
                          baseColor: Colors.blue.shade700,
                          onPressed: () {},
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
