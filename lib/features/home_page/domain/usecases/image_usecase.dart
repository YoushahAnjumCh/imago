import 'package:imago/core/typedef/typedef.dart';
import 'package:imago/core/usecase/usecase.dart';
import 'package:imago/features/home_page/domain/entities/image_entity.dart';
import 'package:imago/features/home_page/domain/repositories/image_repositories.dart';

class ImageUseCase extends UseCase<ImageEntity, String> {
  final ImageRepository repository;
  ImageUseCase(this.repository);
  @override
  FutureResult<ImageEntity> call(String params) async {
    return await repository.getImage(params);
  }
}
