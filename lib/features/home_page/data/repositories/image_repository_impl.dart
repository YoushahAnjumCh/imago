import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:imago/core/failure/failure.dart';
import 'package:imago/core/networkInfo/networkinfo.dart';
import 'package:imago/core/typedef/typedef.dart';
import 'package:imago/features/home_page/data/datasources/image_data_source.dart';
import 'package:imago/features/home_page/domain/entities/image_entity.dart';
import 'package:imago/features/home_page/domain/repositories/image_repositories.dart';

class ImageRepositoryImpl extends ImageRepository {
  final ImageDataSource dataSource;
  final NetworkInfo networkInfo;
  ImageRepositoryImpl({required this.dataSource, required this.networkInfo});

  @override
  FutureResult<ImageEntity> getImage(String text) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dataSource.getImage(text);
        return Right(response);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(e.errormessage.toString()));
      } on SocketException catch (e) {
        return Left(ServerFailure(e.message.toString()));
      }
    } else {
      return const Left(ConnectionFailure('No internet connection'));
    }
  }
}
