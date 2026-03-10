import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:task_thingy/utils/layoutMath.dart';
import 'package:task_thingy/utils/theme.dart';
import 'package:task_thingy/models/taskData.dart';

var taskDraft = signal<TaskModel>(defaultTask);
var selectedColorIndex = signal<int>(0);

TaskModel defaultTask = TaskModel(
  startDate: DateTime.now(),
  endDate: DateTime.now(),
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
    taskDraft.value = defaultTask;
    List<Color> colorChoices = [
      colors.brightYellow.color,
      colors.brightGreen.color,
      colors.cyan.color,
      colors.darkRed.color,
      colors.orange.color,
      colors.navyBlue.color,
    ];

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
            color: const Color.fromARGB(
              209,
              101,
              87,
              98,
            ).withValues(alpha: 0.9),
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
              timePickerButton(isStart: true),
              timePickerButton(isStart: false),
              colorPicker(colorChoices: colorChoices),
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
        print(
          "Title: ${taskDraft.value.title}  Description: ${taskDraft.value.description}",
        );
        print("Start date: ${taskDraft.value.startDate}");
        print("End date: ${taskDraft.value.endDate}");
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

class timePickerButton extends StatelessWidget {
  final bool isStart;

  const timePickerButton({super.key, required this.isStart});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      DateTime minimumDate = taskDraft.value.startDate;

      return GestureDetector(
        onTap: () async {
          CupertinoDatePicker datePicker = CupertinoDatePicker(
            minimumDate: minimumDate,
            use24hFormat: true,
            backgroundColor: Color.fromARGB(
              209,
              101,
              87,
              98,
            ).withValues(alpha: 0.9),
            mode: CupertinoDatePickerMode.dateAndTime,
            initialDateTime: minimumDate,
            onDateTimeChanged: (DateTime newDateTime) => {
              taskDraft.value = isStart
                  ? taskDraft.value.copyWith(
                      startDate: newDateTime,
                      endDate: newDateTime,
                    )
                  : taskDraft.value.copyWith(endDate: newDateTime),
              print(
                "start: ${taskDraft.value.startDate}  end: ${taskDraft.value.endDate}",
              ),
            },
          );

          showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) => Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(209, 101, 87, 98).withValues(alpha: 0.9),
              ),
              width: TimeLineLayout.getScreenWidth(context) * 0.99,
              height: TimeLineLayout.getScreenHeight(context) * 0.4,
              child: datePicker,
            ),
          );

          // 3. THE CRITICAL FIX: Assign back to .value
        },
        child: Container(
          alignment: Alignment.center,
          height:
              TimeLineLayout.getScreenHeight(context) *
              conversionFactors.taskVerticalSpacing.value,
          width: TimeLineLayout.getScreenWidth(context) * 0.7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: const Color.fromARGB(209, 131, 59, 115),
          ),
          child: Text(
            textAlign: TextAlign.center,
            " ${isStart ? zeroPrepend(taskDraft.value.startDate.day) : zeroPrepend(taskDraft.value.endDate.day)}.${isStart ? zeroPrepend(taskDraft.value.startDate.month) : zeroPrepend(taskDraft.value.endDate.month)}.${isStart ? taskDraft.value.startDate.year : taskDraft.value.endDate.year}   ${isStart ? zeroPrepend(taskDraft.value.startDate.hour) : zeroPrepend(taskDraft.value.endDate.hour)}:${isStart ? zeroPrepend(taskDraft.value.startDate.minute) : zeroPrepend(taskDraft.value.endDate.minute)}",
            style: TextStyle(
              color: colors.taskTextColor.color,
              fontSize: textSizes.addTaskTitle.textSize,
            ),
          ),
        ),
      );
    });
  }
}

String zeroPrepend(int number) {
  if (number < 10) {
    return "0$number";
  } else {
    return "$number";
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
    // TODO: implement build
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
        print("Add button pressed");
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
            0.7,

        height:
            TimeLineLayout.getScreenHeight(context) *
            conversionFactors.taskVerticalSpacing.value,
        width: TimeLineLayout.getScreenWidth(context) / 3,
        child: Icon(Icons.send_rounded, color: colors.taskTextColor.color),
      ),
    );
  }
}
