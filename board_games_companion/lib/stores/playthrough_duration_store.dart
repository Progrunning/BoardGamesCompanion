import 'dart:async';

import 'package:flutter/foundation.dart';

import '../common/enums/playthrough_status.dart';
import '../models/hive/playthrough.dart';

class PlaythroughDurationStore with ChangeNotifier {
  PlaythroughDurationStore(this._playthrough) {
    _calculateDuration();
    notifyListeners();

    if (_playthrough.status != PlaythroughStatus.Finished) {
      final tickTimerInterval = durationInSeconds > Duration.secondsPerHour
          ? _eveyrMinuteTimerTick
          : _eveyrSecondTimerTick;
      _timer = Timer.periodic(tickTimerInterval, _handleTick);
    }
  }

  static const _eveyrSecondTimerTick = Duration(seconds: 1);
  static const _eveyrMinuteTimerTick = Duration(minutes: 1);

  final Playthrough _playthrough;

  Timer _timer;
  int _durationInSeconds;
  int get durationInSeconds => _durationInSeconds;

  void _handleTick(Timer timer) {
    _calculateDuration();
    notifyListeners();
  }

  void _calculateDuration() {
    final nowUtc = DateTime.now().toUtc();
    final playthroughEndDate = _playthrough.endDate ?? nowUtc;
    _durationInSeconds = playthroughEndDate.difference(_playthrough.startDate).inSeconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
