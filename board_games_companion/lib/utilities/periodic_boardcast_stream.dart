import 'dart:async';

class PeriodicBroadcastStream {
  PeriodicBroadcastStream(this.duration) {
    _controller = StreamController<void>.broadcast(onListen: () {
      _timer = Timer.periodic(duration, (timer) {
        _controller.add(null);
      });
    }, onCancel: () {
      _timer?.cancel();
    });
  }

  final Duration duration;

  StreamController<void> _controller;
  Timer _timer;

  Stream<void> get stream => _controller.stream;

  void dispose() {
    _controller.close();
  }
}
