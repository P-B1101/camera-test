// ignore_for_file: avoid_print

import 'dart:async';

import 'package:camera/camera.dart';
import 'package:camera_test_app/core/utils/extensions.dart';
import 'package:camera_test_app/feature/recorder/presentation/widget/fps_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di_config.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entity/camera_state.dart';
import '../cubit/camera_controller_cubit.dart';
import 'recording_widget.dart';

typedef VideoSavedCallback = void Function(XFile file);

class CameraView extends StatefulWidget {
  final VideoSavedCallback onVideoSaved;
  final int fps;
  const CameraView._({
    required this.onVideoSaved,
    required this.fps,
  });

  @override
  State<CameraView> createState() => _CameraViewState();

  static Widget provider({
    required VideoSavedCallback onVideoSaved,
    required int fps,
  }) =>
      MultiBlocProvider(
        providers: [
          BlocProvider<CameraControllerCubit>(
            create: (context) => getIt<CameraControllerCubit>(),
          )
        ],
        child: CameraView._(onVideoSaved: onVideoSaved, fps: fps),
      );
}

class _CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  CameraController? _controller;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCameraController(cameraController.description);
    }
  }

  @override
  void dispose() async {
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraControllerCubit, CameraControllerState>(
      builder: (context, state) => Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              child: switch (state.state) {
                CameraState.initializing => _loadingWidget,
                CameraState.readyToUse => _cameraWidget,
                CameraState.failed => _failureWidget,
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BlocBuilder<CameraControllerCubit, CameraControllerState>(
              builder: (context, state) => AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                sizeCurve: Curves.ease,
                firstCurve: Curves.ease,
                secondCurve: Curves.ease,
                crossFadeState: state.canRecord
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: _startStopBtn,
                secondChild: const SizedBox.square(dimension: 56),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget get _loadingWidget => Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        alignment: Alignment.center,
        child: Text(
          context.getString.initializing_camera,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.w900,
          ),
        ),
      );

  Widget get _cameraWidget =>
      _controller != null && _controller!.value.isInitialized
          ? AspectRatio(
              aspectRatio: 1 / _controller!.value.aspectRatio,
              child: CameraPreview(
                _controller!,
                child: Stack(
                  children: [
                    BlocBuilder<CameraControllerCubit, CameraControllerState>(
                      buildWhen: (previous, current) =>
                          previous.isRecording != current.isRecording,
                      builder: (context, state) => state.isRecording
                          ? const Align(
                              alignment: AlignmentDirectional.topStart,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 18,
                                ),
                                child: RecordingWidget(),
                              ),
                            )
                          : const SizedBox(),
                    ),
                    BlocBuilder<CameraControllerCubit, CameraControllerState>(
                      buildWhen: (previous, current) =>
                          previous.fps != current.fps,
                      builder: (context, state) => state.fps > 0
                          ? Align(
                              alignment: AlignmentDirectional.topEnd,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 18,
                                ),
                                child: FpsWidget(fps: state.fps),
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.expand();

  Widget get _failureWidget => Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.getString.camera_failed,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.tonal(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Back'),
            ),
          ],
        ),
      );

  Widget get _startStopBtn => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: SizedBox.square(
          dimension: 56,
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withOpacity(.5),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.withOpacity(.5),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: _handleBtnClick,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  void _initCamera() async {
    try {
      Logger.instance.log('Getting available Cameras');
      final cameras = await availableCameras();
      Logger.instance.log('Found ${cameras.length} cameras');
      for (var camera in cameras) {
        if (camera.lensDirection == CameraLensDirection.back) {
          Logger.instance.log('Find back camera. start initializing it.');
          await _initializeCameraController(camera);
          return;
        }
      }
      Logger.instance.log('camera not found!');
    } catch (error) {
      Logger.instance.log(error);
      if (!mounted) return;
      context.read<CameraControllerCubit>().cameraFailed();
    }
  }

  Future<void> _initializeCameraController(CameraDescription cameraDesc) async {
    final cameraController = CameraController(
      cameraDesc,
      ResolutionPreset.veryHigh,
      enableAudio: false,
      fps: widget.fps,
      // videoBitrate: widget.fps * 100000,
    );
    Logger.instance.log(
      'Camera setting  ->  ${cameraController.mediaSettings.toString()}',
    );
    _controller = cameraController;
    try {
      await cameraController.initialize();
      Logger.instance.log('Camera initialized successfully');
      cameraController.addListener(() {
        // if (mounted) {
        //   setState(() {});
        // }
        if (cameraController.value.hasError) {
          context.read<CameraControllerCubit>().cameraFailed();
          Logger.instance
              .log('Camera Error: ${cameraController.value.errorDescription}');
          return;
        }
        if (cameraController.mediaSettings.fps != null) {
          context
              .read<CameraControllerCubit>()
              .setFps(cameraController.mediaSettings.fps!);
        }
      });
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          Logger.instance.log('You have denied camera access.');
        case 'AudioAccessDenied':
          Logger.instance.log('You have denied audio access.');
        default:
          Logger.instance.log(e);
          break;
      }
      if (!mounted) return;
      context.read<CameraControllerCubit>().cameraFailed();
    }
    if (!mounted) return;
    context.read<CameraControllerCubit>().cameraInitialized();
  }

  void _handleBtnClick() {
    final isRecording = context.read<CameraControllerCubit>().state.isRecording;
    if (isRecording) {
      _stopVideoRecording();
      return;
    }
    _startVideoRecording();
  }

  Future<void> _startVideoRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      Logger.instance.log('Error: select a camera first.');
      context.read<CameraControllerCubit>().cameraFailed();
      return;
    }
    if (_controller!.value.isRecordingVideo) return;
    try {
      await _controller!.startVideoRecording();
      if (mounted) {
        context.read<CameraControllerCubit>().updateIsRecording(true);
      }
    } on CameraException catch (e) {
      Logger.instance.log(e);
      if (!mounted) return;
      context.read<CameraControllerCubit>().cameraFailed();
      return;
    }
  }

  Future<void> _stopVideoRecording() async {
    if (_controller == null || !_controller!.value.isRecordingVideo) {
      Logger.instance.log('_controller not initialized');
      // _controller?.dispose();
      return;
    }
    try {
      final file = await _controller!.stopVideoRecording();
      if (mounted) {
        context.read<CameraControllerCubit>().updateIsRecording(false);
      }
      widget.onVideoSaved(file);
      // _controller?.dispose();
      // _controller = null;
    } on CameraException catch (e) {
      Logger.instance.log(e);
      if (!mounted) return;
      context.read<CameraControllerCubit>().cameraFailed();
      return;
    }
  }
}
