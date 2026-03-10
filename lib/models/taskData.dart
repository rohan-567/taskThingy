import 'package:flutter/material.dart';
import 'package:task_thingy/views/taskComponents.dart';

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

  Task buildTask() {
    return Task(
      taskInfo: TaskInfo(title: title, description: description),
      taskbubble: Taskbubble(
        bubbleColor: bubbleColor,
        iconColor: iconColor,
        bubbleIcon: iconData,
      ),
      startDateString: startDate.toString(),
      endDateString: endDate.toString(),
    );
  }
}
