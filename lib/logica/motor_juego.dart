// Autor: Jonathan Venancio Aguilar Hernandez
import '../modelos/carta.dart';
import 'baraja.dart';
import 'tabla.dart';
import 'verificador_patrones.dart';

class MotorJuego {
  final Baraja baraja;
  final Tabla tabla;
  final bool marcadoAutomatico;
  final List<Carta> cantadas = [];

  bool haGanado = false;
  bool tablaLlena = false;

  MotorJuego({
    required this.baraja,
    required this.tabla,
    this.marcadoAutomatico = true,
  });

  /// Contador de cartas cantadas (reto).
  int get totalCantadas => cantadas.length;

  Carta? cantarYMarcar() {
    final carta = baraja.cantarSiguiente();
    if (carta == null) return null;

    cantadas.add(carta);
    if (marcadoAutomatico) {
      tabla.marcar(carta);
      _evaluar();
    }
    return carta;
  }

  /// Marcado manual (reto): solo cuenta si la carta ya fue cantada.
  bool marcarManual(int fila, int columna) {
    final valido = tabla.marcarSiCantada(fila, columna, cantadas);
    if (valido) _evaluar();
    return valido;
  }

  void _evaluar() {
    if (VerificadorPatrones.hayGanador(tabla.marcadas)) haGanado = true;
    if (VerificadorPatrones.tablaLlena(tabla.marcadas)) tablaLlena = true;
  }
}
