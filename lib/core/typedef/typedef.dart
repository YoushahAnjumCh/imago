import 'package:either_dart/either.dart';
import 'package:imago/core/failure/failure.dart';

typedef FutureResult<T> = Future<Either<Failure, T>>;

typedef ResultVoid = FutureResult<void>;
