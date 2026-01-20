import 'package:imago/core/typedef/typedef.dart';

abstract class UseCase<Type, Params> {
  FutureResult<Type> call(Params params);
}
