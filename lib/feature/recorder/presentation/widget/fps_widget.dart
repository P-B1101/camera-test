import 'package:flutter/material.dart';

class FpsWidget extends StatelessWidget {
  final int fps;
  const FpsWidget({
    super.key,
    required this.fps,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$fps f/s',
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}
