import 'dart:async';

class CountdownTimer {
  static void startTimer(
      {required int time, required Function(int) onTimeChanged}) {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(
      oneSec,
      (Timer timer) {
        if (time == 0) {
          timer.cancel();
        } else {
          time--;
        }
        onTimeChanged(time);
      },
    );
  }
}
