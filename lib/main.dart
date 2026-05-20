import 'package:animate_do/animate_do.dart';
import 'package:buscaminas/audios.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Carga.dart';
import 'botones.dart';
import 'juego.dart';

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
  bool _sonidoActivado = true;
  bool _animacionesActivadas = true;

  String _dificultad = 'MEDIO';
  bool _jugando = false;
  String _temaActual = 'oscuro';

  Widget construirAnimacion(Widget child, {bool esBounce = false}) {
    if (!_animacionesActivadas) {
      return child;
    }
    return esBounce
        ? BounceInUp(
            duration: const Duration(milliseconds: 2000),
            from: 600,
            child: child)
        : FadeInDown(duration: const Duration(seconds: 2), child: child);
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/PantallaInicial.mp4');
    _controller.setVolume(0.0);
    _controller.initialize().then((_) {
      _controller.setLooping(true);
      _controller.play();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ConfiguracionJuego _obtenerConfiguracion() {
    if (_dificultad == 'FÁCIL') {
      return ConfiguracionJuego(filas: 6, columnas: 6, minas: 10);
    }
    if (_dificultad == 'DIFÍCIL') {
      return ConfiguracionJuego(filas: 10, columnas: 10, minas: 30);
    }
    return ConfiguracionJuego(filas: 8, columnas: 8, minas: 20); // MEDIO
  }

  @override
  Widget build(BuildContext context) {
    final bool esOscuro = _temaActual == 'oscuro';
    final Color colorInterfaz =
        esOscuro ? const Color(0xFF222831) : Colors.white;
    final Color colorBorde =
        esOscuro ? const Color(0xFF11141A) : Colors.grey.shade400;
    final Color colorTexto = esOscuro ? Colors.white : Colors.black;

    return Scaffold(
      body: Stack(
        children: [
          // ... (Tu lógica de video igual)
          if (_isInitialized)
            SizedBox.expand(
                child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller)))))
          else
            Container(color: Colors.black),

          SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: _jugando ? 1 : 2,
                  child: Center(
                    child: construirAnimacion(
                      Image.asset(
                        'assets/imagenes/titulo.png',
                        height: _jugando ? 200 : 260,
                        fit: BoxFit.contain,
                      ),
                      esBounce: false,
                    ),
                  ),
                ),
                if (!_jugando)
                  construirAnimacion(
                    Container(
                      margin: const EdgeInsets.only(
                          bottom: 50.0, left: 10.0, right: 10.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 22.0),
                      decoration: BoxDecoration(
                          color: colorInterfaz,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: colorBorde, width: 4)),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [
                          PixelButton(
                            text: 'JUGAR',
                            baseColor: Colors.green.shade600,
                            onPressed: () {
                              AudioManager.playAsset('sonidos/generic1.ogg');

                              setState(() => _jugando = true);
                            },
                          ),
                          PixelButton(
                            text: 'OPCIONES',
                            baseColor: const Color.fromARGB(255, 179, 154, 113),
                            onPressed: () {
                              AudioManager.playAsset('sonidos/generic1.ogg');
                              Botones.mostrar(
                                context,
                                titulo: 'OPCIONES',
                                temaInicial: _temaActual,
                                onTemaChanged: (nuevoTema) =>
                                    setState(() => _temaActual = nuevoTema),
                                animacionesActivadas:
                                    _animacionesActivadas, // Ahora sí lo reconocerá
                                onAnimacionesChanged: (nuevoEstado) => setState(
                                    () => _animacionesActivadas =
                                        nuevoEstado), // Ahora sí lo reconocerá
                                contenido: StatefulBuilder(
                                  builder: (context, setDialogState) {
                                    final Color cT = _temaActual == 'oscuro'
                                        ? Colors.white
                                        : Colors.black;
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('EFECTOS DE SONIDO',
                                            style: GoogleFonts.pressStart2p(
                                                color: cT, fontSize: 10)),
                                        const SizedBox(height: 10),
                                        _miniBotonRetro(
                                            _sonidoActivado
                                                ? 'ACTIVADOS'
                                                : 'DESACTIVADOS', () {
                                          AudioManager.playAsset(
                                              'sonidos/generic1.ogg');
                                          setState(() => _sonidoActivado =
                                              !_sonidoActivado);

                                          AudioManager.setEstado(
                                              _sonidoActivado);

                                          setDialogState(
                                              () {}); // Refresca el diálogo
                                        }, activo: _sonidoActivado),

                                        const SizedBox(height: 25),

                                        Text('ANIMACIONES',
                                            style: GoogleFonts.pressStart2p(
                                                color: cT, fontSize: 10)),
                                        const SizedBox(height: 10),
                                        _miniBotonRetro(
                                          _animacionesActivadas
                                              ? 'ACTIVADAS'
                                              : 'DESACTIVADAS',
                                          () {
                                            AudioManager.playAsset(
                                                'sonidos/generic1.ogg');
                                            setState(() =>
                                                _animacionesActivadas =
                                                    !_animacionesActivadas);
                                            setDialogState(() {});
                                          },
                                          activo: _animacionesActivadas,
                                        ),

                                        const SizedBox(height: 25),

                                        // 3. Dificultad
                                        Text('DIFICULTAD',
                                            style: GoogleFonts.pressStart2p(
                                                color: cT, fontSize: 12)),
                                        const SizedBox(height: 12),
                                        Wrap(
                                          spacing: 10,
                                          runSpacing: 10,
                                          alignment: WrapAlignment.center,
                                          children: [
                                            _miniBotonRetro('FÁCIL', () {
                                              AudioManager.playAsset(
                                                  'sonidos/generic1.ogg');
                                              setState(
                                                  () => _dificultad = 'FÁCIL');
                                              setDialogState(() {});
                                            }, activo: _dificultad == 'FÁCIL'),
                                            _miniBotonRetro('MEDIO', () {
                                              AudioManager.playAsset(
                                                  'sonidos/generic1.ogg');
                                              setState(
                                                  () => _dificultad = 'MEDIO');
                                              setDialogState(() {});
                                            }, activo: _dificultad == 'MEDIO'),
                                            _miniBotonRetro('DIFÍCIL', () {
                                              AudioManager.playAsset(
                                                  'sonidos/generic1.ogg');
                                              setState(() =>
                                                  _dificultad = 'DIFÍCIL');
                                              setDialogState(() {});
                                            },
                                                activo:
                                                    _dificultad == 'DIFÍCIL'),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          PixelButton(
                            text: 'INSTRUCCIONES',
                            baseColor: Colors.amber.shade700,
                            onPressed: () {
                              AudioManager.playAsset('sonidos/generic1.ogg');

                              Botones.mostrar(
                                context,
                                titulo: 'INSTRUCCIONES',
                                temaInicial: _temaActual,
                                onTemaChanged: (t) {},
                                animacionesActivadas: _animacionesActivadas,
                                onAnimacionesChanged: (nuevoEstado) => setState(
                                    () => _animacionesActivadas = nuevoEstado),
                                contenido: const Text(
                                  'Click Izq: Descubrir casilla\nClick Der: Colocar bandera\n\n¡Evita las minas para ganar!\n\nLos números indican cuántas minas hay a su alrededor.',
                                  textAlign: TextAlign.center,
                                ),
                              );
                            },
                          ),
                          PixelButton(
                            text: 'CRÉDITOS',
                            baseColor: Colors.blue.shade700,
                            onPressed: () {
                              AudioManager.playAsset('sonidos/generic1.ogg');

                              Botones.mostrar(
                                context,
                                titulo: 'CRÉDITOS',
                                temaInicial: _temaActual,
                                onTemaChanged: (t) {},
                                animacionesActivadas: _animacionesActivadas,
                                onAnimacionesChanged: (nuevoEstado) => setState(
                                    () => _animacionesActivadas = nuevoEstado),
                                contenido: const Text(
                                  'Desarrollado por:\nAntonio Barriola y Carlos Padron\n\nMotor: Flutter\n\n!Gracias por Jugar¡',
                                  textAlign: TextAlign.center,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    esBounce: true,
                  ),
                if (_jugando)
                  Expanded(
                      flex: 5,
                      child: TableroJuego(
                          configuracion: _obtenerConfiguracion(),
                          temaActual: _temaActual,
                          onBack: () => setState(() => _jugando = false))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniBotonRetro(String texto, VoidCallback accion,
      {bool activo = false}) {
    Color colorFondo;
    if (texto == 'ACTIVADAS' || texto == 'ACTIVADOS') {
      colorFondo = Colors.green.shade700;
    } else if (texto == 'DESACTIVADAS' || texto == 'DESACTIVADOS') {
      colorFondo = Colors.red.shade900;
    } else {
      colorFondo = activo ? Colors.cyan.shade700 : const Color(0xFF393E46);
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorFondo,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
          side: BorderSide(
              color: activo ? Colors.white : const Color(0xFF11141A), width: 2),
        ),
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
    final Color colorBaseReferencia = widget.baseColor;
    final Color finalColor = _isHovered
        ? Color.lerp(colorBaseReferencia, Colors.black, 0.25)!
        : colorBaseReferencia;

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
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
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
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
