import 'package:signals/signals_flutter.dart';
import 'package:task_thingy/models/taskData.dart';

final ListSignal<TaskModel> _taskList = listSignal<TaskModel>([]);

ReadonlySignal<List<TaskModel>> taskList = _taskList;

void addTask(TaskModel task) {
  if (_taskList.every((e) => checkTaskOverlap(task, e) == false)) {
    _taskList.add(task);
    _taskList.sort((a, b) => a.startDate.compareTo(b.startDate));
  } else {
    throw Exception("Overlap Error");
  }
}

bool checkTaskOverlap(TaskModel newTask, TaskModel oldTask) {
  return newTask.startDate.isBefore(oldTask.endDate) &&
      newTask.endDate.isAfter(oldTask.startDate);
}

void removeTask(TaskModel task) {
  _taskList.value.remove(task);
}
