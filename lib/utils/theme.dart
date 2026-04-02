import 'package:flutter/material.dart';

enum colors {
  brightYellow(Color.fromARGB(238, 207, 191, 42)),
  timelineColor(Color.fromARGB(255, 93, 93, 92)),
  buttonColor(Color.fromARGB(207, 143, 77, 103)),
  taskTextColor(Colors.white70),
  navyBlue(Color.fromARGB(255, 60, 60, 213)),
  darkPurple(Color.fromARGB(255, 116, 43, 193)),
  darkRed(Color.fromARGB(255, 160, 22, 12)),
  cyan(Color.fromARGB(255, 48, 202, 222)),
  orange(Color.fromARGB(255, 232, 141, 4)),
  brightGreen(Color.fromARGB(255, 33, 179, 74));

  final Color color;

  const colors(this.color);

  List<Color> getTaskColors() {
    return [
      brightYellow.color,
      brightGreen.color,
      cyan.color,
      darkRed.color,
      orange.color,
      navyBlue.color,
    ];
  }
}

enum addTaskMenuColors {
  menuBackgroundColor(Color.fromARGB(230, 101, 87, 98)),
  timePickerButton(Color.fromARGB(209, 131, 59, 115));

  final Color color;

  const addTaskMenuColors(this.color);
}

enum homePageColors {
  appBar(Color.fromARGB(255, 21, 21, 21)),
  background(Color.fromARGB(255, 56, 55, 55));

  final Color color;

  const homePageColors(this.color);
}

enum textSizes {
  addTaskTitle(24),
  addTaskDescription(15),
  taskTitle(18),
  taskDescription(13);

  final double textSize;

  const textSizes(this.textSize);
}
