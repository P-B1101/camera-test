import 'package:rxdart/subjects.dart';

final class Logger {
  Logger._();

  static final Logger _instance = Logger._();

  static Logger get instance => _instance;

  final _controller = BehaviorSubject<String>();
  final StringBuffer _buffer = StringBuffer();

  void log(Object message) {
    _buffer.writeln(message.toString());
    _controller.add(_buffer.toString());
  }

  Stream<String> get observer => _controller.stream;
}
