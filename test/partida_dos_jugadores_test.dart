// Autor: Jonathan Venancio Aguilar Hernandez
import 'package:flutter_test/flutter_test.dart';
import 'package:loteria_dolorena/logica/baraja.dart';
import 'package:loteria_dolorena/logica/partida_dos_jugadores.dart';
import 'package:loteria_dolorena/logica/tabla.dart';
import 'package:loteria_dolorena/modelos/carta.dart';

final List<Carta> _c = Baraja.crearBarajaCompleta().cartasRestantes;

/// Las ultimas 4 cartas (12..15) forman la fila 3.
Tabla _tablaConFilaGanadora() => Tabla.desdeFilas([
      _c.sublist(0, 4),
      _c.sublist(4, 8),
      _c.sublist(8, 12),
      _c.sublist(12, 16),
    ]);

/// Las cartas 12..15 quedan dispersas: no forman fila, columna ni diagonal.
Tabla _tablaDispersa() => Tabla.desdeFilas([
      [_c[12], _c[13], _c[0], _c[1]],
      [_c[2], _c[3], _c[14], _c[4]],
      [_c[5], _c[6], _c[7], _c[15]],
      [_c[8], _c[9], _c[10], _c[11]],
    ]);

PartidaDosJugadores _partida(Tabla t1, Tabla t2, {bool auto1 = true}) =>
    PartidaDosJugadores(
      baraja: Baraja.desdeCartas(_c),
      tablaJugador1: t1,
      tablaJugador2: t2,
      marcadoAutomaticoJugador1: auto1,
    );

void main() {
  test('al inicio no hay ganador', () {
    final p = _partida(_tablaConFilaGanadora(), _tablaDispersa());
    expect(p.ganador, Ganador.ninguno);
  });

  test('gana el jugador 1 si completa su patron primero', () {
    final p = _partida(_tablaConFilaGanadora(), _tablaDispersa());
    for (var i = 0; i < 4; i++) {
      p.cantar();
    }
    expect(p.ganador, Ganador.jugador1);
  });

  test('gana el jugador 2 si completa su patron primero', () {
    final p = _partida(_tablaDispersa(), _tablaConFilaGanadora());
    for (var i = 0; i < 4; i++) {
      p.cantar();
    }
    expect(p.ganador, Ganador.jugador2);
  });

  test('si ambos completan en la misma carta es empate', () {
    final p = _partida(_tablaConFilaGanadora(), _tablaConFilaGanadora());
    for (var i = 0; i < 4; i++) {
      p.cantar();
    }
    expect(p.ganador, Ganador.empate);
  });

  test('una partida terminada ya no canta mas cartas', () {
    final p = _partida(_tablaConFilaGanadora(), _tablaDispersa());
    for (var i = 0; i < 4; i++) {
      p.cantar();
    }
    expect(p.cantar(), isNull);
    expect(p.totalCantadas, 4);
  });

  test('con marcado manual el jugador 1 debe marcar para ganar', () {
    final p = _partida(_tablaConFilaGanadora(), _tablaDispersa(), auto1: false);
    for (var i = 0; i < 4; i++) {
      p.cantar();
    }
    expect(p.ganador, Ganador.ninguno);

    for (var col = 0; col < 4; col++) {
      p.marcarManualJugador1(3, col);
    }
    expect(p.ganador, Ganador.jugador1);
  });

  test('en manual, marcar una carta no cantada es invalido', () {
    final p = _partida(_tablaConFilaGanadora(), _tablaDispersa(), auto1: false);
    p.cantar();
    expect(p.marcarManualJugador1(0, 0), false);
  });
}
