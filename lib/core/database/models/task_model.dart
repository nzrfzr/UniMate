class TaskItem {
  final String id;
  final String? subjectId;
  final String? subjectName;
  final String? subjectColor;
  final String title;
  final String? description;
  final DateTime? dueAt;
  final String priority; // 'high', 'medium', 'low'
  final String status; // 'todo', 'in_progress', 'done'
  final DateTime? completedAt;
  final DateTime createdAt;

  TaskItem({
    required this.id,
    this.subjectId,
    this.subjectName,
    this.subjectColor,
    required this.title,
    this.description,
    this.dueAt,
    this.priority = 'medium',
    this.status = 'todo',
    this.completedAt,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isDone => status == 'done';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject_id': subjectId,
      'title': title,
      'description': description,
      'due_at': dueAt?.toIso8601String(),
      'priority': priority,
      'status': status,
      'completed_at': completedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory TaskItem.fromMap(Map<String, dynamic> map, {String? subjectName, String? subjectColor}) {
    return TaskItem(
      id: map['id'] as String,
      subjectId: map['subject_id'] as String?,
      subjectName: subjectName ?? map['subject_name'] as String?,
      subjectColor: subjectColor ?? map['subject_color'] as String?,
      title: map['title'] as String,
      description: map['description'] as String?,
      dueAt: map['due_at'] != null ? DateTime.parse(map['due_at'] as String) : null,
      priority: (map['priority'] as String?) ?? 'medium',
      status: (map['status'] as String?) ?? 'todo',
      completedAt: map['completed_at'] != null
          ? DateTime.parse(map['completed_at'] as String)
          : null,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : DateTime.now(),
    );
  }

  TaskItem copyWith({
    String? id,
    String? subjectId,
    String? subjectName,
    String? subjectColor,
    String? title,
    String? description,
    DateTime? dueAt,
    String? priority,
    String? status,
    DateTime? completedAt,
    DateTime? createdAt,
  }) {
    return TaskItem(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      subjectColor: subjectColor ?? this.subjectColor,
      title: title ?? this.title,
      description: description ?? this.description,
      dueAt: dueAt ?? this.dueAt,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
