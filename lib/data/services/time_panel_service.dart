import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:track_workouts/data/model/picked_time/picked_time.dart';
import 'package:track_workouts/ui_elements/panel.dart';

class TimePanelService extends ChangeNotifier {
  final PanelController panelController = PanelController();
  final AudioCache _player = AudioCache(prefix: 'assets/sounds/');

  //TODO: move the animation controller to countdown viewmodel
  AnimationController _countdownController;
  PickedTime _countdownTime;
  DateTime _countdownDisposedAt;
  bool _countdownDisposed = true;

  AnimationController get countdownController => _countdownController;

  PickedTime get countdownTime => _countdownTime?.copy();

  double get countdownValue => 1 - _countdownController.value;

  void disposeCountdownController() {
    if (_countdownDisposed) return;
    _countdownController.dispose();
    _countdownDisposedAt = DateTime.now();
    _countdownDisposed = true;
  }

  void initCountdownController(TickerProvider vsync) {
    if (!_countdownDisposed) return;
    _countdownDisposed = false;

    final prevValue = _countdownController?.value;
    _countdownController = AnimationController(vsync: vsync);

    _countdownController.addListener(() async {
      if (_countdownController.value == 1) {
        _countdownTime = null;
        notifyListeners();

        await _player.play('done.mp3');
      }
    });

    if (_countdownTime != null) {
      final timeLeftBeforeDisposed = _countdownTime * (1 - prevValue);
      final timeAfterDisposed = DateTime.now().difference(_countdownDisposedAt);
      final timeLeft = timeLeftBeforeDisposed.toDuration - timeAfterDisposed;
      if (timeLeft.isNegative) {
        _countdownTime = null;
        return;
      }

      final millisLeft = timeLeft.inMilliseconds;
      final totalMillis = _countdownTime.toDuration.inMilliseconds;

      _countdownController.value = 1 - millisLeft / totalMillis;
      _countdownController.animateTo(1, duration: timeLeft);
    }
  }

  void startCountdown(PickedTime time) {
    _countdownTime = time.copy();
    _countdownController.value = 0;
    _countdownController.animateTo(1, duration: time.toDuration);
  }

  void startStopCountdown() {
    if (_countdownController.isAnimating) {
      _countdownController.stop();
    } else {
      _countdownController.animateTo(1, duration: _countdownTime.toDuration * countdownValue);
    }
  }

  void cancelCountdown() {
    _countdownTime = null;
    _countdownController.stop();
  }

  @override
  void dispose() {
    _countdownController.dispose();
    super.dispose();
  }
}
