import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

enum TimerType { WORK, BREAK }

class SessionCubitState {
  final int minutes;
  final int seconds;
  final int minutesInSec;
  final int percent;
  final TimerType timerType;
  final bool timerStarted;
  final String task;
  final double temperature;
  final String? sessionId;
  final bool isActive;
  final List<double> history;
  final bool terminateSession;

  SessionCubitState({
    required this.minutes,
    required this.seconds,
    required this.minutesInSec,
    required this.percent,
    required this.timerType,
    required this.timerStarted,
    required this.task,
    required this.temperature,
    required this.sessionId,
    required this.isActive,
    required this.history,
    required this.terminateSession,
  });

  SessionCubitState copyWith({
    int? minutes,
    int? seconds,
    int? minutesInSec,
    int? percent,
    TimerType? timerType,
    bool? timerStarted,
    String? task,
    double? temperature,
    String? sessionId,
    bool? isActive,
    List<double>? history,
    bool? terminateSession,
  }) {
    return SessionCubitState(
      minutes: minutes ?? this.minutes,
      seconds: seconds ?? this.seconds,
      minutesInSec: minutesInSec ?? this.minutesInSec,
      percent: percent ?? this.percent,
      timerType: timerType ?? this.timerType,
      timerStarted: timerStarted ?? this.timerStarted,
      task: task ?? this.task,
      temperature: temperature ?? this.temperature,
      sessionId: sessionId ?? this.sessionId,
      isActive: isActive ?? this.isActive,
      history: history ?? this.history,
      terminateSession: terminateSession ?? this.terminateSession,
    );
  }
}

class SessionCubit extends Cubit<SessionCubitState> {
  SessionCubit()
      : super(SessionCubitState(
          sessionId: '',
          minutes: 1,
          seconds: 0,
          percent: 0,
          minutesInSec: 60,
          timerType: TimerType.WORK,
          timerStarted: false,
          task: '',
          temperature: 36,
          isActive: false,
          history: [],
          terminateSession: false,
        )) {
    _dialogController = StreamController<TimerType>.broadcast();
  }

  late StreamController<TimerType> _dialogController;

  Stream<TimerType> get dialogStream => _dialogController.stream;

  Timer? timer;
  int workTime = 5;
  int breakTime = 2;

  void updateTime(
      {required int minutes,
      required int seconds,
      required double temperature,
      required String sessionId}) {
    emit(state.copyWith(
        minutes: minutes,
        seconds: seconds,
        minutesInSec: minutes * 60 + seconds,
        temperature: temperature,
        sessionId: sessionId));
  }

  void updateTemperature(double temperature) {
    emit(state.copyWith(temperature: temperature));
  }
  void updatedActivity(bool isActive) {
    emit(state.copyWith(isActive: isActive));
  }

  void updatedTerminateSession(bool terminateSession) {
    emit(state.copyWith(terminateSession: terminateSession));
  }

  void updatePercent(int percent) {
    emit(state.copyWith(percent: percent));
  }

  void startTimer() {
    // Emitir el estado inicial con `timerStarted` en `true` y `isActive` en `true`
    emit(state.copyWith(
      timerStarted: true,
      isActive: true,
    ));

    // Configurar el Timer periódico
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.seconds == 0 && state.minutes == 0) {
        // Detener el timer y emitir estado con `isActive` en `false`
        timer.cancel();
        emit(state.copyWith(
          isActive: false,
          terminateSession: true,
          timerStarted: false,
        ));
      } else if (state.seconds == 0) {
        // Cuando los segundos llegan a 0, reducir los minutos y reiniciar los segundos
        emit(state.copyWith(
          minutes: state.minutes - 1,
          seconds: 59,
          percent: state.percent + 1,
        ));
      } else {
        // Reducir segundos y actualizar porcentaje
        emit(state.copyWith(
          seconds: state.seconds - 1,
          percent: state.percent + 1,
        ));
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
    emit(state.copyWith(timerStarted: false));
  }

  void restartTimer() {
    stopTimer();
    emit(state.copyWith(
      minutes: state.timerType == TimerType.WORK ? workTime : breakTime,
      seconds: 0,
      percent: 0,
    ));
  }

  void setTask(String value) {
    emit(state.copyWith(task: value));
  }

  void changeTimerType() {
    if (state.timerType == TimerType.WORK) {
      _dialogController.add(TimerType.WORK);
      emit(state.copyWith(timerType: TimerType.BREAK, minutes: breakTime));
    } else {
      _dialogController.add(TimerType.BREAK);
      emit(state.copyWith(timerType: TimerType.WORK, minutes: workTime));
    }
  }

  @override
  Future<void> close() {
    _dialogController.close();
    return super.close();
  }
}
