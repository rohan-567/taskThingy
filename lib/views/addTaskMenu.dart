import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:task_thingy/states/timelineTasks.dart';
import 'package:task_thingy/utils/layoutMath.dart';
import 'package:task_thingy/utils/theme.dart';
import 'package:task_thingy/models/taskData.dart';
import 'package:task_thingy/utils/misc.dart';

var taskDraft = signal<TaskModel>(defaultTask);
var selectedColorIndex = signal<int>(0);

TaskModel defaultTask = TaskModel(
  startDate: DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    9,
    0,
  ),
  endDate: DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    9,
    0,
  ),
  title: "",
  description: "",
  bubbleColor: colors.brightYellow.color,
  iconColor: colors.taskTextColor.color,
  iconData: Icons.sunny,
);

class AddTaskMenu extends StatelessWidget {
  const AddTaskMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: Container(
          padding: EdgeInsetsDirectional.only(
            start: 30,
            end: 30,
            top:
                TimeLineLayout.getScreenHeight(context) *
                conversionFactors.taskVerticalSpacing.value *
                0.5,
          ),
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: addTaskMenuColors.menuBackgroundColor.color,
          ),
          width: TimeLineLayout.getScreenWidth(context) * 0.99,
          height: TimeLineLayout.getScreenHeight(context) * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TaskTextInput(
                hint: "Task Title",
                textSize: textSizes.addTaskTitle.textSize,
                maxLines: 1,
              ),
              TaskTextInput(
                hint: "Task Description",
                textSize: textSizes.addTaskDescription.textSize,
                maxLines: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  timePickerButton(isStart: true),
                  timePickerButton(isStart: false),
                ],
              ),
              colorPicker(colorChoices: colors.brightGreen.getTaskColors()),
              addButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskTextInput extends StatelessWidget {
  final double textSize;
  final int maxLines;
  final String hint;

  const TaskTextInput({
    super.key,
    required this.textSize,
    required this.maxLines,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (text) {
        if (textSize == textSizes.addTaskTitle.textSize) {
          taskDraft.value = taskDraft.value.copyWith(title: text);
        } else {
          taskDraft.value = taskDraft.value.copyWith(description: text);
        }
      },

      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.multiline,
      maxLines: maxLines,
      style: TextStyle(
        color: colors.taskTextColor.color,
        fontSize: textSize,
        overflow: TextOverflow.ellipsis,
      ),
      cursorColor: colors.taskTextColor.color,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(5),
        border: InputBorder.none,
        hint: Text(
          hint,
          style: TextStyle(color: Colors.white70, fontSize: textSize),
          softWrap: true,
        ),
      ),
    );
  }
}

CupertinoDatePicker makeTimePicker(bool isStart, DateTime minimumDate) {
  return CupertinoDatePicker(
    minimumDate: minimumDate,
    use24hFormat: true,
    backgroundColor: addTaskMenuColors.menuBackgroundColor.color,
    mode: CupertinoDatePickerMode.time,
    initialDateTime: isStart ? minimumDate : taskDraft.value.endDate,
    onDateTimeChanged: (DateTime newDateTime) => {
      taskDraft.value = taskDraft.value.copyWith(
        startDate: isStart ? newDateTime : taskDraft.value.startDate,
        endDate: isStart
            ? newDateTime.isAfter(taskDraft.value.endDate)
                  ? newDateTime
                  : taskDraft.value.endDate
            : newDateTime,
      ),
    },
  );
}

class timePickerButton extends StatelessWidget {
  final bool isStart;

  const timePickerButton({super.key, required this.isStart});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      DateTime minimumDate = isStart
          ? DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              9,
              0,
            )
          : taskDraft.value.startDate;

      return GestureDetector(
        onTap: () async {
          CupertinoDatePicker datePicker = makeTimePicker(isStart, minimumDate);

          showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) => Container(
              decoration: BoxDecoration(
                color: addTaskMenuColors.menuBackgroundColor.color,
              ),
              width: TimeLineLayout.getScreenWidth(context) * 0.99,
              height: TimeLineLayout.getScreenHeight(context) * 0.4,
              child: datePicker,
            ),
          );
        },
        child: Container(
          alignment: Alignment.center,
          height:
              TimeLineLayout.getScreenHeight(context) *
              conversionFactors.taskVerticalSpacing.value,
          width: TimeLineLayout.getScreenWidth(context) * 0.35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: addTaskMenuColors.timePickerButton.color,
          ),
          child: Text(
            isStart
                ? "Start: ${taskDraft.value.startDate.toTaskFormat()}"
                : "End: ${taskDraft.value.endDate.toTaskFormat()}",
            textAlign: TextAlign.center,

            style: TextStyle(
              color: colors.taskTextColor.color,
              fontSize: textSizes.taskTitle.textSize,
            ),
          ),
        ),
      );
    });
  }
}

class colorBubble extends StatelessWidget {
  final Color color;
  final int index;

  const colorBubble({super.key, required this.color, required this.index});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      bool selected = selectedColorIndex.value == index;
      int alpha = selected ? 255 : 40;

      return GestureDetector(
        onTap: () {
          print("color button pressed, index: $index");
          selectedColorIndex.value = index;
        },
        child: Container(
          height:
              TimeLineLayout.getScreenHeight(context) *
              conversionFactors.taskVerticalSpacing.value *
              0.7,
          width:
              TimeLineLayout.getScreenHeight(context) *
              conversionFactors.taskVerticalSpacing.value *
              0.7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: color.withAlpha(alpha),
          ),
        ),
      );
    });
  }
}

class colorPicker extends StatelessWidget {
  final List<Color> colorChoices;

  const colorPicker({super.key, required this.colorChoices});

  @override
  Widget build(BuildContext context) {
    if (colorChoices.length < 6) {
      throw UnimplementedError();
    } else {
      List<colorBubble> colorOptions = [];

      for (int i = 0; i < 6; i++) {
        colorOptions.add(colorBubble(color: colorChoices[i], index: i));
      }

      return Column(
        spacing: 25,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: colorOptions.sublist(0, 3),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: colorOptions.sublist(3, 6),
          ),
        ],
      );
    }
  }
}

class addButton extends StatelessWidget {
  const addButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        try {
          taskDraft.value = taskDraft.value.copyWith(
            bubbleColor: colors.brightGreen
                .getTaskColors()[selectedColorIndex.value],
          );
          addTask(taskDraft.value);
          Navigator.pop(context);
        } catch (e) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(title: Text(e.toString())),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(
                207,
                82,
                43,
                58,
              ).withValues(alpha: 0.4),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 0),
            ),
          ],
          borderRadius: BorderRadius.circular(20),
          color: colors.buttonColor.color,
        ),
        margin:
            EdgeInsets.only(
              bottom:
                  TimeLineLayout.getScreenHeight(context) *
                  conversionFactors.taskVerticalSpacing.value,
            ) *
            0.6,

        height:
            TimeLineLayout.getScreenHeight(context) *
            conversionFactors.taskVerticalSpacing.value,
        width: TimeLineLayout.getScreenWidth(context) / 3,
        child: Icon(Icons.send_rounded, color: colors.taskTextColor.color),
      ),
    );
  }
}
