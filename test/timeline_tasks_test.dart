import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:task_thingy/states/timelineTasks.dart';
import 'package:task_thingy/models/taskData.dart';

TaskModel _task(
  int startHour,
  int startMin,
  int endHour,
  int endMin, {
  String title = '',
}) {
  return TaskModel(
    startDate: DateTime(2025, 6, 1, startHour, startMin),
    endDate: DateTime(2025, 6, 1, endHour, endMin),
    title: title,
    description: '',
    bubbleColor: const Color(0xFFFFFF00),
    iconColor: const Color(0xFFFFFFFF),
    iconData: IconData(0),
    isChecked: signal<bool>(false),
  );
}

void main() {
  // Because _taskList is a module-level singleton with no clear(),
  // these tests must run sequentially and manually clean up.
  // A future improvement: expose a @visibleForTesting clearTasks().

  group('addTask and removeTask', () {
    test('adds a task and exposes it via currentTaskList', () {
      final task = _task(9, 0, 10, 0);
      addTask(task);
      expect(currentTaskList.value.length, 1);
      expect(currentTaskList.value.first, task);
      // cleanup
      removeTask(task);
      expect(currentTaskList.value.length, 0);
    });

    test('tasks are sorted by startDate after adding', () {
      final early = _task(8, 0, 9, 0, title: 'early');
      final late_ = _task(14, 0, 15, 0, title: 'late');
      final mid = _task(11, 0, 12, 0, title: 'mid');

      // Add out of order
      addTask(late_);
      addTask(early);
      addTask(mid);

      final list = currentTaskList.value;
      expect(list.length, 3);
      expect(list[0].title, 'early');
      expect(list[1].title, 'mid');
      expect(list[2].title, 'late');

      // cleanup
      removeTask(early);
      removeTask(mid);
      removeTask(late_);
    });

    test('throws on overlapping task', () {
      final a = _task(9, 0, 10, 0);
      final b = _task(9, 30, 10, 30);
      addTask(a);
      expect(() => addTask(b), throwsException);
      // cleanup
      removeTask(a);
    });

    test('allows adjacent tasks (no overlap)', () {
      final a = _task(9, 0, 10, 0);
      final b = _task(10, 0, 11, 0);
      addTask(a);
      addTask(b); // should not throw
      expect(currentTaskList.value.length, 2);
      // cleanup
      removeTask(a);
      removeTask(b);
    });

    test('removeTask removes the correct task by reference', () {
      final a = _task(9, 0, 10, 0, title: 'a');
      final b = _task(11, 0, 12, 0, title: 'b');
      addTask(a);
      addTask(b);
      removeTask(a);
      expect(currentTaskList.value.length, 1);
      expect(currentTaskList.value.first.title, 'b');
      // cleanup
      removeTask(b);
    });
  });
}
