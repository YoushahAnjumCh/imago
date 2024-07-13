import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:imago/core/failure/failure.dart';
import 'package:imago/features/home_page/domain/usecases/image_usecase.dart';
import 'package:permission_handler/permission_handler.dart';

part 'home_page_state.dart';

class HomeScreenCubit extends Cubit<HomePageState> {
  final ImageUseCase useCase;

  HomeScreenCubit(this.useCase) : super(HomePageInitial());
  late File imageFile;

  Future<void> fetchImage(String text) async {
    emit(HomePageLoading());
    try {
      final result = await useCase.call(text);
      result
          .fold((left) => emit(HomePageFailure(errorMessage: left.toString())),
              (right) async {
        await getBase64Image(right.base64);
        emit(const HomePageLoaded());
      });
    } on ServerFailure catch (e) {
      emit(HomePageFailure(errorMessage: e.toString()));
    }
  }

  Future<File> getBase64Image(String base64Image) async {
    final bytes = base64Decode(base64Image);
    Directory tempDir = await Directory.systemTemp.createTemp();

    final imagePath = '${tempDir.path}/temp_image.png';

    imageFile = File(imagePath);
    await imageFile.writeAsBytes(bytes);
    return imageFile;
  }

  Future<void> clearTempImage() async {
    emit(HomePageInitial());
    try {
      if (await imageFile.exists()) {
        await imageFile.delete();
      } else {
        emit(const HomePageFailure(errorMessage: "Image not Found"));
      }
    } catch (e) {
      emit(const HomePageFailure(errorMessage: "Path Error"));
    }
    emit(HomePageInitial());
  }

  Future<void> saveImageFileToGallery() async {
    if (!(await Permission.storage.status.isGranted)) {
      await Permission.storage.request();
    }

    if (await Permission.storage.status.isGranted) {
      final bytes = await imageFile.readAsBytes();

      await ImageGallerySaver.saveImage(Uint8List.fromList(bytes));
    } else {}
  }
}
