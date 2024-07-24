import 'dart:async';

import 'package:camera_test_app/core/utils/logger.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../error/exceptions.dart';
import '../error/failures.dart';

typedef LoadOrFail<T> = Future<T> Function();

@lazySingleton
class RepoManager {
  const RepoManager();

  Future<Either<Failure, T>> tryToLoad<T>(LoadOrFail<T> loadOrFail) async {
    /// comment this line of code so demo app can work offline.
    // if (!(await networkInfo.isConnected)) return Left(NetworkFailure());
    try {
      return Right(await loadOrFail());
    } on ServerException catch (error) {
      Logger.instance.log(error.toString());
      return Left(ServerFailure(message: error.message));
    } on Exception catch (error) {
      Logger.instance.log(error.toString());
      return const Left(ServerFailure());
    }
  }
}
