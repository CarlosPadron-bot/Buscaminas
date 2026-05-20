import 'dart:async';
import 'dart:math' as math;
import 'package:buscaminas/Audios.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';

class CargaPantalla extends StatefulWidget {
  const CargaPantalla({super.key});

  @override
  State<CargaPantalla> createState() => EstadoCarga();
}

class EstadoCarga extends State<CargaPantalla> {
  double anguloActual = 0.0;
  Timer? temporizadorRotacion;
  bool estaGirado = false;

  double valorProgreso = 0.0;
  Timer? temporizadorProgreso;
  Timer? temporizadorSalida;

  final double imageWidth = 300.0;
  final double imageHeight = 300.0;

  @override
  void initState() {
    super.initState();

    temporizadorRotacion = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        estaGirado = !estaGirado;
        anguloActual = estaGirado ? (50 * math.pi / 180) : 0.0;
      });
    });

    const int duracionTotalMs = 10000;
    const int intervaloMs = 50;
    int tiempoTranscurrido = 0;

    temporizadorProgreso = Timer.periodic(
      const Duration(milliseconds: intervaloMs),
      (timer) {
        tiempoTranscurrido += intervaloMs;
        setState(() {
          valorProgreso = tiempoTranscurrido / duracionTotalMs;
        });
        if (tiempoTranscurrido >= duracionTotalMs) {
          temporizadorProgreso?.cancel();
        }
      },
    );

    temporizadorSalida = Timer(const Duration(seconds: 10), () {
      _navigateToHome();
    });

    ServicesBinding.instance.keyboard.addHandler(_handleKeyPress);
  }

  @override
  void dispose() {
    temporizadorRotacion?.cancel();
    temporizadorProgreso?.cancel();
    temporizadorSalida?.cancel();
    ServicesBinding.instance.keyboard.removeHandler(_handleKeyPress);
    super.dispose();
  }

  bool _handleKeyPress(KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.space) {
      _navigateToHome();
      return true;
    }
    return false;
  }

  void _navigateToHome() async {
    AudioManager.playAsset('sonidos/win.ogg');
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const VideoBackgroundScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'BUSCAMINAS',
                style: GoogleFonts.pressStart2p(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 50),
              Transform.rotate(
                angle: anguloActual,
                child: Image.asset(
                  'assets/imagenes/Mina.png',
                  width: imageWidth,
                  height: imageHeight,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 60),
              Container(
                width: 250,
                height: 20,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 3),
                ),
                padding: const EdgeInsets.all(2),
                child: Row(
                  children: [
                    Expanded(
                      flex: (valorProgreso * 100).toInt().clamp(0, 100),
                      child: Container(color: Colors.green),
                    ),
                    Expanded(
                      flex: (100 - (valorProgreso * 100).toInt()).clamp(0, 100),
                      child: Container(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Omitir (Espacio)',
                style: GoogleFonts.pressStart2p(
                  color: Colors.white38,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
