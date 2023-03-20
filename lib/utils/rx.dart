import 'package:rxdart/rxdart.dart';

const DEBOUNCE_TIME_MS = 1000;

class RxUtils {
  static Stream<T> searchWrapper<T>(
      Stream<String> stream, Function searchFunc) {
    return stream
        .debounceTime(const Duration(milliseconds: DEBOUNCE_TIME_MS))
        .switchMap((term) => Stream.fromFuture(Future.value(searchFunc(term))));
  }
}
