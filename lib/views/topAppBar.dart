import 'package:flutter/material.dart';
import 'package:task_thingy/utils/misc.dart';
import 'package:task_thingy/utils/theme.dart';
import 'package:signals/signals_flutter.dart';

var selectedDay = signal<int>(DateTime.now().weekday);

class topAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;

  const topAppBar({super.key, required this.context});

  @override
  Size get preferredSize => Size.fromHeight(145);

  @override
  Widget build(BuildContext context) {
    print("selected day: $selectedDay");
    DateTime date = DateTime.now();
    List<weekDay> days = [];
    DateTime weekStart = date.subtract(Duration(days: date.weekday - 1));

    for (int i = 1; i < 8; i++) {
      days.add(
        weekDay(
          day: (weekStart.day).toString(),
          dayWeek: weekDays[i].toString(),
          height: 75,
          width: 45,
        ),
      );
      weekStart = weekStart.add(Duration(days: 1));
    }
    return AppBar(
      backgroundColor: homePageColors.appBar.color,
      title: Text(
        date.getMonth(),
        style: TextStyle(
          color: colors.taskTextColor.color,
          fontWeight: FontWeight.bold,
          fontSize: textSizes.addTaskTitle.textSize,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: preferredSize,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: days,
        ),
      ),
    );
  }
}

class weekDay extends StatelessWidget {
  final String day;
  final String dayWeek;
  final double height;
  final double width;

  const weekDay({
    super.key,
    required this.day,
    required this.dayWeek,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsetsDirectional.only(bottom: 10),
      decoration: BoxDecoration(
        boxShadow:
            selectedDay.value ==
                int.parse(
                  weekDays.keys
                      .firstWhere((k) => weekDays[k] == dayWeek)
                      .toString(),
                )
            ? [
                BoxShadow(
                  color: Color.fromARGB(197, 45, 94, 180),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(0, 0),
                ),
              ]
            : null,
        borderRadius: BorderRadius.circular(40),

        color:
            selectedDay.value ==
                int.parse(
                  weekDays.keys
                      .firstWhere((k) => weekDays[k] == dayWeek)
                      .toString(),
                )
            ? const Color.fromARGB(197, 45, 94, 180)
            : null,
      ),
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dayWeek,
            style: TextStyle(
              color: colors.taskTextColor.color,
              fontSize: textSizes.taskTitle.textSize,
            ),
          ),
          Text(
            day,
            style: TextStyle(
              color: colors.taskTextColor.color,
              fontSize: textSizes.taskTitle.textSize,
            ),
          ),
        ],
      ),
    );
  }
}
