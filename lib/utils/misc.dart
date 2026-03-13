extension dateFormatter on DateTime {
  String toTaskFormat() {
    String day = this.day < 10 ? "0${this.day}" : "${this.day}";
    String month = this.month < 10 ? "0${this.month}" : "${this.month}";
    String year = "${this.year}";
    String hour = this.hour < 10 ? "0${this.hour}" : "${this.hour}";
    String minute = this.minute < 10 ? "0${this.minute}" : "${this.minute}";

    return "$day.$month.$year $hour:$minute";
  }
}
