import 'package:go_router/go_router.dart';
import 'package:travelmd/presentation/screens/home_screen.dart';
import 'package:travelmd/presentation/screens/trip_screen.dart';
import 'package:travelmd/presentation/screens/traveler_screen.dart';
import 'package:travelmd/presentation/screens/plan_screen.dart';
import 'package:travelmd/presentation/screens/rabies_exposure_wizard_screen.dart';

/// App routing configuration for TravelMD.
final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
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
