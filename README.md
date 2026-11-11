# Lotería Doloreña

Juego de lotería en Flutter con 16 cartas inspiradas en la Independencia y Dolores Hidalgo. Se desarrolló con TDD: cada regla del juego nació de una prueba, y la lógica vive separada de la interfaz para poder probarla sin abrir la app.

**Autor:** Jonathan Venancio Aguilar Hernandez

## Qué hace

- Baraja de 16 cartas (El Cura, La Campana, El Grito, La Parroquia, El Sarape, La Nieve, El Sombrero, La Guitarra, El Caballo, La Bandera, El Insurgente, La Plaza, El Fuego, La Estrella, El Águila, El Tambor) que se mezcla y se canta una por una.
- Tablas de 4x4 generadas al azar.
- Se gana con una línea, una columna o una diagonal. También se detecta la tabla llena.
- Marcado automático al cantar o marcado manual: en modo manual solo se puede marcar una carta que ya fue cantada.
- Segundo jugador simulado. Gana quien complete primero; si ambos lo hacen a la vez, hay empate.
- Contador de cartas cantadas (N / 16) y diálogo final con opción de jugar de nuevo.

## Arquitectura

La lógica es Dart puro, sin dependencias de Flutter, y la interfaz solo la consume.

| Capa | Archivos | Responsabilidad |
|---|---|---|
| Modelos | `lib/modelos/carta.dart` | `Carta` con `id` y `nombre`; la igualdad se define por `id` |
| Lógica | `lib/logica/baraja.dart` | Crear, mezclar y cantar cartas |
| | `lib/logica/tabla.dart` | Tabla 4x4, marcado y validación de cartas cantadas |
| | `lib/logica/verificador_patrones.dart` | Línea, columna, diagonal, ganador y tabla llena |
| | `lib/logica/motor_juego.dart` | Coordina baraja, tabla y marcado (automático o manual) |
| | `lib/logica/partida_dos_jugadores.dart` | Partida contra el jugador simulado y resultado final |
| Interfaz | `lib/main.dart` | Pantalla del juego en Material 3 |

## Estructura

```
loteria_dolorena/
├── lib/
│   ├── main.dart
│   ├── modelos/carta.dart
│   └── logica/
│       ├── baraja.dart
│       ├── tabla.dart
│       ├── verificador_patrones.dart
│       ├── motor_juego.dart
│       └── partida_dos_jugadores.dart
├── test/
│   ├── baraja_test.dart
│   ├── tabla_test.dart
│   ├── verificador_patrones_test.dart
│   ├── motor_juego_test.dart
│   ├── partida_dos_jugadores_test.dart
│   └── widget_test.dart
├── capturas/
└── pubspec.yaml
```

No usa paquetes externos: solo Flutter y `flutter_test`.

## Cómo ejecutarlo

Requiere Flutter (SDK `>=3.0.0 <4.0.0`).

```bash
git clone https://github.com/venancio377/Loteria.git
cd Loteria
flutter pub get
flutter run -d chrome
```

## Pruebas

```bash
flutter test
```

Resultado: **37 de 37 pruebas aprobadas**.

![flutter test](capturas/flutter-test.png)

| Archivo | Pruebas | Qué cubre |
|---|---|---|
| `baraja_test.dart` | 5 | Cartas, mezcla y canto |
| `tabla_test.dart` | 7 | Generación y marcado |
| `verificador_patrones_test.dart` | 10 | Línea, columna, diagonal y tabla llena |
| `motor_juego_test.dart` | 7 | Canto, marcado automático y manual |
| `partida_dos_jugadores_test.dart` | 7 | Ganador, empate y jugador simulado |
| `widget_test.dart` | 1 | La partida se muestra y permite cantar |
