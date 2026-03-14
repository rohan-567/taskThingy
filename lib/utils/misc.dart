extension dateFormatter on DateTime {
  String toTaskFormat() {
    String hour = this.hour < 10 ? "0${this.hour}" : "${this.hour}";
    String minute = this.minute < 10 ? "0${this.minute}" : "${this.minute}";

    return "$hour:$minute";
  }
}
