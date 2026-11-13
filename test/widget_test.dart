import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unimate/core/database/models/subject_model.dart';
import 'package:unimate/core/database/models/schedule_model.dart';
import 'package:unimate/core/database/models/task_model.dart';
import 'package:unimate/shared/widgets/custom_bottom_nav.dart';

void main() {
  group('UniMate Core Models & Business Logic Tests', () {
    test('Subject model serialization and copyWith', () {
      final subject = Subject(
        id: 's-1',
        name: 'Pemrograman Bergerak',
        code: 'IF3201',
        lecturerName: 'Dr. Hendra',
        credits: 3,
        colorKey: 'pink',
        iconKey: 'code',
      );

      final map = subject.toMap();
      expect(map['id'], 's-1');
      expect(map['name'], 'Pemrograman Bergerak');
      expect(map['credits'], 3);

      final fromMap = Subject.fromMap(map);
      expect(fromMap.id, subject.id);
      expect(fromMap.name, subject.name);

      final updated = subject.copyWith(name: 'Mobile Programming');
      expect(updated.name, 'Mobile Programming');
      expect(updated.id, 's-1');
    });

    test('ClassSchedule time formatting and range calculation', () {
      final schedule = ClassSchedule(
        id: 'cs-1',
        subjectId: 's-1',
        dayOfWeek: 1, // Senin
        startMinute: 8 * 60, // 08:00
        endMinute: 10 * 60 + 30, // 10:30
        room: 'Lab 3',
      );

      expect(schedule.startTimeFormatted, '08:00');
      expect(schedule.endTimeFormatted, '10:30');
      expect(schedule.timeRange, '08:00 - 10:30');
    });

    test('TaskItem status and completion logic', () {
      final task = TaskItem(
        id: 't-1',
        title: 'Tugas UI UniMate',
        priority: 'high',
        status: 'todo',
      );

      expect(task.isDone, false);

      final completedTask = task.copyWith(status: 'done');
      expect(completedTask.isDone, true);
    });
  });

  group('UniMate UI Component Tests', () {
    testWidgets('CustomBottomNavBar displays all 5 tabs and responds to tap', (WidgetTester tester) async {
      int selectedTab = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: selectedTab,
              onTap: (index) {
                selectedTab = index;
              },
            ),
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Schedule'), findsOneWidget);
      expect(find.text('Tasks'), findsOneWidget);
      expect(find.text('Finance'), findsOneWidget);
      expect(find.text('More'), findsOneWidget);

      // Tap on Schedule tab
      await tester.tap(find.text('Schedule'));
      expect(selectedTab, 1);

      // Tap on Tasks tab
      await tester.tap(find.text('Tasks'));
      expect(selectedTab, 2);
    });
  });
}
