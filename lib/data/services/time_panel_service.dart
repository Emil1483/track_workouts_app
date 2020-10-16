import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/picked_time/picked_time.dart';
import 'package:track_workouts/ui_elements/panel.dart';
import 'package:track_workouts/utils/duration_utils.dart';
import 'package:track_workouts/utils/date_time_utils.dart';

class SavedCountdown {
  final PickedTime countdownTime;
  final DateTime countdownDisposedAt;
  final Duration leftOfCountdown;
  final bool stopped;

  SavedCountdown({
    @required this.countdownTime,
    @required this.countdownDisposedAt,
    @required this.leftOfCountdown,
    @required this.stopped,
  });

  SavedCountdown copy() {
    return SavedCountdown(
      countdownTime: countdownTime.copy(),
      countdownDisposedAt: countdownDisposedAt.copy(),
      leftOfCountdown: leftOfCountdown.copy(),
      stopped: stopped,
    );
  }
}

class TimePanelService {
  final PanelController panelController = PanelController();
  final AudioCache player = AudioCache(prefix: 'assets/sounds/');

  final List<void Function(PickedTime)> _countdownListeners = [];
  final List<void Function(Duration)> _timerListeners = [];

  SavedCountdown _savedCountdown;
  PickedTime _countdownTime;

  void addCountdownListener(void Function(PickedTime) listener) {
    _countdownListeners.add(listener);
  }

  void addTimerListener(void Function(Duration) listener) {
    _timerListeners.add(listener);
  }

  void removeCountdownListener(void Function(PickedTime) listener) {
    if (!_countdownListeners.remove(listener)) throw StateError('listener not found');
  }

  void removeTimerListener(void Function(Duration) listener) {
    if (!_timerListeners.remove(listener)) throw StateError('listener not found');
  }

  void onCountdownDone(PickedTime pickedTime) {
    _countdownListeners.forEach((listener) {
      listener(pickedTime);
    });
  }

  void onTimerCancelled(Duration timerDuration) {
    _timerListeners.forEach((listener) {
      listener(timerDuration);
    });
  }

  SavedCountdown get savedCountdown => _savedCountdown?.copy();

  PickedTime get countdownTime => _countdownTime?.copy();

  set countdownTime(PickedTime pickedTime) => _countdownTime = pickedTime;

  void saveCountdown(SavedCountdown countdown) => _savedCountdown = countdown;

  void deleteSavedCountdown() => _savedCountdown = null;
}
