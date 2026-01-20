import 'package:equatable/equatable.dart';
import 'package:imago/features/home_page/domain/entities/image_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'image_artifact_model.g.dart';

@JsonSerializable()
class ImageArtifactModel extends ImageEntity with EquatableMixin {
  const ImageArtifactModel({
    required super.base64,
    required super.finishReason,
  });

  factory ImageArtifactModel.fromJson(Map<String, dynamic> json) =>
      _$ImageArtifactModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImageArtifactModelToJson(this);

  @override
  List<Object?> get props => [super.base64, super.finishReason];
}
