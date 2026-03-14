import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:signals/signals_flutter.dart';
import 'package:task_thingy/states/timelineTasks.dart';
import 'package:task_thingy/views/taskComponents.dart';
import 'package:task_thingy/utils/theme.dart';
import 'package:task_thingy/utils/layoutMath.dart';
import 'package:task_thingy/models/taskData.dart';

class Timeline extends StatelessWidget {
  const Timeline({super.key});

  @override
  Widget build(BuildContext context) {
    Size dimensions = MediaQuery.of(context).size;
    double screenHeight = dimensions.height;
    double screenWidth = dimensions.width;
    TimelinePainter timelinePainter = TimelinePainter();
    timelinePainter.context = context;

    List<Task> exampleTasks = [
      TaskModel(
        startDate: DateTime(2026, 3, 5, 9, 0),
        endDate: DateTime(2026, 3, 5, 9, 35),
        title: "Good morning :)",
        description: "Get started with your routine",
        bubbleColor: colors.brightYellow.color,
        iconColor: colors.taskTextColor.color,
        iconData: Icons.sunny,
      ).buildTask(context),

      TaskModel(
        startDate: DateTime(2026, 3, 5, 10, 5),
        endDate: DateTime(2026, 3, 5, 12, 11),
        title: "Go to gym",
        description: "It's full body day",
        bubbleColor: colors.darkRed.color,
        iconColor: Colors.white,
        iconData: Icons.fitness_center_rounded,
      ).buildTask(context),
      TaskModel(
        startDate: DateTime(2026, 3, 5, 13, 0),
        endDate: DateTime(2026, 3, 5, 17, 0),
        title: "Study",
        description: "Its pain time :/",
        bubbleColor: colors.navyBlue.color,
        iconColor: Colors.white,
        iconData: Icons.school_rounded,
      ).buildTask(context),
    ];

    return Watch((context) {
      List<Task> tasks = taskList.value.map((e) {
        return e.buildTask(context);
      }).toList();
      print(
        "Length: ${tasks.length} First task: ${tasks.length > 0 ? tasks[0].startDateString : "null"} ",
      );
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          height: screenHeight * 2,
          width: screenWidth,
          child: Stack(
            children: taskStackFactory(tasks, context, timelinePainter),
          ),
        ),
      );
    });
  }
}

List<Positioned> taskStackFactory(
  List<Task> tasks,
  BuildContext context,
  TimelinePainter timelinePainter,
) {
  List<Positioned> taskStack = [
    Positioned(top: 0, child: CustomPaint(painter: timelinePainter)),
  ];

  if (tasks.isEmpty) {
    return taskStack;
  }

  Task prevTask = tasks[0];

  double prevYposition = prevTask.getYposition(
    prevTask.startDateString,
    context,
  );

  double minimumGap =
      TimeLineLayout.getScreenHeight(context) *
      conversionFactors.taskVerticalSpacing.value;

  taskStack.add(Positioned(top: prevYposition, child: prevTask));

  prevYposition =
      prevYposition +
      TimeLineLayout.durationToHeight(
            prevTask.startDateString,
            prevTask.endDateString,
          ) *
          TimeLineLayout.getScreenHeight(context) *
          conversionFactors.timePixelFactor.value;

  for (var i = 1; i < tasks.length; i++) {
    double yPosition = tasks[i].getYposition(tasks[i].startDateString, context);
    Task currentTask = tasks[i];
    double duration2 = TimeLineLayout.durationToHeight(
      currentTask.startDateString,
      currentTask.endDateString,
    );

    if (yPosition - prevYposition < minimumGap) {
      yPosition = prevYposition + minimumGap;
    }

    print(" Previous bottom: $prevYposition  Placing at: $yPosition ");

    taskStack.add(Positioned(top: yPosition, child: tasks[i]));

    prevYposition =
        yPosition +
        (duration2 *
            conversionFactors.timePixelFactor.value *
            TimeLineLayout.getScreenHeight(context));
  }

  return taskStack;
}

class TimelinePainter extends CustomPainter {
  late final BuildContext context;

  @override
  void paint(Canvas canvas, Size size) {
    double centerX =
        TimeLineLayout.getScreenWidth(context) *
        conversionFactors
            .timeLineHorizontalOffset
            .value; // Keeping your 70 for now to match your UI

    // Start at the top (0) and end at the height provided (size.height)
    Offset p1 = Offset(
      centerX,
      TimeLineLayout.getScreenWidth(context) *
          conversionFactors.timeLineVerticalOffset.value,
    );
    Offset p2 = Offset(centerX, 9900);
    Paint linePaint = Paint();
    linePaint.strokeWidth = componentSizes.timelineStrokeWidth.value;
    linePaint.color = colors.timelineColor.color;
    linePaint.strokeCap = StrokeCap.round;
    canvas.drawLine(p1, p2, linePaint);
  }

  @override
  bool shouldRepaint(TimelinePainter tp) {
    return false;
  }
}
