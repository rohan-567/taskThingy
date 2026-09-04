import 'package:flutter/material.dart';

import 'package:signals_flutter/signals_flutter.dart';

class TaskModel {
  final DateTime startDate;
  final DateTime endDate;
  final String title;
  final String description;
  final Color bubbleColor;
  final Color iconColor;
  final IconData iconData;
  final Signal<bool> isChecked;

  const TaskModel({
    required this.startDate,
    required this.endDate,
    required this.title,
    required this.description,
    required this.bubbleColor,
    required this.iconColor,
    required this.iconData,
    required this.isChecked,
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
      isChecked: signal(isChecked.value),
    );
  }
}
