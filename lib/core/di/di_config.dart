import 'package:get_it/get_it.dart';
// import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import 'di_config.config.dart';

final getIt = GetIt.instance;

@injectableInit
GetIt configureDependencies() => getIt.init();

// @module
// abstract class RegisterSharedPref {
//   @preResolve
//   @lazySingleton
//   Future<SharedPreferences> pref() async =>
//       await SharedPreferences.getInstance();
// }
