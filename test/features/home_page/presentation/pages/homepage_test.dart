import 'dart:io';
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:imago/features/home_page/presentation/cubit/home_page_cubit.dart';
import 'package:imago/features/home_page/presentation/pages/homepage.dart';
import 'package:imago/features/home_page/presentation/widgets/custom_container.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockHomeScreenCubit extends MockCubit<HomePageState>
    implements HomeScreenCubit {}

class MockFile extends Mock implements File {}

void main() {
  final getIt = GetIt.instance;
  late MockHomeScreenCubit mockCubit;
  late MockFile file;

  setUpAll(() {
    registerFallbackValue(HomePageInitial());
    registerFallbackValue(MockFile());
  });

  setUp(() {
    mockCubit = MockHomeScreenCubit();
    file = MockFile();
    getIt.registerSingleton<HomeScreenCubit>(mockCubit);
    when(() => file.length()).thenAnswer((_) async => 1000);
    when(() => file.readAsBytes()).thenAnswer((_) async {
      final byteData = await rootBundle.load('test/assets/images.jpeg');
      return byteData.buffer.asUint8List();
    });
    when(() => file.readAsBytes())
        .thenAnswer((_) async => Uint8List.fromList([0, 1, 2, 3, 4, 5]));
    when(() => file.exists()).thenAnswer((_) async => true);
  });

  tearDown(() {
    getIt.reset();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<HomeScreenCubit>(
        create: (_) => GetIt.I<HomeScreenCubit>(),
        child: HomePage(),
      ),
    );
  }

  group("HomePage State", () {
    testWidgets('shows loading indicator when state is initial',
        (tester) async {
      when(() => mockCubit.state).thenReturn(HomePageInitial());
      when(() => mockCubit.stream)
          .thenAnswer((_) => Stream.value(HomePageInitial()));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CustomContainer), findsOneWidget);
    });

    testWidgets('shows loading indicator when state is loading',
        (tester) async {
      when(() => mockCubit.state).thenReturn(HomePageLoading());
      when(() => mockCubit.stream)
          .thenAnswer((_) => Stream.value(HomePageLoading()));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
  testWidgets('shows loading indicator when state is failure', (tester) async {
    when(() => mockCubit.state)
        .thenReturn(const HomePageFailure(errorMessage: ''));
    when(() => mockCubit.stream).thenAnswer(
        (_) => Stream.value(const HomePageFailure(errorMessage: '')));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CustomContainer), findsOneWidget);
  });

  group("HomePage State", () {
    testWidgets('shows loaded state with image', (tester) async {
      const imagePath = 'test/assets/images.jpeg';

      // Mock file and cubit behaviors
      when(() => file.path).thenReturn(imagePath);
      when(() => file.readAsBytes()).thenAnswer((_) async {
        final byteData = await rootBundle.load(imagePath);
        return byteData.buffer.asUint8List();
      });
      when(() => mockCubit.imageFile).thenReturn(file);
      when(() => mockCubit.state).thenReturn(const HomePageLoaded());
      when(() => mockCubit.stream)
          .thenAnswer((_) => Stream.value(const HomePageLoaded()));

      // Build and pump widget
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verify expected widgets are present
      expect(find.byType(CustomContainer), findsWidgets);
      expect(find.byType(Image), findsOneWidget);
    });

    // testWidgets('taps clear button', (tester) async {
    //   final imagePath = 'path/to/image.png';
    //   when(() => file.path).thenReturn(imagePath);
    //   when(() => mockCubit.imageFile).thenReturn(file);

    //   when(() => mockCubit.state).thenReturn(HomePageLoaded());
    //   when(() => mockCubit.stream)
    //       .thenAnswer((_) => Stream.value(HomePageLoaded()));

    //   await tester.pumpWidget(createWidgetUnderTest());
    //   await tester.pumpAndSettle();

    //   await tester.tap(find.text(AppConstant.clear));
    //   await tester.pump();

    //   verify(() => mockCubit.clearTempImage()).called(1);
    // });
  });
}
