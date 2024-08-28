import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:imago/core/failure/failure.dart';
import 'package:imago/features/home_page/data/models/image_artifact_model.dart';
import 'package:imago/features/service/firebase_remote_config.dart';

abstract class ImageDataSource {
  Future<ImageArtifactModel> getImage(String text);
}

class ImageRemoteDataSource implements ImageDataSource {
  final http.Client client;
  final RemoteConfigService service;
  ImageRemoteDataSource({required this.client, required this.service});

  @override
  Future<ImageArtifactModel> getImage(String text) async {
    await service.fetchAndActivate();
    final baseURL = service.getBaseURL();
    final engineId = service.getEngineID();
    final apiKey = service.getApiKey();
    final url = "$baseURL$engineId/text-to-image";
    try {
      final response = await client.post(Uri.parse(url),
          body: jsonEncode({
            "cfg_scale": 7,
            "height": 512,
            "width": 512,
            "sampler": "K_DPM_2_ANCESTRAL",
            "samples": 1,
            "steps": 30,
            "text_prompts": [
              {"text": text, "weight": 1}
            ],
          }),
          headers: {
            "authorization": apiKey,
            "Content-Type": "application/json"
          }).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        return ImageArtifactModel.fromJson(res['artifacts'][0]);
      } else {
        final res = json.decode(response.body);
        final errorMessage = res['name'];
        throw ServerFailure(errorMessage);
      }
    } on TimeoutException catch (e) {
      throw ServerFailure("Timeout Error $e");
    }
  }
}
