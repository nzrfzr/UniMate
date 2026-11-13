import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';
import 'models/subject_model.dart';
import 'models/schedule_model.dart';
import 'models/task_model.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('unimate.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: _onConfigure,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE subjects (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        code TEXT,
        lecturer_name TEXT,
        credits INTEGER NOT NULL DEFAULT 3,
        color_key TEXT NOT NULL DEFAULT 'pink',
        icon_key TEXT NOT NULL DEFAULT 'book',
        is_archived INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE class_schedules (
        id TEXT PRIMARY KEY,
        subject_id TEXT NOT NULL,
        day_of_week INTEGER NOT NULL,
        start_minute INTEGER NOT NULL,
        end_minute INTEGER NOT NULL,
        room TEXT,
        note TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (subject_id) REFERENCES subjects (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        subject_id TEXT,
        title TEXT NOT NULL,
        description TEXT,
        due_at TEXT,
        priority TEXT NOT NULL DEFAULT 'medium',
        status TEXT NOT NULL DEFAULT 'todo',
        completed_at TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (subject_id) REFERENCES subjects (id) ON DELETE SET NULL
      )
    ''');

    // Seed default sample data so app is immediately usable and demonstrative
    await _seedInitialData(db);
  }

  Future<void> _seedInitialData(Database db) async {
    const uuid = Uuid();
    final now = DateTime.now();

    // 1. Subjects
    final s1Id = uuid.v4();
    final s2Id = uuid.v4();
    final s3Id = uuid.v4();

    await db.insert('subjects', {
      'id': s1Id,
      'name': 'Pemrograman Bergerak',
      'code': 'IF3201',
      'lecturer_name': 'Dr. Ir. Hendra S.',
      'credits': 3,
      'color_key': 'pink',
      'icon_key': 'code',
      'is_archived': 0,
      'created_at': now.toIso8601String(),
    });

    await db.insert('subjects', {
      'id': s2Id,
      'name': 'Sistem Terdistribusi',
      'code': 'IF3202',
      'lecturer_name': 'Prof. Maya W.',
      'credits': 3,
      'color_key': 'amber',
      'icon_key': 'globe',
      'is_archived': 0,
      'created_at': now.toIso8601String(),
    });

    await db.insert('subjects', {
      'id': s3Id,
      'name': 'Machine Learning',
      'code': 'IF3203',
      'lecturer_name': 'Budi Santoso, M.Kom',
      'credits': 4,
      'color_key': 'violet',
      'icon_key': 'science',
      'is_archived': 0,
      'created_at': now.toIso8601String(),
    });

    // 2. Class Schedules (Monday = 1, today's day of week, etc.)
    final todayWeekday = now.weekday;

    await db.insert('class_schedules', {
      'id': uuid.v4(),
      'subject_id': s1Id,
      'day_of_week': todayWeekday,
      'start_minute': 8 * 60, // 08:00
      'end_minute': 10 * 60 + 30, // 10:30
      'room': 'Lab Komputer 3',
      'note': 'Pertemuan offline bawa laptop',
      'created_at': now.toIso8601String(),
    });

    await db.insert('class_schedules', {
      'id': uuid.v4(),
      'subject_id': s2Id,
      'day_of_week': todayWeekday,
      'start_minute': 13 * 60, // 13:00
      'end_minute': 15 * 60, // 15:00
      'room': 'Ruang Kuliah 402',
      'note': 'Diskusi kelompok arsitektur microservices',
      'created_at': now.toIso8601String(),
    });

    await db.insert('class_schedules', {
      'id': uuid.v4(),
      'subject_id': s3Id,
      'day_of_week': (todayWeekday % 7) + 1,
      'start_minute': 9 * 60, // 09:00
      'end_minute': 11 * 60 + 30, // 11:30
      'room': 'Ruang Teori 201',
      'note': 'Materi Supervised Learning',
      'created_at': now.toIso8601String(),
    });

    // 3. Tasks
    await db.insert('tasks', {
      'id': uuid.v4(),
      'subject_id': s1Id,
      'title': 'Tugas 1: Desain UI Flutter UniMate',
      'description': 'Implementasi bottom navigation, courses carousel, dan schedule timeline.',
      'due_at': DateTime(now.year, now.month, now.day, 23, 59).toIso8601String(),
      'priority': 'high',
      'status': 'in_progress',
      'created_at': now.toIso8601String(),
    });

    await db.insert('tasks', {
      'id': uuid.v4(),
      'subject_id': s2Id,
      'title': 'Resume Paper Konsensus Raft',
      'description': 'Maksimal 3 halaman format IEEE.',
      'due_at': now.add(const Duration(days: 2)).toIso8601String(),
      'priority': 'medium',
      'status': 'todo',
      'created_at': now.toIso8601String(),
    });

    await db.insert('tasks', {
      'id': uuid.v4(),
      'subject_id': s3Id,
      'title': 'Eksperimen Model Regresi Linier',
      'description': 'Jalankan evaluasi akurasi RMSE dan R2 score di notebook.',
      'due_at': now.add(const Duration(days: 4)).toIso8601String(),
      'priority': 'low',
      'status': 'todo',
      'created_at': now.toIso8601String(),
    });
  }

  // ---------------- SUBJECTS CRUD ----------------

  Future<List<Subject>> getAllSubjects() async {
    final db = await database;
    final results = await db.query('subjects', where: 'is_archived = 0', orderBy: 'name ASC');
    return results.map((m) => Subject.fromMap(m)).toList();
  }

  Future<Subject?> getSubjectById(String id) async {
    final db = await database;
    final results = await db.query('subjects', where: 'id = ?', whereArgs: [id]);
    if (results.isEmpty) return null;
    return Subject.fromMap(results.first);
  }

  Future<int> insertSubject(Subject subject) async {
    final db = await database;
    return await db.insert('subjects', subject.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateSubject(Subject subject) async {
    final db = await database;
    return await db.update('subjects', subject.toMap(), where: 'id = ?', whereArgs: [subject.id]);
  }

  Future<int> deleteSubject(String id) async {
    final db = await database;
    return await db.delete('subjects', where: 'id = ?', whereArgs: [id]);
  }

  // ---------------- SCHEDULES CRUD ----------------

  Future<List<ClassSchedule>> getAllSchedules() async {
    final db = await database;
    final results = await db.rawQuery('''
      SELECT cs.*, s.name AS subject_name, s.color_key AS subject_color
      FROM class_schedules cs
      JOIN subjects s ON cs.subject_id = s.id
      ORDER BY cs.day_of_week ASC, cs.start_minute ASC
    ''');
    return results.map((m) => ClassSchedule.fromMap(m)).toList();
  }

  Future<List<ClassSchedule>> getSchedulesForDay(int dayOfWeek) async {
    final db = await database;
    final results = await db.rawQuery('''
      SELECT cs.*, s.name AS subject_name, s.color_key AS subject_color
      FROM class_schedules cs
      JOIN subjects s ON cs.subject_id = s.id
      WHERE cs.day_of_week = ?
      ORDER BY cs.start_minute ASC
    ''', [dayOfWeek]);
    return results.map((m) => ClassSchedule.fromMap(m)).toList();
  }

  Future<int> insertSchedule(ClassSchedule schedule) async {
    final db = await database;
    return await db.insert('class_schedules', schedule.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteSchedule(String id) async {
    final db = await database;
    return await db.delete('class_schedules', where: 'id = ?', whereArgs: [id]);
  }

  // ---------------- TASKS CRUD ----------------

  Future<List<TaskItem>> getAllTasks() async {
    final db = await database;
    final results = await db.rawQuery('''
      SELECT t.*, s.name AS subject_name, s.color_key AS subject_color
      FROM tasks t
      LEFT JOIN subjects s ON t.subject_id = s.id
      ORDER BY 
        CASE t.status WHEN 'todo' THEN 1 WHEN 'in_progress' THEN 2 ELSE 3 END,
        t.due_at ASC
    ''');
    return results.map((m) => TaskItem.fromMap(m)).toList();
  }

  Future<List<TaskItem>> getTasksDueToday() async {
    final db = await database;
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day).toIso8601String();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59).toIso8601String();

    final results = await db.rawQuery('''
      SELECT t.*, s.name AS subject_name, s.color_key AS subject_color
      FROM tasks t
      LEFT JOIN subjects s ON t.subject_id = s.id
      WHERE t.due_at >= ? AND t.due_at <= ?
      ORDER BY t.due_at ASC
    ''', [startOfDay, endOfDay]);
    return results.map((m) => TaskItem.fromMap(m)).toList();
  }

  Future<int> insertTask(TaskItem task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateTask(TaskItem task) async {
    final db = await database;
    return await db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> deleteTask(String id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> toggleTaskStatus(String taskId) async {
    final db = await database;
    final result = await db.query('tasks', where: 'id = ?', whereArgs: [taskId]);
    if (result.isNotEmpty) {
      final currentStatus = result.first['status'] as String;
      final newStatus = currentStatus == 'done' ? 'todo' : 'done';
      final completedAt = newStatus == 'done' ? DateTime.now().toIso8601String() : null;
      await db.update(
        'tasks',
        {'status': newStatus, 'completed_at': completedAt},
        where: 'id = ?',
        whereArgs: [taskId],
      );
    }
  }
}

