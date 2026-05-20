import 'dart:math';

class Casilla {
  bool tieneBomba = false;
  bool revelada = false;
  bool tieneBandera = false;
  int bombasAdyacentes = 0;

  Casilla();
}

class BuscaminasLogica {
  final int filas;
  final int columnas;
  final int totalMinas;

  List<List<Casilla>> tablero = [];
  bool juegoTerminado = false;
  bool victoria = false;

  BuscaminasLogica({
    required this.filas,
    required this.columnas,
    required this.totalMinas,
  }) {
    _generarTablero();
  }

  void _generarTablero() {
    tablero = List.generate(
      filas,
      (f) => List.generate(columnas, (c) => Casilla()),
    );

    int bombasColocadas = 0;
    var random = Random();
    while (bombasColocadas < totalMinas) {
      int f = random.nextInt(filas);
      int c = random.nextInt(columnas);
      if (!tablero[f][c].tieneBomba) {
        tablero[f][c].tieneBomba = true;
        bombasColocadas++;
      }
    }

    for (int f = 0; f < filas; f++) {
      for (int c = 0; c < columnas; c++) {
        if (!tablero[f][c].tieneBomba) {
          tablero[f][c].bombasAdyacentes = _contarBombasVecinas(f, c);
        }
      }
    }
  }

  int _contarBombasVecinas(int fila, int col) {
    int count = 0;
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        int nf = fila + i;
        int nc = col + j;
        if (nf >= 0 && nf < filas && nc >= 0 && nc < columnas) {
          if (tablero[nf][nc].tieneBomba) count++;
        }
      }
    }
    return count;
  }

  bool verificarVictoria() {
    for (int f = 0; f < filas; f++) {
      for (int c = 0; c < columnas; c++) {
        // Si la casilla no tiene bomba y NO está revelada, aún no ganamos
        if (!tablero[f][c].tieneBomba && !tablero[f][c].revelada) {
          return false;
        }
      }
    }
    // Si terminamos el ciclo y todo lo que no es bomba está revelado, ganamos
    victoria = true;
    juegoTerminado = true;
    return true;
  }

  bool revelarCasilla(int f, int c) {
    if (juegoTerminado ||
        tablero[f][c].revelada ||
        tablero[f][c].tieneBandera) {
      return false;
    }

    tablero[f][c].revelada = true;

    if (tablero[f][c].tieneBomba) {
      juegoTerminado = true;
      return true; // Explotó
    }

    if (tablero[f][c].bombasAdyacentes == 0) {
      for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
          int nf = f + i;
          int nc = c + j;
          if (nf >= 0 && nf < filas && nc >= 0 && nc < columnas) {
            revelarCasilla(nf, nc);
          }
        }
      }
    }
    return false;
  }

  void alternarBandera(int f, int c) {
    if (!juegoTerminado && !tablero[f][c].revelada) {
      tablero[f][c].tieneBandera = !tablero[f][c].tieneBandera;
    }
  }
}
