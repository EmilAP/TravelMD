import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelmd/presentation/screens/modules_screen.dart';

void main() {
  testWidgets('prevention section includes rabies and malaria', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ModulesScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Prevention Modules'), findsOneWidget);
    expect(find.byKey(const Key('module-tile-prevention-rabies')), findsOneWidget);
    expect(find.byKey(const Key('module-tile-prevention-malaria')), findsOneWidget);
  });

  testWidgets('incident section includes rabies only', (tester) async {
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

    expect(find.text('Incident Help Modules'), findsOneWidget);
    expect(find.byKey(const Key('module-tile-incidentResponse-rabies')), findsOneWidget);
    expect(find.byKey(const Key('module-tile-incidentResponse-malaria')), findsNothing);
  });
}