import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imago/core/constant/app_constant.dart';
import 'package:imago/core/constant/color_constant.dart';
import 'package:imago/features/home_page/presentation/cubit/home_page_cubit.dart';
import 'package:imago/features/home_page/presentation/widgets/custom_container.dart';
import 'package:imago/features/home_page/presentation/widgets/home_screen_button.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(AppConstant.appName),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          BlocBuilder<HomeScreenCubit, HomePageState>(
            builder: (context, state) {
              if (state is HomePageInitial) {
                return CustomContainer(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.grey300,
                  ),
                );
              } else if (state is HomePageLoading) {
                return CustomContainer(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.grey300,
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is HomePageFailure) {
                return CustomContainer(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.grey300,
                  ),
                  child: Center(
                    child: Text(state.errorMessage),
                  ),
                );
              } else if (state is HomePageLoaded) {
                final imageFile = context.read<HomeScreenCubit>().imageFile;

                if (imageFile.path.isNotEmpty) {
                  return Column(
                    children: [
                      CustomContainer(
                        width: 250,
                        height: 250,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(imageFile),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }
              }
              return Container();
            },
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: TextField(
              maxLines: 3,
              keyboardType: TextInputType.name,
              controller: textEditingController,
              decoration: const InputDecoration(
                hintText: AppConstant.prompt,
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          BlocBuilder<HomeScreenCubit, HomePageState>(
            builder: (context, state) {
              final isImageAvailable = state is HomePageLoaded;
              final loadingState = state is HomePageLoading;
              return Row(
                mainAxisAlignment: isImageAvailable
                    ? MainAxisAlignment.spaceAround
                    : MainAxisAlignment.center,
                children: [
                  HomeScreenButton(
                      onPressed: !loadingState
                          ? () async {
                              if (isImageAvailable) {
                                await context
                                    .read<HomeScreenCubit>()
                                    .clearTempImage();
                                textEditingController.clear();
                              } else {
                                context.read<HomeScreenCubit>().fetchImage(
                                    textEditingController.text.trim());
                              }
                            }
                          : null,
                      backgroundColor: AppColors.redAccentColor,
                      foregroundColor: AppColors.whiteColor,
                      text: isImageAvailable
                          ? AppConstant.clear
                          : AppConstant.fetch),
                  isImageAvailable
                      ? HomeScreenButton(
                          onPressed: () {
                            context
                                .read<HomeScreenCubit>()
                                .saveImageFileToGallery();
                          },
                          backgroundColor: AppColors.redAccentColor,
                          foregroundColor: AppColors.whiteColor,
                          text: AppConstant.saveToGallery)
                      : const SizedBox()
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
