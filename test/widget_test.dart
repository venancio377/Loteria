// Autor: Jonathan Venancio Aguilar Hernandez
import 'package:flutter_test/flutter_test.dart';
import 'package:loteria_dolorena/main.dart';

void main() {
  testWidgets('muestra la partida y permite cantar una carta', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const LoteriaApp());

    expect(find.text('Lotería Doloreña'), findsOneWidget);
    expect(find.text('Tu tabla'), findsOneWidget);
    expect(find.text('Cartas cantadas: 0 / 16'), findsOneWidget);

    final botonCantar = find.text('Cantar siguiente carta');
    await tester.ensureVisible(botonCantar);
    await tester.pumpAndSettle();
    await tester.tap(botonCantar);
    await tester.pump();

    expect(find.text('Cartas cantadas: 1 / 16'), findsOneWidget);
    expect(find.text('Toca Cantar para empezar'), findsNothing);
  });
}
