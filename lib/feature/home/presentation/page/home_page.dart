import 'package:camera/camera.dart';
import 'package:camera_test_app/core/utils/logger.dart';
import 'package:camera_test_app/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:go_router/go_router.dart';

import '../../../recorder/presentation/page/recorder_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _fps = 60;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    reverse: true,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: StreamBuilder<String>(
                        initialData: '',
                        stream: Logger.instance.observer,
                        builder: (context, snapshot) => SizedBox(
                          width: double.infinity,
                          child: Text(
                            snapshot.data ?? '',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              Center(child: _fpsInputWidget),
              const SizedBox(height: 8),
              Center(child: _startRecordingBtn),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _fpsInputWidget => SizedBox(
        width: 300,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: TextField(
            onChanged: (value) => _fps = int.tryParse(value) ?? _fps,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              hintText: 'Enter FPS: default is ${Utils.defaultFPS}',
            ),
          ),
        ),
      );

  Widget get _startRecordingBtn => FilledButton.tonal(
        onPressed: _startClick,
        child: const Text('Start'),
      );

  void _startClick() async {
    final result = await context.push('/${RecorderPage.path}/$_fps');
    if (!mounted) return;
    if (result is! XFile) {
      Logger.instance.log('Recording result is empty');
      return;
    }
    Logger.instance.log('Recorded video is saved at : ${result.path}');
    Logger.instance.log('Saving in progress...');
    final isSaved = await GallerySaver.saveVideo(result.path);
    if (!mounted) return;
    Logger.instance.log(
      isSaved == null
          ? 'Unknown result for saving process'
          : isSaved
              ? 'Video saved successfully'
              : 'Fail to save Video',
    );
  }
}
