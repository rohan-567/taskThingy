import 'package:flutter/material.dart';
import 'package:task_thingy/utils/layoutMath.dart';
import 'package:task_thingy/utils/theme.dart';

//Minimum height and widdth for a task bubble needs to be 40 width and 50 height on my screen

const TaskTime defaultTaskTime = TaskTime();
const Taskbubble defaultTaskBubble = Taskbubble();
const TaskInfo defaultTaskInfo = TaskInfo();
const String defaultStartDate = "2012-02-27 09:00:00";
const String defaultEndDate = "2012-02-27 10:00:00";

class Task extends StatelessWidget {
  final TaskTime tasktime;
  final Taskbubble taskbubble;
  final TaskInfo taskInfo;
  final String startDateString;
  final String endDateString;

  const Task({
    super.key,
    this.tasktime = defaultTaskTime,
    this.taskbubble = defaultTaskBubble,
    this.taskInfo = defaultTaskInfo,
    this.startDateString = defaultStartDate,
    this.endDateString = defaultEndDate,
  });

  double getYposition(String dateString, BuildContext context) {
    DateTime date = DateTime.parse(dateString);

    return ((date.hour.toDouble() - 9) * 60 + date.minute.toDouble()) *
        TimeLineLayout.getScreenHeight(context) *
        conversionFactors.timePixelFactor.value;
  }

  @override
  Widget build(BuildContext context) {
    String startDate = TimeLineLayout.extractHourMinute(startDateString);
    String endDate = TimeLineLayout.extractHourMinute(endDateString);

    double duration = TimeLineLayout.durationToHeight(
      startDateString,
      endDateString,
    );

    double bubbleHeight =
        duration.toDouble() *
        conversionFactors.timePixelFactor.value *
        TimeLineLayout.getScreenHeight(context);

    if (bubbleHeight <
        TimeLineLayout.getScreenHeight(context) *
            conversionFactors.taskVerticalSpacing.value) {
      bubbleHeight =
          TimeLineLayout.getScreenHeight(context) *
          conversionFactors.taskVerticalSpacing.value;
    }

    TaskTime taskTime = TaskTime(
      start: startDate,
      end: endDate,
      timeSpacing: bubbleHeight - 40,
    );

    Taskbubble taskBubble = Taskbubble(
      bubbleHeight: bubbleHeight,
      iconColor: taskbubble.iconColor,
      bubbleColor: taskbubble.bubbleColor,
      bubbleIcon: taskbubble.bubbleIcon,
    );

    final double rowSpacing =
        TimeLineLayout.getScreenWidth(context) *
        conversionFactors.taskRowSpacingFactor.value;

    return Row(spacing: rowSpacing, children: [taskTime, taskBubble, taskInfo]);
  }
}

class Taskbubble extends StatelessWidget {
  final Color bubbleColor;
  final IconData bubbleIcon;
  final Color iconColor;
  final double bubbleWidth;
  final double bubbleHeight;

  const Taskbubble({
    super.key,
    this.bubbleColor = const Color.fromARGB(235, 218, 203, 64),
    this.iconColor = const Color.fromARGB(255, 255, 255, 255),
    this.bubbleIcon = Icons.sunny,
    this.bubbleWidth = 40,
    this.bubbleHeight = 50,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(
        start:
            TimeLineLayout.getScreenWidth(context) *
            conversionFactors.bubbleLeftMarginFactor.value,
      ),
      width:
          TimeLineLayout.getScreenWidth(context) *
          conversionFactors.bubbleWidthFactor.value,
      height: bubbleHeight,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: bubbleColor.withValues(alpha: 0.4),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],

        color: bubbleColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Icon(bubbleIcon, color: iconColor),
    );
  }
}

class TaskTime extends StatelessWidget {
  final String start;
  final String end;
  final double timeSpacing;

  const TaskTime({
    super.key,
    this.start = "11:00",
    this.end = "",
    this.timeSpacing = 18,
  });

  @override
  Widget build(BuildContext context) {
    if (end == "") {
      return Column(
        children: [
          Text(start, style: TextStyle(color: colors.taskTextColor.color)),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: timeSpacing,
        children: [
          Text(start, style: TextStyle(color: colors.taskTextColor.color)),
          Text(end, style: TextStyle(color: colors.taskTextColor.color)),
        ],
      );
    }
  }
}

class TaskInfo extends StatelessWidget {
  final String title;
  final String description;
  final double infoSpacing;

  const TaskInfo({
    super.key,
    this.title = "Vacuum the floor",
    this.description = "Lorem ipsum dolor sit amet",
    this.infoSpacing = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing:
          TimeLineLayout.getScreenHeight(context) *
          conversionFactors.taskInfoVerticalSpacingFactor.value,
      children: [
        Text(
          title,
          style: TextStyle(
            color: colors.taskTextColor.color,
            fontSize: textSizes.taskTitle.textSize,
          ),
        ),
        Text(
          description,
          style: TextStyle(
            color: colors.taskTextColor.color,
            fontSize: textSizes.taskDescription.textSize,
          ),
        ),
      ],
    );
  }
}
