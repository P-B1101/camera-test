import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_name => 'IClassifier Recorder';

  @override
  String get initializing_camera => 'Initializing camera ...';

  @override
  String get camera_failed => 'Camera failed to load!!!';
}
