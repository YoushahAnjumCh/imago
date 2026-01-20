// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_artifact_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageArtifactModel _$ImageArtifactModelFromJson(Map<String, dynamic> json) =>
    ImageArtifactModel(
      base64: json['base64'] as String,
      finishReason: json['finishReason'] as String,
    );

Map<String, dynamic> _$ImageArtifactModelToJson(ImageArtifactModel instance) =>
    <String, dynamic>{
      'base64': instance.base64,
      'finishReason': instance.finishReason,
    };
