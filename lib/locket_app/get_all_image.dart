import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locket/locket_app/get_image_cubit.dart';
import 'package:flutter_locket/locket_app/get_image_state.dart';
import 'package:flutter_locket/locket_app/locket_state.dart';
import 'package:flutter_locket/main.dart';
import 'package:flutter_locket/utils/string.dart';

import 'locket_cubit.dart';

class GetAllImagesScreen extends StatefulWidget {
  const GetAllImagesScreen({Key? key}) : super(key: key);

  @override
  State<GetAllImagesScreen> createState() => _GetAllImagesScreenState();
}

class _GetAllImagesScreenState extends State<GetAllImagesScreen> {
  final GetImageCubit _getImageCubit = getIt.get<GetImageCubit>();

  @override
  void initState() {
    super.initState();
    _getImageCubit.getAllImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<GetImageCubit>(
          create: (_) => _getImageCubit,
          child: BlocConsumer<GetImageCubit, GetImageState>(
            listener: (_, GetImageState state) {
              _handleListener(state);
            },
            builder: (_, GetImageState state) {
              //context
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: showSelectedImages(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget showSelectedImages() {
    return BlocBuilder<GetImageCubit, GetImageState>(
      builder: (context, GetImageState state) {
        if (state is GetAllImage) {
          List<File> fileImage = state.file;
          if (fileImage.isEmpty) {
            return const Text(error);
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: fileImage.length,
              itemBuilder: (BuildContext context, int index) {
                File imageFile = fileImage[index];
                return Image.file(
                  imageFile,
                );
              },
            );
          }
        }
        return const Text(error);
      },
    );
  }

  void _handleListener(GetImageState state) {}
}
