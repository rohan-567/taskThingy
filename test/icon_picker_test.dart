import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_thingy/scripts/iconPicker.dart';

void main() {
  group('Iconpicker.pickIcon', () {
    test('exact match returns mapped icon', () {
      expect(Iconpicker.pickIcon('Gym', ''), Icons.fitness_center_rounded);
    });

    test('close match returns mapped icon', () {
      // "gym workout" should fuzzy-match "Gym"
      final icon = Iconpicker.pickIcon('Gym workout', '');
      // Should get some icon from the map, not the fallback
      expect(Iconpicker.iconMap.values.contains(icon), true);
    });

    test('completely unrelated title returns fallback checkbox icon', () {
      expect(
        Iconpicker.pickIcon('xyzzy qqq', ''),
        Icons.check_box_rounded,
      );
    });

    test('empty title returns fallback', () {
      expect(Iconpicker.pickIcon('', ''), Icons.check_box_rounded);
    });

    test('known keywords resolve to expected icons', () {
      expect(Iconpicker.pickIcon('Coffee', ''), Icons.local_cafe);
      expect(Iconpicker.pickIcon('Books', ''), Icons.book);
      expect(Iconpicker.pickIcon('Music', ''), Icons.music_note);
      expect(Iconpicker.pickIcon('Pet', ''), Icons.pets);
    });
  });
}
