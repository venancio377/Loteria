// Autor: Jonathan Venancio Aguilar Hernandez
import '../modelos/carta.dart';
import 'baraja.dart';
import 'tabla.dart';
import 'verificador_patrones.dart';

enum Ganador { ninguno, jugador1, jugador2, empate }

/// Reto: dos tablas sobre la misma baraja; gana quien complete un patrón primero.
/// El jugador 2 (simulado) siempre marca de forma automática.
class PartidaDosJugadores {
  final Baraja baraja;
  final Tabla tablaJugador1;
  final Tabla tablaJugador2;
  final bool marcadoAutomaticoJugador1;
  final List<Carta> cantadas = [];

  Ganador ganador = Ganador.ninguno;

  PartidaDosJugadores({
    required this.baraja,
    required this.tablaJugador1,
    required this.tablaJugador2,
    this.marcadoAutomaticoJugador1 = true,
  });

  int get totalCantadas => cantadas.length;
  bool get terminada => ganador != Ganador.ninguno;

  Carta? cantar() {
    if (terminada) return null;
    final carta = baraja.cantarSiguiente();
    if (carta == null) return null;

    cantadas.add(carta);
    if (marcadoAutomaticoJugador1) tablaJugador1.marcar(carta);
    tablaJugador2.marcar(carta);
    _evaluar();
    return carta;
  }

  bool marcarManualJugador1(int fila, int columna) {
    if (terminada) return false;
    final valido = tablaJugador1.marcarSiCantada(fila, columna, cantadas);
    if (valido) _evaluar();
    return valido;
  }

  void _evaluar() {
    final g1 = VerificadorPatrones.hayGanador(tablaJugador1.marcadas);
    final g2 = VerificadorPatrones.hayGanador(tablaJugador2.marcadas);
    if (g1 && g2) {
      ganador = Ganador.empate;
    } else if (g1) {
      ganador = Ganador.jugador1;
    } else if (g2) {
      ganador = Ganador.jugador2;
    }
  }
}
