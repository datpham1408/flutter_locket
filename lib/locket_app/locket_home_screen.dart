import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locket/locket_app/locket_cubit.dart';
import 'package:flutter_locket/locket_app/locket_state.dart';
import 'package:flutter_locket/main.dart';
import 'package:flutter_locket/router/route_constant.dart';
import 'package:flutter_locket/utils/image.dart';
import 'package:flutter_locket/utils/string.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
class LocketHomeScreen extends StatefulWidget {
  const LocketHomeScreen({Key? key}) : super(key: key);

  @override
  State<LocketHomeScreen> createState() => _LocketHomeScreenState();
}

class _LocketHomeScreenState extends State<LocketHomeScreen> {
  final LocketCubit _locketCubit = getIt.get<LocketCubit>();
  CameraController? _controller;
  List<CameraDescription>? cameraDescriptions;
  int cameraIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {

      _initializeCamera();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: BlocProvider<LocketCubit>(
            create: (_) => _locketCubit,
            child: BlocConsumer<LocketCubit, LocketState>(
              listener: (_, LocketState state) {
                _handleListener(state);
              },
              builder: (_, LocketState state) {
                //context
                return Container(
                  child: itemBody(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _initializeCamera() async {
    cameraDescriptions = await availableCameras();
    _controller =
        CameraController(cameraDescriptions![1], ResolutionPreset.medium);
    await _controller?.initialize();
    _locketCubit.readyCamera();
  }

  Widget itemBody() {
    return Column(
      children: [
        itemTools(),
        itemCamera(),
        itemTakeAPhoto(),
      ],
    );
  }

  Widget itemTakeAPhoto() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          itemImageTakeAPhoto(album, () {
            openImageGallery();
          }),
          itemTakePhoto(),
          itemImageTakeAPhoto(exchange, () {
            switchCamera();
          }),
        ],
      ),
    );
  }

  void _takePhoto() async {
    try {
      final XFile? photo = await _controller?.takePicture();
      if (photo?.path.isNotEmpty == true) {
        String path = photo?.path ?? '';
        handleClickLocket(File(path));
      }
    } catch (e) {
      print('Error taking photo: $e');
    }
  }


  Future<void> openImageGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      handleClickLocket(File(pickedImage.path));
    }
  }

  Future<void> switchCamera() async {
    if (_controller?.description.lensDirection == CameraLensDirection.front) {
      updateDescriptions(cameraDescriptions![0]);
      return;
    }
    updateDescriptions(cameraDescriptions![1]);
  }

 void updateDescriptions(CameraDescription description) {
    _controller?.pausePreview();
    _controller?.setDescription(description);
    _controller?.resumePreview();
  }

  Widget itemTakePhoto() {
    return GestureDetector(
      onTap: () {
        _takePhoto();
      },
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(360),
          border: Border.all(width: 4, color: Colors.yellow),
          color: Colors.white,
        ),
      ),
    );
  }

  Widget itemImageTakeAPhoto(String image, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        onTap.call();
      },
      child: Image.asset(
        image,
        height: 50,
        width: 50,
        color: Colors.white,
      ),
    );
  }

  Widget itemTools() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          itemDetailImageTools(
            image: male,
            onTap: () {
              handleClickGetAllImage();
            },
          ),
          itemDetailTools(people),
          itemDetailImageTools(
            image: messages,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  void handleClickPhonebook() {
    GoRouter.of(context).pushNamed(
      routerNamePhoneBook,
    );
  }

  void handleClickLocket(File image) {
    GoRouter.of(context).pushNamed(
      routerNameLocket,
      extra: {'image': image.path},
    );
  }

  void handleClickMessage() {
    GoRouter.of(context).pushNamed(
      routerNameMessage,
    );
  }

  void handleClickGetAllImage() {
    GoRouter.of(context).pushNamed(routerNameGetImage);
  }

  Widget itemCamera() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 48),
      child: itemDetailCamera(),
    );
  }

  Widget itemDetailCamera() {
    return BlocBuilder<LocketCubit, LocketState>(
        builder: (_, LocketState state) {
      if (state is CameraReadyState && _controller?.value != null) {
        Size sizeContainer = MediaQuery.of(context).size;
        return Container(
          height: sizeContainer.height / 2,
          width: sizeContainer.width,
          child: AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: CameraPreview(_controller!),
          ),
        );
      }
      return const Text(error);
    });
  }

  Widget itemDetailTools(String text) {
    return Flexible(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(360),
            color: Colors.grey.withOpacity(0.2)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget itemDetailImageTools({String image = '', VoidCallback? onTap}) {
    // CircleAvatar
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(360),
            color: Colors.grey.withOpacity(0.2)),
        child: Image.asset(
          //load image from local
          image,
          height: 5,
          width: 5,
          color: Colors.white,
        ),
      ),
    );
  }

  void _handleListener(LocketState state) {}
}
