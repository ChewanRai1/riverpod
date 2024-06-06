import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/presentations/controller/todo_controller.dart';
import '../models/task.dart';

// Provider to get all todos
final allTodoProvider = Provider<List<Task>>((ref) {
  return ref.watch(todoControllerProvider).todos;
});

// Provider to get active todos
final activeTodoProvider = Provider<List<Task>>((ref) {
  return ref
      .watch(todoControllerProvider)
      .todos
      .where((task) => !task.isCompleted)
      .toList();
});

// Provider to get pinned todos
final pinnedTodoProvider = Provider<List<Task>>((ref) {
  return ref
      .watch(todoControllerProvider)
      .todos
      .where((task) => task.isPinned)
      .toList();
});

// Provider to get completed todos
final completedTodoProvider = Provider<List<Task>>((ref) {
  return ref
      .watch(todoControllerProvider)
      .todos
      .where((task) => task.isCompleted)
      .toList();
});
