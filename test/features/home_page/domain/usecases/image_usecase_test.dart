import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imago/features/home_page/domain/repositories/image_repositories.dart';
import 'package:imago/features/home_page/domain/usecases/image_usecase.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock/constant/mock_constant.dart';

class MockImageRepository extends Mock implements ImageRepository {}

void main() {
  late MockImageRepository repository;
  late ImageUseCase useCase;

  setUp(() {
    repository = MockImageRepository();
    useCase = ImageUseCase(repository);
  });

  test("should return image entity when repository call", () async {
    // arrange
    when(() => repository.getImage("hello"))
        .thenAnswer((invocation) async => const Right(tImageEntity));
    //act
    final result = await useCase("hello");
    //assert
    expect(result, const Right(tImageEntity));
  });
}
