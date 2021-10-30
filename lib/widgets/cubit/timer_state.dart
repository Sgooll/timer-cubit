part of 'timer_cubit.dart';

@immutable
abstract class TimerState {}

class TimerInitial extends TimerState {
  final String waitTime;
  final double percent;

  TimerInitial(this.waitTime, this.percent);
}

class TimerRunState extends TimerState {
  final String currentTime;
  final double percent;
  final int waitTime;

  TimerRunState(this.currentTime, this.percent, this.waitTime);

}

class TimerPauseState extends TimerState{
  final String currentTime;
  final double percent;


  TimerPauseState(this.currentTime, this.percent);

}


