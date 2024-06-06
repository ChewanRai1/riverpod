class Task {
  final String id;
  final String title;
  final bool isCompleted;
  final bool isPinned;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.isPinned = false,
  });

  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    bool? isPinned,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}
