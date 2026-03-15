import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelmd/domain/modules/module_stream.dart';
import 'package:travelmd/presentation/screens/module_detail_screen.dart';

void main() {
  testWidgets('rabies detail shows prevention and incident CTAs', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ModuleDetailScreen(
            moduleId: 'rabies',
            stream: ModuleStream.prevention,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Start prevention planning'), findsOneWidget);
    expect(find.text('Learn what to do if something happens'), findsOneWidget);
  });

  testWidgets('malaria detail hides incident CTA for prevention-only module', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ModuleDetailScreen(
            moduleId: 'malaria',
            stream: ModuleStream.prevention,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Start prevention planning'), findsOneWidget);
    expect(find.text('Learn what to do if something happens'), findsNothing);
  });
}
