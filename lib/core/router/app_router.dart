import 'package:go_router/go_router.dart';

import '../../feature/home/presentation/page/home_page.dart';
import '../../feature/recorder/presentation/page/recorder_page.dart';

class AppRouter {
  AppRouter._();

  static final AppRouter _instance = AppRouter._();

  static AppRouter get instance => _instance;

  GoRouter get router => GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomePage(),
            routes: [
              GoRoute(
                path: '${RecorderPage.path}/:fps',
                builder: (context, state) => RecorderPage(
                    fps: int.tryParse(state.pathParameters['fps'] ?? '')),
              ),
            ],
          ),
        ],
      );
}
