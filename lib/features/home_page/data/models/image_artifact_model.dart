import 'package:imago/features/home_page/domain/entities/image_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'image_artifact_model.g.dart';

@JsonSerializable()
class ImageArtifactModel extends ImageEntity {
  const ImageArtifactModel({
    required super.base64,
    required super.finishReason,
  });

  factory ImageArtifactModel.fromJson(Map<String, dynamic> json) =>
      _$ImageArtifactModelFromJson(json);
}
