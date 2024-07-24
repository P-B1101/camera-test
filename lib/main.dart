import 'package:camera_test_app/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'core/di/di_config.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  Logger.instance.log('App started...');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'iclassifier-Android',
      theme: AppTheme.theme,
      routerConfig: AppRouter.instance.router,
      locale: const Locale('en'),
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        return const Locale('en');
      },
    );
  }
}
