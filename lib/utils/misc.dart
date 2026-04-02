extension dateFormatter on DateTime {
  String toTaskFormat() {
    String hour = this.hour < 10 ? "0${this.hour}" : "${this.hour}";
    String minute = this.minute < 10 ? "0${this.minute}" : "${this.minute}";

    return "$hour:$minute";
  }

  String getWeekDay() {
    return weekDays[weekday] ?? "error";
  }

  String getMonth() {
    return months[month] ?? "error";
  }
}

const weekDays = {
  1: "Mon",
  2: "Tue",
  3: "Wed",
  4: "Thu",
  5: "Fri",
  6: "Sat",
  7: "Sun",
};

const months = {
  1: "January",
  2: "February",
  3: "March",
  4: "April",
  5: "May",
  6: "June",
  7: "July",
  8: "August",
  9: "September",
  10: "October",
  11: "November",
  12: "December",
};
