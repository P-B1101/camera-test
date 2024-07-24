// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:camera_test_app/core/repository_manager/repo_manager.dart'
    as _i270;
import 'package:camera_test_app/feature/recorder/presentation/cubit/camera_controller_cubit.dart'
    as _i185;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i185.CameraControllerCubit>(
        () => _i185.CameraControllerCubit());
    gh.lazySingleton<_i270.RepoManager>(() => const _i270.RepoManager());
    return this;
  }
}
