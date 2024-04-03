import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locket/locket_app/locket_cubit.dart';
import 'package:flutter_locket/locket_app/locket_state.dart';
import 'package:flutter_locket/main.dart';
import 'package:flutter_locket/utils/image.dart';
import 'package:flutter_locket/utils/string.dart';


class LocketScreen extends StatefulWidget {
  final String image;

  const LocketScreen({super.key, required this.image});

  @override
  State<LocketScreen> createState() => _LocketScreenState();
}

class _LocketScreenState extends State<LocketScreen> {
  final LocketCubit _locketCubit = getIt.get<LocketCubit>();

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
                return itemBody();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget itemBody() {
    return Column(
      children: [
        itemTools(),
        itemPicture(),
        itemAvatarPeople(),
        itemFeeling(),
        itemTakeAPhoto(),
      ],
    );
  }

  Widget itemFeeling() {
    return Container(
      height: 50,
      width: 350,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Colors.grey.withOpacity(0.5)),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          const Flexible(
            child: TextField(
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
            ),
          ),
          itemEmoticon(),
        ],
      ),
    );
  }

  Widget itemImages(String image) {
    return Image.asset(image);
  }

  Widget itemEmoticon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        itemImages(fire),
        sizeBox(8),
        itemImages(heart),
        sizeBox(8),
        itemImages(love),
        sizeBox(8),
        itemImages(feel),
      ],
    );
  }

  Widget itemTakeAPhoto() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          itemImageTakeAPhoto(menu),
          itemTakePhoto(),
          itemImageTakeAPhoto(upload),
        ],
      ),
    );
  }

  Widget itemTakePhoto() {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(360),
        border: Border.all(width: 4, color: Colors.yellow),
        color: Colors.white,
      ),
    );
  }

  Widget itemImageTakeAPhoto(String image) {
    return Image.asset(
      image,
      height: 50,
      width: 50,
      color: Colors.white,
    );
  }

  Widget itemTools() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          itemDetailImageTools(male),
          itemDetailTools(people),
          itemDetailImageTools(messages),
        ],
      ),
    );
  }

  Widget itemPicture() {
    return Container(
        margin: const EdgeInsets.only(top: 48, bottom: 8),
        child: Stack(
          children: [
            itemDetailPickture(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(top: 270),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(32)),
                  child:  Text(hintText)),
            ),
          ],
        ));
  }

  Widget sizeBox(double width) {
    return SizedBox(
      width: width,
    );
  }

  Widget itemAvatarPeople() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          user,
          height: 30,
          width: 30,
          color: Colors.white,
        ),
        sizeBox(4),
         Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        sizeBox(8),
         Text(
          minutes,
          style: const TextStyle(color: Colors.grey),
        )
      ],
    );
  }

  Widget itemDetailPickture() {
    return Image.file(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
        File(widget.image));
  }

  Widget itemDetailTools(String? text) {
    if (text != null) {
      return Container(
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.symmetric(horizontal: 32),
        height: 40,
        width: MediaQuery.of(context).size.width / 3,
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
      );
    }
    return Container();
  }

  Widget itemDetailImageTools(String image) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(360),
          color: Colors.grey.withOpacity(0.2)),
      child: Image.asset(
        image,
        height: 5,
        width: 5,
        color: Colors.white,
      ),
    );
  }

  void _handleListener(LocketState state) {}
}
