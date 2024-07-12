import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:imago/core/failure/failure.dart';
import 'package:imago/core/networkInfo/networkinfo.dart';
import 'package:imago/features/home_page/data/datasources/image_data_source.dart';
import 'package:imago/features/home_page/data/repositories/image_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock/constant/mock_constant.dart';

class MockRemoteDataSource extends Mock implements ImageDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockRemoteDataSource remoteDataSource;
  late NetworkInfo networkInfo;
  late ImageRepositoryImpl repositoryImpl;

  setUp(() {
    remoteDataSource = MockRemoteDataSource();
    networkInfo = MockNetworkInfo();

    repositoryImpl = ImageRepositoryImpl(
        networkInfo: networkInfo, dataSource: remoteDataSource);
  });

  group("device is online", () {
    setUp(() {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
    });

    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // Arrange

      when(() => remoteDataSource.getImage("hello"))
          .thenAnswer((_) async => tImageModel);

      // Act
      final result = await repositoryImpl.getImage("hello");

      // Assert
      result.fold(
        (left) => fail("Expected a Right, but got a Left: $left"),
        (right) => expect(right, equals(tImageModel)),
      );
    });

    test(
        'should return ServerFailure when the call to remote data source is a failure',
        () async {
      // Arrange
      when(() => remoteDataSource.getImage("hello"))
          .thenThrow(ServerFailure(""));

      // Act
      final result = await repositoryImpl.getImage("hello");

      // Assert
      result.fold(
        (left) => expect(left, isA<ServerFailure>()),
        (right) => fail("Expected a Left, but got a Right: $right"),
      );
    });

    test(
        'should return SocketException when the call to remote data source is a failure',
        () async {
      // Arrange
      when(() => remoteDataSource.getImage("hello"))
          .thenThrow(const SocketException("message"));

      // Act
      final result = await repositoryImpl.getImage("hello");

      // Assert
      result.fold(
        (left) => expect(left, isA<ServerFailure>()),
        (right) => fail("Expected a Left, but got a Right: $right"),
      );
    });
  });

  group("device is offline", () {
    setUp(() {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);
    });
    test('should return Connection failure ', () async {
      //Act
      final result = await repositoryImpl.getImage("text");
      //Assert
      result.fold((left) => expect(left, isA<ConnectionFailure>()),
          (right) => fail("test failed"));
    });
  });
}
