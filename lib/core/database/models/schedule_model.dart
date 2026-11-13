import 'package:flutter/material.dart';

class ClassSchedule {
  final String id;
  final String subjectId;
  final String? subjectName;
  final String? subjectColor;
  final int dayOfWeek; // 1 = Monday, ..., 7 = Sunday
  final int startMinute; // minutes from midnight, e.g. 8 * 60 = 480
  final int endMinute;
  final String? room;
  final String? note;
  final DateTime createdAt;

  ClassSchedule({
    required this.id,
    required this.subjectId,
    this.subjectName,
    this.subjectColor,
    required this.dayOfWeek,
    required this.startMinute,
    required this.endMinute,
    this.room,
    this.note,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  String get startTimeFormatted {
    final hour = startMinute ~/ 60;
    final minute = startMinute % 60;
    final hStr = hour.toString().padLeft(2, '0');
    final mStr = minute.toString().padLeft(2, '0');
    return '$hStr:$mStr';
  }

  String get endTimeFormatted {
    final hour = endMinute ~/ 60;
    final minute = endMinute % 60;
    final hStr = hour.toString().padLeft(2, '0');
    final mStr = minute.toString().padLeft(2, '0');
    return '$hStr:$mStr';
  }

  String get timeRange => '$startTimeFormatted - $endTimeFormatted';

  TimeOfDay get startTime => TimeOfDay(hour: startMinute ~/ 60, minute: startMinute % 60);
  TimeOfDay get endTime => TimeOfDay(hour: endMinute ~/ 60, minute: endMinute % 60);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject_id': subjectId,
      'day_of_week': dayOfWeek,
      'start_minute': startMinute,
      'end_minute': endMinute,
      'room': room,
      'note': note,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ClassSchedule.fromMap(Map<String, dynamic> map, {String? subjectName, String? subjectColor}) {
    return ClassSchedule(
      id: map['id'] as String,
      subjectId: map['subject_id'] as String,
      subjectName: subjectName ?? map['subject_name'] as String?,
      subjectColor: subjectColor ?? map['subject_color'] as String?,
      dayOfWeek: map['day_of_week'] as int,
      startMinute: map['start_minute'] as int,
      endMinute: map['end_minute'] as int,
      room: map['room'] as String?,
      note: map['note'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : DateTime.now(),
    );
  }

  ClassSchedule copyWith({
    String? id,
    String? subjectId,
    String? subjectName,
    String? subjectColor,
    int? dayOfWeek,
    int? startMinute,
    int? endMinute,
    String? room,
    String? note,
    DateTime? createdAt,
  }) {
    return ClassSchedule(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      subjectColor: subjectColor ?? this.subjectColor,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startMinute: startMinute ?? this.startMinute,
      endMinute: endMinute ?? this.endMinute,
      room: room ?? this.room,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
