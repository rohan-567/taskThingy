import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signals/signals.dart';
import 'package:task_thingy/models/taskData.dart';

void main() {
  group('TaskModel.copyWith', () {
    final original = TaskModel(
      startDate: DateTime(2025, 6, 1, 9, 0),
      endDate: DateTime(2025, 6, 1, 10, 0),
      title: 'Original',
      description: 'Desc',
      bubbleColor: const Color(0xFFFF0000),
      iconColor: const Color(0xFF00FF00),
      iconData: Icons.home,
      isChecked: signal<bool>(false),
    );

    test('copies with new title, keeps other fields', () {
      final copy = original.copyWith(title: 'New Title');
      expect(copy.title, 'New Title');
      expect(copy.description, 'Desc');
      expect(copy.startDate, original.startDate);
      expect(copy.endDate, original.endDate);
      expect(copy.bubbleColor, original.bubbleColor);
      expect(copy.iconColor, original.iconColor);
      expect(copy.iconData, original.iconData);
    });

    test('copies with new dates', () {
      final newStart = DateTime(2025, 7, 1, 12, 0);
      final newEnd = DateTime(2025, 7, 1, 13, 0);
      final copy = original.copyWith(startDate: newStart, endDate: newEnd);
      expect(copy.startDate, newStart);
      expect(copy.endDate, newEnd);
      expect(copy.title, 'Original');
    });

    test('copies with new colors', () {
      const newBubble = Color(0xFF0000FF);
      const newIcon = Color(0xFFFFFFFF);
      final copy = original.copyWith(
        bubbleColor: newBubble,
        iconColor: newIcon,
      );
      expect(copy.bubbleColor, newBubble);
      expect(copy.iconColor, newIcon);
    });

    test('copies with new iconData', () {
      final copy = original.copyWith(iconData: Icons.star);
      expect(copy.iconData, Icons.star);
    });

    test('isChecked always shares the same Signal instance (BUG)', () {
      final copy = original.copyWith(title: 'Copy');
      expect(identical(copy.isChecked, original.isChecked), false);
      // Mutating one affects the other
      original.isChecked.value = true;
      expect(copy.isChecked.value, false);
      // reset
      original.isChecked.value = false;
    });

    test('no-arg copyWith returns equivalent model', () {
      final copy = original.copyWith();
      expect(copy.title, original.title);
      expect(copy.description, original.description);
      expect(copy.startDate, original.startDate);
      expect(copy.endDate, original.endDate);
      expect(copy.bubbleColor, original.bubbleColor);
      expect(copy.iconColor, original.iconColor);
      expect(copy.iconData, original.iconData);
    });
  });
}
