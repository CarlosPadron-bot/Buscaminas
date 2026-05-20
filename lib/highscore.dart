import 'dart:convert';

import 'package:buscaminas/audios.dart';
import 'package:buscaminas/persistencia.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'botones.dart';
import 'package:intl/intl.dart';
import 'historial.dart';

class HighScoreScreen extends StatefulWidget {
  const HighScoreScreen({super.key});

  static void mostrar(BuildContext context, {int? tiempo}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const HighScoreScreen(),
    );
  }

  @override
  State<HighScoreScreen> createState() => _HighScoreScreenState();
}

Future<void> guardarHistorial() async {
  List<Map<String, dynamic>> listaMap = historialPartidas
      .map((p) => {
            'fecha': p.fecha.toIso8601String(),
            'segundos': p.segundos,
            'intentos': p.intentos
          })
      .toList();

  await StorageManager.guardarString('historial', jsonEncode(listaMap));
}

Future<void> cargarHistorial() async {
  String? json = await StorageManager.obtenerString('historial');
  if (json != null) {
    List<dynamic> lista = jsonDecode(json);
    historialPartidas = lista
        .map((item) => Partida(
            fecha: DateTime.parse(item['fecha']),
            segundos: item['segundos'],
            intentos: item['intentos']))
        .toList();
  }
}

class _HighScoreScreenState extends State<HighScoreScreen> {
  void _confirmarBorrar() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF222831),
        title: Text('¿Estás seguro?',
            style: GoogleFonts.pressStart2p(color: Colors.white, fontSize: 12)),
        content: Text('Se borrarán todos los records.',
            style:
                GoogleFonts.pressStart2p(color: Colors.white70, fontSize: 8)),
        actions: [
          TextButton(
            onPressed: () {
              AudioManager.playAsset('sonidos/cancel.ogg');
              Navigator.of(context).pop();
            },
            child:
                Text('NO', style: GoogleFonts.pressStart2p(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              setState(() => historialPartidas.clear());
              AudioManager.playAsset('sonidos/foil2.ogg');
              Navigator.of(context).pop();
            },
            child: Text('SÍ',
                style: GoogleFonts.pressStart2p(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: BounceInUp(
        duration: const Duration(milliseconds: 800),
        child: Container(
          width: 600,
          height: 500,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: const Color(0xFF222831),
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Text('HISTORIAL',
                  style: GoogleFonts.pressStart2p(
                      color: Colors.amber, fontSize: 18)),
              const SizedBox(height: 20),
              Expanded(
                child: historialPartidas.isEmpty
                    ? Center(
                        child: Text(
                            'No hay partidas registradas,\n ¡Juega tu primero partida!',
                            style: GoogleFonts.pressStart2p(
                                color: Colors.white38, fontSize: 10)))
                    : ListView.builder(
                        itemCount: historialPartidas.length,
                        itemBuilder: (context, index) {
                          final p = historialPartidas[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.all(10),
                            color: Colors.white10,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(DateFormat('dd/MM HH:mm').format(p.fecha),
                                    style: GoogleFonts.pressStart2p(
                                        fontSize: 8, color: Colors.white)),
                                Text('${p.segundos}s',
                                    style: GoogleFonts.pressStart2p(
                                        fontSize: 8, color: Colors.blue)),
                                Text('${p.intentos} Intentos',
                                    style: GoogleFonts.pressStart2p(
                                        fontSize: 8, color: Colors.green)),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BotonMenuOpciones(
                      texto: 'VOLVER',
                      colorBase: Colors.red.shade700,
                      onPressed: () {
                        AudioManager.playAsset('sonidos/cancel.ogg');
                        Navigator.of(context).pop();
                      }),
                  if (historialPartidas.isNotEmpty) ...[
                    const SizedBox(width: 20),
                    BotonMenuOpciones(
                        texto: 'ELIMINAR',
                        colorBase: Colors.grey.shade700,
                        onPressed: () {
                          AudioManager.playAsset('sonidos/foil2.ogg');
                          _confirmarBorrar();
                        }),
                  ]
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
