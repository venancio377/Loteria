// Autor: Jonathan Venancio Aguilar Hernandez
import 'package:flutter_test/flutter_test.dart';
import 'package:loteria_dolorena/logica/baraja.dart';
import 'package:loteria_dolorena/logica/tabla.dart';
import 'package:loteria_dolorena/modelos/carta.dart';

void main() {
  test('una tabla nueva contiene las 16 cartas, sin repetir', () {
    final cartas = Baraja.crearBarajaCompleta().cartasRestantes;
    final tabla = Tabla.generar(cartas);
    final todas = tabla.filas.expand((fila) => fila).toList();
    expect(todas.length, 16);
    expect(todas.toSet().length, 16);
  });

  test('una tabla nueva no tiene ninguna celda marcada', () {
    final cartas = Baraja.crearBarajaCompleta().cartasRestantes;
    final tabla = Tabla.generar(cartas);
    expect(tabla.marcadas.every((fila) => fila.every((m) => m == false)), true);
  });

  test('marcar encuentra la carta en la tabla y marca su celda', () {
    final cartas = Baraja.crearBarajaCompleta().cartasRestantes;
    final tabla = Tabla.generar(cartas);
    final cartaEnTabla = tabla.filas[0][0];

    tabla.marcar(cartaEnTabla);

    expect(tabla.marcadas[0][0], true);
  });

  test('marcar una carta que no esta en la tabla no cambia nada', () {
    final cartas = Baraja.crearBarajaCompleta().cartasRestantes;
    final tabla = Tabla.generar(cartas);
    const cartaAjena = Carta(id: 999, nombre: 'Carta inexistente');

    tabla.marcar(cartaAjena);

    expect(tabla.marcadas.every((fila) => fila.every((m) => m == false)), true);
  });

  group('marcado manual (reto)', () {
    Tabla tablaOrdenada() {
      final cartas = Baraja.crearBarajaCompleta().cartasRestantes;
      return Tabla.desdeFilas([
        cartas.sublist(0, 4),
        cartas.sublist(4, 8),
        cartas.sublist(8, 12),
        cartas.sublist(12, 16),
      ]);
    }

    test('marcar una celda cuya carta ya fue cantada es valido', () {
      final tabla = tablaOrdenada();
      final cantadas = [tabla.filas[1][2]];

      final ok = tabla.marcarSiCantada(1, 2, cantadas);

      expect(ok, true);
      expect(tabla.marcadas[1][2], true);
    });

    test('marcar una celda cuya carta NO ha sido cantada no cuenta', () {
      final tabla = tablaOrdenada();

      final ok = tabla.marcarSiCantada(0, 0, const []);

      expect(ok, false);
      expect(tabla.marcadas[0][0], false);
    });

    test('una celda fuera de rango no cuenta y no truena', () {
      final tabla = tablaOrdenada();
      expect(tabla.marcarSiCantada(4, 0, tabla.filas[0]), false);
      expect(tabla.marcarSiCantada(0, -1, tabla.filas[0]), false);
    });
  });
}
