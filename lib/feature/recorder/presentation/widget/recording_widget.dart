import 'dart:async';

import 'package:flutter/material.dart';

class RecordingWidget extends StatefulWidget {
  const RecordingWidget({super.key});

  @override
  State<RecordingWidget> createState() => _RecordingWidgetState();
}

class _RecordingWidgetState extends State<RecordingWidget> {
  bool _isShow = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isShow
        ? Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
          )
        : const SizedBox();
  }

  void _initTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _isShow = !_isShow;
        });
      }
    });
  }
}
