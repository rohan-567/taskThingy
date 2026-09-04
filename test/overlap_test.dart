import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:task_thingy/states/timelineTasks.dart';
import 'package:task_thingy/models/taskData.dart';

TaskModel _task(int startHour, int startMin, int endHour, int endMin) {
  return TaskModel(
    startDate: DateTime(2025, 6, 1, startHour, startMin),
    endDate: DateTime(2025, 6, 1, endHour, endMin),
    title: '',
    description: '',
    bubbleColor: const Color(0xFFFFFF00),
    iconColor: const Color(0xFFFFFFFF),
    iconData: IconData(0),
    isChecked: signal<bool>(false),
  );
}

void main() {
  group('checkTaskOverlap', () {
    test('no overlap — A ends before B starts', () {
      final a = _task(9, 0, 10, 0);
      final b = _task(11, 0, 12, 0);
      expect(checkTaskOverlap(a, b), false);
      expect(checkTaskOverlap(b, a), false);
    });

    test('exact adjacency — A ends exactly when B starts', () {
      final a = _task(9, 0, 10, 0);
      final b = _task(10, 0, 11, 0);
      // A.start < B.end (9 < 11) AND A.end > B.start (10 > 10) — second is false
      expect(checkTaskOverlap(a, b), false);
      expect(checkTaskOverlap(b, a), false);
    });

    test('partial overlap — A starts during B', () {
      final a = _task(9, 0, 10, 30);
      final b = _task(10, 0, 11, 0);
      expect(checkTaskOverlap(a, b), true);
      expect(checkTaskOverlap(b, a), true);
    });

    test('full overlap — identical times', () {
      final a = _task(9, 0, 10, 0);
      final b = _task(9, 0, 10, 0);
      expect(checkTaskOverlap(a, b), true);
    });

    test('containment — A entirely inside B', () {
      final a = _task(9, 30, 10, 30);
      final b = _task(9, 0, 11, 0);
      expect(checkTaskOverlap(a, b), true);
      expect(checkTaskOverlap(b, a), true);
    });

    test('one-minute overlap at boundary', () {
      final a = _task(9, 0, 10, 1);
      final b = _task(10, 0, 11, 0);
      expect(checkTaskOverlap(a, b), true);
    });

    test('different days — no overlap even with same times', () {
      final a = TaskModel(
        startDate: DateTime(2025, 6, 1, 9, 0),
        endDate: DateTime(2025, 6, 1, 10, 0),
        title: '',
        description: '',
        bubbleColor: const Color(0xFFFFFF00),
        iconColor: const Color(0xFFFFFFFF),
        iconData: IconData(0),
        isChecked: signal<bool>(false),
      );
      final b = TaskModel(
        startDate: DateTime(2025, 6, 2, 9, 0),
        endDate: DateTime(2025, 6, 2, 10, 0),
        title: '',
        description: '',
        bubbleColor: const Color(0xFFFFFF00),
        iconColor: const Color(0xFFFFFFFF),
        iconData: IconData(0),
        isChecked: signal<bool>(false),
      );
      expect(checkTaskOverlap(a, b), false);
    });
  });
}
