
class LocketState{}

class CameraInitialState extends LocketState {}

class CameraLoadingState extends LocketState {}

class CameraErrorState extends LocketState {
  final String errorMessage;

  CameraErrorState(this.errorMessage);
}

class CameraReadyState extends LocketState {
}

