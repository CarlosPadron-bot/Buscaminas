class Partida {
  final DateTime fecha;
  final int segundos;
  final int intentos;

  Partida(
      {required this.fecha, required this.segundos, required this.intentos});
}

List<Partida> historialPartidas = [];
