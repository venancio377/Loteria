// Autor: Jonathan Venancio Aguilar Hernandez
import 'package:flutter_test/flutter_test.dart';
import 'package:loteria_dolorena/logica/baraja.dart';
import 'package:loteria_dolorena/logica/motor_juego.dart';
import 'package:loteria_dolorena/logica/tabla.dart';

MotorJuego _motorOrdenado({bool automatico = true}) {
  final cartas = Baraja.crearBarajaCompleta().cartasRestantes; // orden fijo
  final baraja = Baraja.desdeCartas(cartas);
  final tabla = Tabla.desdeFilas([
    cartas.sublist(0, 4),
    cartas.sublist(4, 8),
    cartas.sublist(8, 12),
    cartas.sublist(12, 16),
  ]);
  return MotorJuego(
    baraja: baraja,
    tabla: tabla,
    marcadoAutomatico: automatico,
  );
}

void main() {
  test('el motor detecta Loteria al completar una fila', () {
    final motor = _motorOrdenado();

    // cantarSiguiente() usa removeLast(): canta primero las ultimas 4
    // cartas, que son exactamente la fila 3 de la tabla.
    for (var i = 0; i < 4; i++) {
      motor.cantarYMarcar();
    }

    expect(motor.haGanado, true);
  });

  test('el motor NO reporta Loteria si aun no se completa ningun patron', () {
    final motor = _motorOrdenado();

    motor.cantarYMarcar();
    motor.cantarYMarcar();

    expect(motor.haGanado, false);
  });

  group('retos', () {
    test('el contador cuenta las cartas cantadas', () {
      final motor = _motorOrdenado();
      expect(motor.totalCantadas, 0);

      motor.cantarYMarcar();
      motor.cantarYMarcar();
      motor.cantarYMarcar();

      expect(motor.totalCantadas, 3);
    });

    test('tabla llena es un premio distinto a la linea', () {
      final motor = _motorOrdenado();

      for (var i = 0; i < 4; i++) {
        motor.cantarYMarcar();
      }
      expect(motor.haGanado, true);
      expect(motor.tablaLlena, false);

      for (var i = 0; i < 12; i++) {
        motor.cantarYMarcar();
      }
      expect(motor.tablaLlena, true);
    });

    test('en modo manual cantar no marca la tabla por si solo', () {
      final motor = _motorOrdenado(automatico: false);

      for (var i = 0; i < 4; i++) {
        motor.cantarYMarcar();
      }

      expect(motor.haGanado, false);
      expect(
        motor.tabla.marcadas.every((f) => f.every((m) => m == false)),
        true,
      );
    });

    test('en modo manual un marcado incorrecto no cuenta como valido', () {
      final motor = _motorOrdenado(automatico: false);
      motor.cantarYMarcar(); // sale la carta 15 -> fila 3, columna 3

      expect(motor.marcarManual(0, 0), false); // aun no cantada
      expect(motor.tabla.marcadas[0][0], false);
      expect(motor.marcarManual(3, 3), true); // si fue cantada
      expect(motor.tabla.marcadas[3][3], true);
    });

    test('en modo manual se gana marcando correctamente una fila', () {
      final motor = _motorOrdenado(automatico: false);
      for (var i = 0; i < 4; i++) {
        motor.cantarYMarcar();
      }

      for (var c = 0; c < 4; c++) {
        motor.marcarManual(3, c);
      }

      expect(motor.haGanado, true);
    });
  });
}
