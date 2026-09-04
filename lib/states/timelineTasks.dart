import 'package:signals/signals_flutter.dart';
import 'package:task_thingy/models/taskData.dart';

final MapSignal<int, ListSignal<TaskModel>> _tasksInWeek = MapSignal({
  1: listSignal<TaskModel>([]),
  2: listSignal<TaskModel>([]),
  3: listSignal<TaskModel>([]),
  4: listSignal<TaskModel>([]),
  5: listSignal<TaskModel>([]),
  6: listSignal<TaskModel>([]),
  7: listSignal<TaskModel>([]),
});

final Signal selectedDay = signal(DateTime.now().weekday);

ReadonlySignal<List<TaskModel>> get currentTaskList =>
    _tasksInWeek[selectedDay.value]!;

void addTask(TaskModel task) {
  if (_tasksInWeek[selectedDay.value]!.every(
    (e) => checkTaskOverlap(task, e) == false,
  )) {
    final updated = [..._tasksInWeek[selectedDay.value]!.value, task]
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
    _tasksInWeek[selectedDay.value]!.value = updated;
  } else {
    throw Exception("Overlap Error");
  }
  //printWeeksTask(_tasksInWeek);
}

bool checkTaskOverlap(TaskModel newTask, TaskModel oldTask) {
  return newTask.startDate.isBefore(oldTask.endDate) &&
      newTask.endDate.isAfter(oldTask.startDate);
}

void removeTask(TaskModel task) {
  _tasksInWeek[selectedDay.value]!.remove(task);
}

/*
void printWeeksTask(MapSignal<int, ListSignal<TaskModel>> weekTasks) {
  for (var day in weekTasks.keys) {
    print("Day $day : ${printTitles(weekTasks[day]!.value)}");
  }
}
*/
String printTitles(List<TaskModel> tasks) {
  String result = "";
  for (var task in tasks) {
    result += ", ${task.title}";
  }
  return result;
}
