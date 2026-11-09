# Lotería Doloreña (TDD)

**Autor:** Jonathan Venancio Aguilar Hernandez

Juego de lotería con 16 cartas de la Independencia y Dolores Hidalgo, construido
guiado por pruebas siguiendo el manual de 10 rondas + los retos de extensión.

## Cómo usarlo

Este zip trae el código (`lib/`, `test/`, `pubspec.yaml`). Para generar las
carpetas de plataforma (android, ios, etc.) ejecuta dentro de la carpeta:

```bash
flutter create .
flutter pub get
flutter test      # pruebas de lógica (Dart puro, sin emulador)
flutter run       # jugar
```

> `flutter create .` no sobrescribe tus archivos de `lib/` ni `test/`. La prueba
> `test/widget_test.dart` comprueba la pantalla y el botón para cantar cartas.

## Estructura
```
lib/
  modelos/carta.dart
  logica/
    baraja.dart                  Rondas 1-3 y 9
    tabla.dart                   Rondas 4-5, 9 + marcado manual (reto)
    verificador_patrones.dart    Rondas 6-8 + tabla llena (reto)
    motor_juego.dart             Ronda 10 + contador, tabla llena y manual (retos)
    partida_dos_jugadores.dart   Reto: segundo jugador simulado
  main.dart                      Interfaz gráfica
test/
  baraja_test.dart
  tabla_test.dart
  verificador_patrones_test.dart
  motor_juego_test.dart
  partida_dos_jugadores_test.dart
```

## Retos incluidos

- Tabla llena como premio mayor (`VerificadorPatrones.tablaLlena`, `MotorJuego.tablaLlena`).
- Contador de cartas cantadas, visible en pantalla.
- Marcado manual: marcar una carta que aún no se canta no cuenta como válido.
- Segunda tabla (jugador simulado) y detección de quién gana primero, con empate.
