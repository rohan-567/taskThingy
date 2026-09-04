import 'package:flutter/material.dart';
import 'package:task_thingy/utils/misc.dart';
import 'package:task_thingy/utils/theme.dart';
import 'package:signals/signals_flutter.dart';
import 'package:task_thingy/states/timelineTasks.dart';

class topAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;

  const topAppBar({super.key, required this.context});

  @override
  Size get preferredSize => Size.fromHeight(145);

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.now();
    List<weekDay> days = [];
    DateTime weekStart = date.subtract(Duration(days: date.weekday - 1));

    for (int i = 1; i < 8; i++) {
      days.add(
        weekDay(
          day: (weekStart.day).toString(),
          dayIndex: i,
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
  final int dayIndex;
  final double height;
  final double width;

  const weekDay({
    super.key,
    required this.day,
    required this.dayIndex,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      return GestureDetector(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsetsDirectional.only(bottom: 10),
          decoration: BoxDecoration(
            boxShadow: selectedDay.value == dayIndex
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

            color: selectedDay.value == dayIndex
                ? const Color.fromARGB(197, 45, 94, 180)
                : null,
          ),
          height: height,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                weekDays[dayIndex]!,
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
        ),
        onTap: () => {selectedDay.value = dayIndex},
      );
    });
  }
}
