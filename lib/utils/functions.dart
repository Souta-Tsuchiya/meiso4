String convertToTimeString(int seconds) {
  Duration duration = Duration(seconds: seconds);
  String twoDigits(int n) {
    return n.toString().padLeft(2, "0");
  }
  String minuteString = twoDigits(duration.inMinutes);
  String secondsString = twoDigits(duration.inSeconds.remainder(60));

  return "$minuteString : $secondsString";
}