import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:task_thingy/models/taskData.dart';
import 'package:task_thingy/states/timelineTasks.dart';
import 'package:task_thingy/utils/layoutMath.dart';
import 'package:task_thingy/utils/theme.dart';
import 'package:task_thingy/views/taskComponents.dart';

class Timeline extends StatelessWidget {
  const Timeline({super.key});

  @override
  Widget build(BuildContext context) {
    Size dimensions = MediaQuery.of(context).size;
    double screenHeight = dimensions.height;
    double screenWidth = dimensions.width;
    TimelinePainter timelinePainter = TimelinePainter();
    timelinePainter.context = context;

    return Watch((context) {
      List<TaskModel> models = [];
      try {
        models = currentTaskList.value;
      } catch (e, stackTrace) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: e,
            stack: stackTrace,
            library: 'timeline',
          ),
        );
      }

      List<Task> tasks = models.map((e) {
        return buildTaskFromModel(e, context);
      }).toList();

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
      TimeLineLayout.durationToMinutes(
            prevTask.startDateString,
            prevTask.endDateString,
          ) *
          TimeLineLayout.getScreenHeight(context) *
          conversionFactors.timePixelFactor.value;
  prevYposition += minimumGap;
  for (var i = 1; i < tasks.length; i++) {
    double yPosition = tasks[i].getYposition(tasks[i].startDateString, context);
    Task currentTask = tasks[i];
    double duration2 = TimeLineLayout.durationToMinutes(
      currentTask.startDateString,
      currentTask.endDateString,
    );

    if (yPosition - prevYposition < minimumGap) {
      yPosition = prevYposition + minimumGap;
    }

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
        conversionFactors.timeLineHorizontalOffset.value;

    Offset p1 = Offset(
      centerX,
      TimeLineLayout.getScreenWidth(context) *
          conversionFactors.timeLineVerticalOffset.value,
    );
    Offset p2 = Offset(centerX, TimeLineLayout.getScreenHeight(context) * 5);
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

Task buildTaskFromModel(TaskModel taskModel, BuildContext context) {
  String startDateString = taskModel.startDate.toString();
  String endDateString = taskModel.endDate.toString();

  double duration = TimeLineLayout.durationToMinutes(
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
    iconColor: taskModel.iconColor,
    bubbleColor: taskModel.bubbleColor,
    bubbleIcon: taskModel.iconData,
  );

  TaskInfo taskInfo = TaskInfo(
    title: taskModel.title,
    description: taskModel.description,
    infoSpacing:
        TimeLineLayout.getScreenHeight(context) *
        conversionFactors.taskInfoVerticalSpacingFactor.value,
  );

  TaskCheckBox taskCheckBox = TaskCheckBox(checked: taskModel.isChecked);

  return Task(
    taskTime: taskTime,
    taskInfo: taskInfo,
    taskBubble: taskBubble,

    startDateString: taskModel.startDate.toString(),
    endDateString: taskModel.endDate.toString(),
    taskCheckBox: taskCheckBox,
  );
}
