import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locket/locket_app/get_image_state.dart';
import 'package:path_provider/path_provider.dart';

class GetImageCubit extends Cubit<GetImageState> {
  GetImageCubit() : super(GetImageState());


  Future<void> getAllImages() async {
    List<File> selectedImages = [];
    // Lấy đường dẫn thư mục chứa hình ảnh
    List<Directory>? appDir = await getExternalStorageDirectories();
    var list = appDir?.map((FileSystemEntity f) => f.path);

    Directory imagesDir = Directory('/Images');

    // Kiểm tra xem thư mục tồn tại hay không
    if (imagesDir.existsSync()) {
      // Lấy danh sách các tệp hình ảnh trong thư mục
      List<FileSystemEntity> files = imagesDir.listSync();

      // Lọc các tệp hình ảnh
      for (var file in files) {
        if (file is File && file.path.endsWith('.png')) {
          selectedImages.add(file);
        }
      }
    }
    emit(GetAllImage(file: selectedImages));
    var i = 0;
  }
}
