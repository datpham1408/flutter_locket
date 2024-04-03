import 'dart:io';

class GetImageState{}

class GetAllImage extends GetImageState{
  final List<File> file;

  GetAllImage({required this.file});
}
