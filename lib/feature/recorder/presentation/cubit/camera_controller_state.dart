part of 'camera_controller_cubit.dart';

class CameraControllerState extends Equatable {
  final CameraState state;
  final bool isRecording;
  final int fps;
  const CameraControllerState({
    required this.state,
    required this.isRecording,
    required this.fps,
  });

  factory CameraControllerState.init() => const CameraControllerState(
        state: CameraState.initializing,
        isRecording: false,
        fps: 0,
      );

  CameraControllerState copyWith({
    CameraState? state,
    bool? isRecording,
    int? fps,
  }) =>
      CameraControllerState(
        state: state ?? this.state,
        isRecording: isRecording ?? this.isRecording,
        fps: fps ?? this.fps,
      );

  bool get canRecord => switch (state) {
        CameraState.readyToUse => true,
        CameraState.failed || CameraState.initializing => false,
      };

  @override
  List<Object> get props => [state, isRecording];
}
