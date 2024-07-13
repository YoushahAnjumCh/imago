import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:imago/core/failure/failure.dart';
import 'package:imago/features/home_page/data/models/image_artifact_model.dart';
import 'package:imago/features/home_page/domain/usecases/image_usecase.dart';
import 'package:imago/features/home_page/presentation/cubit/home_page_cubit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

class MockImageUseCase extends Mock implements ImageUseCase {}

class MockFile extends Mock implements File {}

class MockPermission extends Mock implements Permission {}

class MockPermissionPlatform extends Mock
    implements PermissionHandlerPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockImageUseCase mockImageUseCase;
  late HomeScreenCubit homeScreenCubit;
  late MockFile mockFile;
  late MockPermission mockPermission;
  late MockPermissionPlatform mockPermissionPlatform;
  setUpAll(() {
    mockImageUseCase = MockImageUseCase();
    mockFile = MockFile();
    mockPermission = MockPermission();
    mockPermissionPlatform = MockPermissionPlatform();
    homeScreenCubit = HomeScreenCubit(mockImageUseCase);
  });

  group('HomeScreenCubit', () {
    const String tText = "hello";
    final tImageArtifactModel = ImageArtifactModel(
      finishReason: "finish",
      base64: "iVBORw0KGgoAAAANSUhEUgAAAAUA",
    );
    test("initial state should be User Initial", () {
      expect(homeScreenCubit.state, HomePageInitial());
    });
    blocTest<HomeScreenCubit, HomePageState>(
      'emits [HomePageLoading, HomePageLoaded] when fetchImage is successful',
      build: () {
        final homeScreenCubit = HomeScreenCubit(mockImageUseCase);
        when(() => mockImageUseCase.call(tText))
            .thenAnswer((_) async => Right(tImageArtifactModel));
        when(() => mockFile.writeAsBytes(any()))
            .thenAnswer((_) async => Future.value(mockFile));

        return homeScreenCubit;
      },
      act: (cubit) => cubit.fetchImage(tText),
      wait: const Duration(seconds: 5),
      expect: () => [HomePageLoading(), const HomePageLoaded()],
    );

    blocTest<HomeScreenCubit, HomePageState>(
      'emits [HomePageLoading, HomePageFailure] when Server Failure fails',
      build: () {
        final homeScreenCubit = HomeScreenCubit(mockImageUseCase);
        when(() => mockImageUseCase.call(tText))
            .thenThrow(const ServerFailure("errormessage"));
        return homeScreenCubit;
      },
      act: (cubit) => cubit.fetchImage(tText),
      expect: () => [
        HomePageLoading(),
        const HomePageFailure(errorMessage: "ServerFailure: Server Error")
      ],
    );

    // blocTest<HomeScreenCubit, HomePageState>(
    //   'emits [HomePageLoading, HomePageFailure] when fetchImage fails',
    //   build: () {
    //     when(() => mockImageUseCase.call(tText))
    //         .thenThrow((_) async => const Left(ServerFailure("Server Error")));
    //     return homeScreenCubit;
    //   },
    //   act: (cubit) => cubit.fetchImage(tText),
    //   expect: () => [
    //     HomePageLoading(),
    //     const HomePageFailure(errorMessage: "ServerFailure: Server Error")
    //   ],
    // );

    blocTest<HomeScreenCubit, HomePageState>(
      'emits [HomePageInitial, HomePageFailure, HomePageInitial] when clearTempImage fails',
      build: () {
        final homeScreenCubit = HomeScreenCubit(mockImageUseCase);
        homeScreenCubit.imageFile = mockFile;
        when(() => mockFile.exists()).thenAnswer((_) async => false);
        return homeScreenCubit;
      },
      act: (cubit) => cubit.clearTempImage(),
      expect: () => [
        HomePageInitial(),
        const HomePageFailure(errorMessage: "Image not Found"),
        HomePageInitial(),
      ],
    );

    blocTest<HomeScreenCubit, HomePageState>(
      'emits [HomePageInitial, HomePageInitial] when clearTempImage is successful',
      build: () {
        final homeScreenCubit = HomeScreenCubit(mockImageUseCase);
        homeScreenCubit.imageFile = mockFile;
        when(() => mockFile.exists()).thenAnswer((_) async => true);
        when(() => mockFile.delete()).thenAnswer((_) async => mockFile);
        return homeScreenCubit;
      },
      act: (cubit) => cubit.clearTempImage(),
      wait: const Duration(seconds: 3),
      expect: () => [HomePageInitial()],
    );

    blocTest<HomeScreenCubit, HomePageState>(
      'emits [HomePageInitial, HomePageInitial] when clearTempImage is Path Error',
      build: () {
        final homeScreenCubit = HomeScreenCubit(mockImageUseCase);
        homeScreenCubit.imageFile = mockFile;
        when(() => mockFile.exists()).thenThrow((_) async => true);
        return homeScreenCubit;
      },
      act: (cubit) => cubit.clearTempImage(),
      expect: () => [
        HomePageInitial(),
        const HomePageFailure(errorMessage: "Path Error"),
        HomePageInitial()
      ],
    );
  });
}
