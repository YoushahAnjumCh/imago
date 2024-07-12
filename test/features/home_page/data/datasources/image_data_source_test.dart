import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imago/core/failure/failure.dart';
import 'package:imago/features/home_page/data/datasources/image_data_source.dart';
import 'package:imago/features/home_page/data/models/image_artifact_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import '../../../../helpers/fixture/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockHttpClient;
  late ImageRemoteDataSource imageRemoteDataSource;

  setUp(() async {
    mockHttpClient = MockHttpClient();
    imageRemoteDataSource = ImageRemoteDataSource(client: mockHttpClient);
    await dotenv.load(fileName: ".env");
  });

  test("should return success when user clicks fetch", () async {
    final fakeResponse = fixture("image_artifact/image_artifact_mock.json");
    final url =
        "${dotenv.env["BaseURL"]}${dotenv.env["EngineID"]}/text-to-image";

    // Arrange
    when(() => mockHttpClient.post(Uri.parse(url),
                body: jsonEncode({
                  "cfg_scale": 7,
                  "height": 512,
                  "width": 512,
                  "sampler": "K_DPM_2_ANCESTRAL",
                  "samples": 1,
                  "steps": 30,
                  "text_prompts": [
                    {"text": "hello", "weight": 1}
                  ],
                }),
                headers: {
                  "authorization": "${dotenv.env["APIKEY"]}",
                  "Content-Type": "application/json"
                }).timeout(const Duration(seconds: 30)))
        .thenAnswer((_) async => http.Response(fakeResponse, 200));

    // Act
    final result = await imageRemoteDataSource.getImage("hello");

    // Assert
    expect(result, isA<ImageArtifactModel>());
  });

  test("should return ServerFailure when user clicks fetch", () async {
    final url =
        "${dotenv.env["BaseURL"]}${dotenv.env["EngineID"]}/text-to-image";
    final fakeErrorResponse = jsonEncode({
      "id": "e85275bde255550296191679ad276c5c",
      "message": "Not Found",
      "name": "not_found"
    });

    // Arrange
    when(() => mockHttpClient.post(Uri.parse(url),
            body: jsonEncode({
              "cfg_scale": 7,
              "height": 512,
              "width": 512,
              "sampler": "K_DPM_2_ANCESTRAL",
              "samples": 1,
              "steps": 30,
              "text_prompts": [
                {"text": "hello", "weight": 1}
              ],
            }),
            headers: {
              "authorization": "${dotenv.env["APIKEY"]}",
              "Content-Type": "application/json"
            })).thenAnswer((_) async => http.Response(fakeErrorResponse, 404));

    // Act
    expect(() async => await imageRemoteDataSource.getImage("hello"),
        throwsA(isA<ServerFailure>()));
  });

  test("should return ServerFailure when a TimeoutException occurs", () async {
    final url =
        "${dotenv.env["BaseURL"]}${dotenv.env["EngineID"]}/text-to-image";

    // Arrange
    when(() => mockHttpClient.post(Uri.parse(url),
            body: jsonEncode({
              "cfg_scale": 7,
              "height": 512,
              "width": 512,
              "sampler": "K_DPM_2_ANCESTRAL",
              "samples": 1,
              "steps": 30,
              "text_prompts": [
                {"text": "hello", "weight": 1}
              ],
            }),
            headers: {
              "authorization": "${dotenv.env["APIKEY"]}",
              "Content-Type": "application/json"
            })).thenThrow(TimeoutException("Request timed out"));

    // Act
    expect(() async => await imageRemoteDataSource.getImage("hello"),
        throwsA(isA<ServerFailure>()));
  });
}
