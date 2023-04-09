import 'dart:async';

typedef DebounceCallback = void Function();

class Debouncer {
  final Duration duration;
  Timer? _timer;

  Debouncer({required this.duration});

  void debounce(DebounceCallback callback) {
    _timer?.cancel();
    _timer = Timer(duration, callback);
  }

  void cancel() {
    _timer?.cancel();
  }
}
