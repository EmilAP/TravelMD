import 'package:go_router/go_router.dart';
import 'package:travelmd/presentation/screens/home_screen.dart';
import 'package:travelmd/presentation/screens/module_detail_screen.dart';
import 'package:travelmd/presentation/screens/modules_screen.dart';
import 'package:travelmd/presentation/screens/trip_screen.dart';
import 'package:travelmd/presentation/screens/traveler_screen.dart';
import 'package:travelmd/presentation/screens/plan_screen.dart';
import 'package:travelmd/presentation/screens/rabies_exposure_wizard_screen.dart';
import 'package:travelmd/domain/modules/module_stream.dart';

/// App routing configuration for TravelMD.
final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'modules',
          builder: (context, state) {
            final focus = state.uri.queryParameters['focus'];
            final focusStream = focus == null
                ? null
                : ModuleStream.values.firstWhere(
                    (stream) => stream.name == focus,
                    orElse: () => ModuleStream.prevention,
                  );
            return ModulesScreen(focusStream: focusStream);
          },
          routes: [
            GoRoute(
              path: ':moduleId',
              builder: (context, state) {
                final streamName = state.uri.queryParameters['stream'] ?? 'prevention';
                final stream = ModuleStream.values.firstWhere(
                  (value) => value.name == streamName,
                  orElse: () => ModuleStream.prevention,
                );
                return ModuleDetailScreen(
                  moduleId: state.pathParameters['moduleId']!,
                  stream: stream,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'trip',
          builder: (context, state) => const TripScreen(),
          routes: [
            GoRoute(
              path: 'traveler',
              builder: (context, state) => const TravelerScreen(),
              routes: [
                GoRoute(
                  path: 'plan',
                  builder: (context, state) => const PlanScreen(),
                  routes: [
                    GoRoute(
                      path: 'exposure',
                      builder: (context, state) => const RabiesExposureWizardScreen(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
