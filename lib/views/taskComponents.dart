import 'package:flutter/material.dart';
import 'package:task_thingy/utils/layoutMath.dart';
import 'package:task_thingy/utils/theme.dart';

//Minimum height and widdth for a task bubble needs to be 40 width and 50 height on my screen

class Task extends StatelessWidget {
  final TaskTime taskTime;
  final Taskbubble taskBubble;
  final TaskInfo taskInfo;
  final String startDateString;
  final String endDateString;

  const Task({
    super.key,
    required this.taskTime,
    required this.taskBubble,
    required this.taskInfo,
    required this.startDateString,
    required this.endDateString,
  });

  double getYposition(String dateString, BuildContext context) {
    DateTime date = DateTime.parse(dateString);

    double yPosition =
        ((date.hour.toDouble() - 9) * 60 + date.minute.toDouble()) *
        TimeLineLayout.getScreenHeight(context) *
        conversionFactors.timePixelFactor.value;

    return yPosition > 0 ? yPosition : 0;
  }

  @override
  Widget build(BuildContext context) {
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
    required this.bubbleColor,
    required this.iconColor,
    required this.bubbleIcon,
    required this.bubbleWidth,
    required this.bubbleHeight,
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
    required this.start,
    required this.end,
    required this.timeSpacing,
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
    required this.title,
    required this.description,
    required this.infoSpacing,
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
