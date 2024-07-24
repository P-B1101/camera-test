import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widget/camera_view.dart';

class RecorderPage extends StatefulWidget {
  static const path = 'recorder';
  const RecorderPage({
    super.key,
  });

  @override
  State<RecorderPage> createState() => _RecorderPageState();
}

class _RecorderPageState extends State<RecorderPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CameraView.provider(onVideoSaved: _onVideoSaved),
      ),
    );
  }

  void _onVideoSaved(XFile file) {
    context.pop(file);
  }
}
