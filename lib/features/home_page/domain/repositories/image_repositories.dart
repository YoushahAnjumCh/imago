import 'package:imago/core/typedef/typedef.dart';
import 'package:imago/features/home_page/domain/entities/image_entity.dart';

abstract class ImageRepository {
  FutureResult<ImageEntity> getImage(String text);
}
