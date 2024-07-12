import 'package:get_it/get_it.dart';
import 'package:imago/core/networkInfo/networkinfo.dart';
import 'package:imago/features/home_page/data/datasources/image_data_source.dart';
import 'package:imago/features/home_page/data/repositories/image_repository_impl.dart';
import 'package:imago/features/home_page/domain/repositories/image_repositories.dart';
import 'package:imago/features/home_page/domain/usecases/image_usecase.dart';
import 'package:imago/features/home_page/presentation/cubit/home_page_cubit.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(
    () => HomeScreenCubit(sl()),
  );

  //UseCase
  sl.registerLazySingleton(() => ImageUseCase(sl()));

  //Repositories
  sl.registerLazySingleton<ImageRepository>(
    () => ImageRepositoryImpl(dataSource: sl(), networkInfo: sl()),
  );

  // Datasources
  sl.registerLazySingleton<ImageDataSource>(
      () => ImageRemoteDataSource(client: sl()));

  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton<NetworkInfo>(
      () => NetWorkInfoImpl(connectionChecker: sl()));
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
