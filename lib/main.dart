// Autor: Jonathan Venancio Aguilar Hernandez
import 'package:flutter/material.dart';
import 'logica/baraja.dart';
import 'logica/partida_dos_jugadores.dart';
import 'logica/tabla.dart';

void main() => runApp(const LoteriaApp());

class LoteriaApp extends StatelessWidget {
  const LoteriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lotería Doloreña',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const JuegoScreen(),
    );
  }
}

class JuegoScreen extends StatefulWidget {
  const JuegoScreen({super.key});

  @override
  State<JuegoScreen> createState() => _JuegoScreenState();
}

class _JuegoScreenState extends State<JuegoScreen> {
  late PartidaDosJugadores _partida;
  bool _marcadoManual = false;
  String _ultimaCarta = 'Toca Cantar para empezar';

  @override
  void initState() {
    super.initState();
    _reiniciar();
  }

  void _reiniciar() {
    final baraja = Baraja.crearBarajaCompleta()..mezclar();
    final cartas = Baraja.crearBarajaCompleta().cartasRestantes;
    setState(() {
      _partida = PartidaDosJugadores(
        baraja: baraja,
        tablaJugador1: Tabla.generar(cartas),
        tablaJugador2: Tabla.generar(cartas),
        marcadoAutomaticoJugador1: !_marcadoManual,
      );
      _ultimaCarta = 'Toca Cantar para empezar';
    });
  }

  void _cantar() {
    final carta = _partida.cantar();
    setState(() => _ultimaCarta = carta?.nombre ?? 'Ya no quedan cartas');
    _revisarGanador();
  }

  void _tocarCelda(int fila, int columna) {
    if (!_marcadoManual || _partida.terminada) return;
    final valido = _partida.marcarManualJugador1(fila, columna);
    setState(() {});
    if (!valido) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Esa carta todavía no ha sido cantada')),
        );
    }
    _revisarGanador();
  }

  void _revisarGanador() {
    if (!_partida.terminada) return;
    final mensaje = switch (_partida.ganador) {
      Ganador.jugador1 => '¡Lotería! Ganaste tú.',
      Ganador.jugador2 => 'Ganó el jugador simulado.',
      Ganador.empate => '¡Empate! Ambos completaron a la vez.',
      Ganador.ninguno => '',
    };
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('¡Lotería!'),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _reiniciar();
            },
            child: const Text('Jugar de nuevo'),
          ),
        ],
      ),
    );
  }

  Widget _tablero(Tabla tabla, {required bool tocable}) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemCount: 16,
      itemBuilder: (context, i) {
        final f = i ~/ 4;
        final c = i % 4;
        final marcada = tabla.marcadas[f][c];
        return GestureDetector(
          onTap: tocable ? () => _tocarCelda(f, c) : null,
          child: Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: marcada ? Colors.deepOrange : Colors.orange.shade50,
              border: Border.all(color: Colors.deepOrange),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                tabla.filas[f][c].nombre,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: marcada ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lotería Doloreña')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(
                _ultimaCarta,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Text('Cartas cantadas: ${_partida.totalCantadas} / 16'),
            SwitchListTile(
              title: const Text('Marcado manual'),
              subtitle: const Text('Tú eliges qué celda marcar (reinicia la partida)'),
              value: _marcadoManual,
              onChanged: (v) {
                _marcadoManual = v;
                _reiniciar();
              },
            ),
            const Text('Tu tabla', style: TextStyle(fontWeight: FontWeight.bold)),
            _tablero(_partida.tablaJugador1, tocable: _marcadoManual),
            const SizedBox(height: 8),
            const Text('Jugador simulado',
                style: TextStyle(fontWeight: FontWeight.bold)),
            _tablero(_partida.tablaJugador2, tocable: false),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: _cantar,
                icon: const Icon(Icons.campaign),
                label: const Text('Cantar siguiente carta'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
