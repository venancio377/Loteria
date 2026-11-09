// Autor: Jonathan Venancio Aguilar Hernandez
import 'package:flutter_test/flutter_test.dart';
import 'package:loteria_dolorena/logica/baraja.dart';

void main() {
  test('crearBarajaCompleta regresa exactamente 16 cartas', () {
    final baraja = Baraja.crearBarajaCompleta();
    expect(baraja.cartasRestantes.length, 16);
  });

  test('crearBarajaCompleta no repite ninguna carta', () {
    final baraja = Baraja.crearBarajaCompleta();
    final idsUnicos = baraja.cartasRestantes.map((c) => c.id).toSet();
    expect(idsUnicos.length, 16);
  });

  test('mezclar conserva las mismas 16 cartas, solo cambia el orden', () {
    final baraja = Baraja.crearBarajaCompleta();
    final idsAntes = baraja.cartasRestantes.map((c) => c.id).toSet();
    baraja.mezclar();
    final idsDespues = baraja.cartasRestantes.map((c) => c.id).toSet();
    expect(idsDespues, idsAntes);
  });

  test('cantarSiguiente entrega una carta y la retira del mazo', () {
    final baraja = Baraja.crearBarajaCompleta();
    final total = baraja.cartasRestantes.length;
    final primera = baraja.cantarSiguiente();
    expect(primera, isNotNull);
    expect(baraja.cartasRestantes.length, total - 1);
  });

  test('cantarSiguiente regresa null cuando ya no hay cartas', () {
    final baraja = Baraja.crearBarajaCompleta();
    for (var i = 0; i < 16; i++) {
      baraja.cantarSiguiente();
    }
    expect(baraja.cantarSiguiente(), isNull);
  });
}
