class Subject {
  final String id;
  final String name;
  final String? code;
  final String? lecturerName;
  final int credits;
  final String colorKey; // e.g. 'pink', 'amber', 'violet', 'blue'
  final String iconKey; // e.g. 'book', 'code', 'science', 'math', 'globe'
  final bool isArchived;
  final DateTime createdAt;

  Subject({
    required this.id,
    required this.name,
    this.code,
    this.lecturerName,
    this.credits = 3,
    this.colorKey = 'pink',
    this.iconKey = 'book',
    this.isArchived = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'lecturer_name': lecturerName,
      'credits': credits,
      'color_key': colorKey,
      'icon_key': iconKey,
      'is_archived': isArchived ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'] as String,
      name: map['name'] as String,
      code: map['code'] as String?,
      lecturerName: map['lecturer_name'] as String?,
      credits: (map['credits'] as int?) ?? 3,
      colorKey: (map['color_key'] as String?) ?? 'pink',
      iconKey: (map['icon_key'] as String?) ?? 'book',
      isArchived: (map['is_archived'] as int?) == 1,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : DateTime.now(),
    );
  }

  Subject copyWith({
    String? id,
    String? name,
    String? code,
    String? lecturerName,
    int? credits,
    String? colorKey,
    String? iconKey,
    bool? isArchived,
    DateTime? createdAt,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      lecturerName: lecturerName ?? this.lecturerName,
      credits: credits ?? this.credits,
      colorKey: colorKey ?? this.colorKey,
      iconKey: iconKey ?? this.iconKey,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
