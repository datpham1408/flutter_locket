import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locket/locket_app/locket_state.dart';
import 'package:path_provider/path_provider.dart';

class LocketCubit extends Cubit<LocketState> {
  LocketCubit() : super(LocketState());

  void readyCamera() {
    emit(CameraReadyState());
  }

}
