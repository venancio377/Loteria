// Autor: Jonathan Venancio Aguilar Hernandez
import '../modelos/carta.dart';

class Baraja {
  final List<Carta> cartasRestantes;

  // Costura para pruebas: recibe el orden exacto, sin mezclar.
  Baraja.desdeCartas(List<Carta> cartas)
      : cartasRestantes = List<Carta>.from(cartas);

  static const List<String> _nombres = [
    'El Cura', 'La Campana', 'El Grito', 'La Parroquia',
    'El Sarape', 'La Nieve', 'El Sombrero', 'La Guitarra',
    'El Caballo', 'La Bandera', 'El Insurgente', 'La Plaza',
    'El Fuego', 'La Estrella', 'El Águila', 'El Tambor',
  ];

  static Baraja crearBarajaCompleta() {
    final cartas = <Carta>[];
    for (var i = 0; i < _nombres.length; i++) {
      cartas.add(Carta(id: i, nombre: _nombres[i]));
    }
    return Baraja.desdeCartas(cartas);
  }

  void mezclar() => cartasRestantes.shuffle();

  Carta? cantarSiguiente() {
    if (cartasRestantes.isEmpty) return null;
    return cartasRestantes.removeLast();
  }
}
