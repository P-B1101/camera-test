import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';

extension BuildContextExt on BuildContext {
  AppLocalizations get getString {
    final localization = AppLocalizations.of(this);
    if (localization == null) throw Exception('Wrong context to use for l10n');
    return localization;
  }

  String? get getFullPath => GoRouterState.of(this).getFullPath;
}

extension GoRouterStateExt on GoRouterState {
  String? get getFullPath {
    final pathParams = pathParameters;
    final keys = pathParams.keys;
    var result = fullPath ?? '';
    for (final key in keys) {
      result = result.replaceFirst(':$key', pathParams[key] ?? key);
    }
    if (result == '/') return '';
    return result;
  }

  List<String> get getAllPath => getFullPath?.split('/') ?? [];
}
