import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../database/models/subject_model.dart';
import '../database/models/schedule_model.dart';
import '../database/models/task_model.dart';

// Database provider
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase.instance;
});

// Selected day of week for Schedule screen (1 = Monday ... 7 = Sunday)
final selectedDayProvider = StateProvider<int>((ref) {
  return DateTime.now().weekday;
});

// Subjects StateNotifier
class SubjectsNotifier extends StateNotifier<AsyncValue<List<Subject>>> {
  final AppDatabase _db;

  SubjectsNotifier(this._db) : super(const AsyncValue.loading()) {
    loadSubjects();
  }

  Future<void> loadSubjects() async {
    try {
      final list = await _db.getAllSubjects();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addSubject(Subject subject) async {
    await _db.insertSubject(subject);
    await loadSubjects();
  }

  Future<void> updateSubject(Subject subject) async {
    await _db.updateSubject(subject);
    await loadSubjects();
  }

  Future<void> deleteSubject(String id) async {
    await _db.deleteSubject(id);
    await loadSubjects();
  }
}

final subjectsProvider = StateNotifierProvider<SubjectsNotifier, AsyncValue<List<Subject>>>((ref) {
  final db = ref.watch(databaseProvider);
  return SubjectsNotifier(db);
});

// Schedules StateNotifier
class SchedulesNotifier extends StateNotifier<AsyncValue<List<ClassSchedule>>> {
  final AppDatabase _db;

  SchedulesNotifier(this._db) : super(const AsyncValue.loading()) {
    loadSchedules();
  }

  Future<void> loadSchedules() async {
    try {
      final list = await _db.getAllSchedules();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addSchedule(ClassSchedule schedule) async {
    await _db.insertSchedule(schedule);
    await loadSchedules();
  }

  Future<void> deleteSchedule(String id) async {
    await _db.deleteSchedule(id);
    await loadSchedules();
  }
}

final schedulesProvider = StateNotifierProvider<SchedulesNotifier, AsyncValue<List<ClassSchedule>>>((ref) {
  final db = ref.watch(databaseProvider);
  return SchedulesNotifier(db);
});

// Tasks StateNotifier
class TasksNotifier extends StateNotifier<AsyncValue<List<TaskItem>>> {
  final AppDatabase _db;

  TasksNotifier(this._db) : super(const AsyncValue.loading()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    try {
      final list = await _db.getAllTasks();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addTask(TaskItem task) async {
    await _db.insertTask(task);
    await loadTasks();
  }

  Future<void> updateTask(TaskItem task) async {
    await _db.updateTask(task);
    await loadTasks();
  }

  Future<void> deleteTask(String id) async {
    await _db.deleteTask(id);
    await loadTasks();
  }

  Future<void> toggleTask(String taskId) async {
    await _db.toggleTaskStatus(taskId);
    await loadTasks();
  }
}

final tasksProvider = StateNotifierProvider<TasksNotifier, AsyncValue<List<TaskItem>>>((ref) {
  final db = ref.watch(databaseProvider);
  return TasksNotifier(db);
});
