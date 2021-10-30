import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  Timer? _timer;
  final int _waitTimeInSec;
  int _currentWaitTimeInSec;
  double _percent;
  String _timeStr;

  TimerCubit({required int waitTimeInSec})
      : _waitTimeInSec = waitTimeInSec,
        _currentWaitTimeInSec = waitTimeInSec,
        _percent = 1,
        _timeStr = "${waitTimeInSec ~/ 60}".padLeft(2, '0') +":"+"${waitTimeInSec % 60}".padLeft(2, '0'),
        super(TimerInitial("${waitTimeInSec ~/ 60}".padLeft(2, '0') +":"+"${waitTimeInSec % 60}".padLeft(2, '0'), 1));



  Future<void> startTimer() async{
  emit(TimerRunState(_timeStr, _percent, _waitTimeInSec));
  _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
    _currentWaitTimeInSec -= 1;
    _percent = _currentWaitTimeInSec / _waitTimeInSec;
    _timeStr = await calculationTime();
    emit(TimerRunState(_timeStr, _percent, _waitTimeInSec));
    if (_currentWaitTimeInSec < 0) {
      _currentWaitTimeInSec = _waitTimeInSec;
      _percent = 1;
      _timeStr = await calculationTime();
      _timer?.cancel();
      emit(TimerInitial(_timeStr, 1));
    }
  });

  }

  Future<void> restartTimer() async {
    _currentWaitTimeInSec = _waitTimeInSec;
    _percent = 1;
    _timeStr = await calculationTime();
    _timer?.cancel();
  emit(TimerRunState(_timeStr, _percent, _waitTimeInSec));
  startTimer();

  }

  Future<void> pauseTimer() async {
    _timer?.cancel();
  emit(TimerPauseState(_timeStr, _percent));

  }

  Future<String> calculationTime() async {
    var minuteStr = (_currentWaitTimeInSec ~/ 60).toString().padLeft(2, '0');
    var secondStr = (_currentWaitTimeInSec % 60).toString().padLeft(2, '0');
    return ("$minuteStr:$secondStr");
}

}
