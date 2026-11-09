// Autor: Jonathan Venancio Aguilar Hernandez
class VerificadorPatrones {
  static bool hayLinea(List<List<bool>> marcadas) {
    for (final fila in marcadas) {
      if (fila.every((m) => m)) return true;
    }
    return false;
  }

  static bool hayColumna(List<List<bool>> marcadas) {
    for (var c = 0; c < marcadas[0].length; c++) {
      var completa = true;
      for (var f = 0; f < marcadas.length; f++) {
        if (!marcadas[f][c]) {
          completa = false;
          break;
        }
      }
      if (completa) return true;
    }
    return false;
  }

  static bool hayDiagonal(List<List<bool>> marcadas) {
    final n = marcadas.length;
    var principal = true;
    var secundaria = true;
    for (var i = 0; i < n; i++) {
      if (!marcadas[i][i]) principal = false;
      if (!marcadas[i][n - 1 - i]) secundaria = false;
    }
    return principal || secundaria;
  }

  static bool hayGanador(List<List<bool>> marcadas) {
    return hayLinea(marcadas) || hayColumna(marcadas) || hayDiagonal(marcadas);
  }

  /// Reto: premio mayor, las 16 celdas marcadas.
  static bool tablaLlena(List<List<bool>> marcadas) {
    return marcadas.every((fila) => fila.every((m) => m));
  }
}
