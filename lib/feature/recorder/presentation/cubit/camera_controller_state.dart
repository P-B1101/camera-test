part of 'camera_controller_cubit.dart';

class CameraControllerState extends Equatable {
  final CameraState state;
  final bool isRecording;
  const CameraControllerState({
    required this.state,
    required this.isRecording,
  });

  factory CameraControllerState.init() => const CameraControllerState(
        state: CameraState.initializing,
        isRecording: false,
      );

  CameraControllerState copyWith({
    CameraState? state,
    bool? isRecording,
  }) =>
      CameraControllerState(
        state: state ?? this.state,
        isRecording: isRecording ?? this.isRecording,
      );

  bool get canRecord => switch (state) {
        CameraState.readyToUse => true,
        CameraState.failed || CameraState.initializing => false,
      };

  @override
  List<Object> get props => [state, isRecording];
}
