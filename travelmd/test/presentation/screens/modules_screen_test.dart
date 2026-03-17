import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelmd/presentation/screens/modules_screen.dart';

void main() {
  testWidgets('public catalog shows prevention categories rather than raw modules', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ModulesScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Prevention Categories'), findsOneWidget);
    expect(find.byKey(const Key('category-tile-avoid_animal_bites')), findsOneWidget);
    expect(find.byKey(const Key('category-tile-avoid_bug_bites')), findsOneWidget);
    expect(find.text('Rabies'), findsNothing);
    expect(find.text('Malaria'), findsNothing);
  });

  testWidgets('incident category is shown as if something happens', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ModulesScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();

    expect(find.text('If Something Happens'), findsOneWidget);
    expect(find.byKey(const Key('category-tile-if_something_happens')), findsOneWidget);
  });
}