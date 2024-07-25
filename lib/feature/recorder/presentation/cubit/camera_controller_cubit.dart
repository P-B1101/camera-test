import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entity/camera_state.dart';

part 'camera_controller_state.dart';

@injectable
class CameraControllerCubit extends Cubit<CameraControllerState> {
  CameraControllerCubit() : super(CameraControllerState.init());

  void cameraInitialized() =>
      emit(state.copyWith(state: CameraState.readyToUse));

  void cameraFailed() => emit(state.copyWith(state: CameraState.failed));

  void updateIsRecording(bool isRecording) =>
      emit(state.copyWith(isRecording: isRecording));

  void setFps(int fps) => emit(state.copyWith(fps: fps));
}
