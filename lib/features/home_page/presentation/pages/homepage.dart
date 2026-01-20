import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imago/core/constant/app_constant.dart';
import 'package:imago/core/constant/color_constant.dart';
import 'package:imago/features/home_page/presentation/cubit/home_page_cubit.dart';
import 'package:imago/features/home_page/presentation/widgets/custom_container.dart';
import 'package:imago/features/home_page/presentation/widgets/home_screen_button.dart';

class HomePage extends StatelessWidget {
  final TextEditingController textEditingController = TextEditingController();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text(AppConstant.appName)),
      body: Column(
        children: [
          const SizedBox(height: 25),
          BlocBuilder<HomeScreenCubit, HomePageState>(
            builder: (context, state) {
              return _buildBodyContent(context, state);
            },
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: TextField(
              maxLines: 3,
              controller: textEditingController,
              decoration: const InputDecoration(hintText: AppConstant.prompt),
            ),
          ),
          const SizedBox(height: 25),
          BlocBuilder<HomeScreenCubit, HomePageState>(
            builder: (context, state) {
              final isImageAvailable = state is HomePageLoaded;
              return _buildActionButtons(context, state, isImageAvailable);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContent(BuildContext context, HomePageState state) {
    if (state is HomePageInitial ||
        state is HomePageLoading ||
        state is HomePageFailure) {
      return _buildImageContainer(state);
    } else if (state is HomePageLoaded) {
      return _buildLoadedImage(context);
    }
    return Container();
  }

  Widget _buildImageContainer(HomePageState state) {
    final errorMessage = state is HomePageFailure ? state.errorMessage : '';
    return CustomContainer(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.grey300,
      ),
      child: state is HomePageLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Text(errorMessage,
                  style: TextStyle(color: AppColors.redAccentColor))),
    );
  }

  Widget _buildLoadedImage(BuildContext context) {
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
    return Container();
  }

  Widget _buildActionButtons(
      BuildContext context, HomePageState state, bool isImageAvailable) {
    final loadingState = state is HomePageLoading;
    return Row(
      mainAxisAlignment: isImageAvailable
          ? MainAxisAlignment.spaceAround
          : MainAxisAlignment.center,
      children: [
        HomeScreenButton(
          onPressed: !loadingState
              ? () => _onFetchOrClearImage(context, isImageAvailable)
              : null,
          backgroundColor: AppColors.redAccentColor,
          foregroundColor: AppColors.whiteColor,
          text: isImageAvailable ? AppConstant.clear : AppConstant.fetch,
        ),
        if (isImageAvailable) ...[
          HomeScreenButton(
            key: const Key("save"),
            onPressed: () =>
                context.read<HomeScreenCubit>().saveImageFileToGallery(),
            backgroundColor: AppColors.redAccentColor,
            foregroundColor: AppColors.whiteColor,
            text: AppConstant.saveToGallery,
          ),
        ],
      ],
    );
  }

  void _onFetchOrClearImage(BuildContext context, bool isImageAvailable) {
    if (isImageAvailable) {
      context.read<HomeScreenCubit>().clearTempImage();
      textEditingController.clear();
    } else {
      context
          .read<HomeScreenCubit>()
          .fetchImage(textEditingController.text.trim());
    }
  }
}
