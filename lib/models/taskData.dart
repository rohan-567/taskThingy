import 'package:flutter/material.dart';
import 'package:task_thingy/views/taskComponents.dart';
import 'package:task_thingy/utils/layoutMath.dart';

class TaskModel {
  final DateTime startDate;
  final DateTime endDate;
  final String title;
  final String description;
  final Color bubbleColor;
  final Color iconColor;
  final IconData iconData;

  const TaskModel({
    required this.startDate,
    required this.endDate,
    required this.title,
    required this.description,
    required this.bubbleColor,
    required this.iconColor,
    required this.iconData,
  });

  TaskModel copyWith({
    DateTime? startDate,
    DateTime? endDate,
    String? title,
    String? description,
    Color? bubbleColor,
    Color? iconColor,
    IconData? iconData,
  }) {
    return TaskModel(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      title: title ?? this.title,
      description: description ?? this.description,
      bubbleColor: bubbleColor ?? this.bubbleColor,
      iconColor: iconColor ?? this.iconColor,
      iconData: iconData ?? this.iconData,
    );
  }

  Task buildTask(BuildContext context) {
    String startDateString = startDate.toString();
    String endDateString = endDate.toString();

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
      start: TimeLineLayout.extractHourMinute(startDateString),
      end: TimeLineLayout.extractHourMinute(endDateString),
      timeSpacing:
          bubbleHeight -
          (TimeLineLayout.getScreenHeight(context) *
              conversionFactors.taskTimeVerticalSpacing.value),
    );

    Taskbubble taskBubble = Taskbubble(
      bubbleWidth:
          TimeLineLayout.getScreenWidth(context) *
          conversionFactors.bubbleWidthFactor.value,
      bubbleHeight: bubbleHeight,
      iconColor: iconColor,
      bubbleColor: bubbleColor,
      bubbleIcon: iconData,
    );

    TaskInfo taskInfo = TaskInfo(
      title: title,
      description: description,
      infoSpacing:
          TimeLineLayout.getScreenHeight(context) *
          conversionFactors.taskInfoVerticalSpacingFactor.value,
    );

    return Task(
      taskTime: taskTime,
      taskInfo: taskInfo,
      taskBubble: taskBubble,

      startDateString: startDate.toString(),
      endDateString: endDate.toString(),
    );
  }
}
