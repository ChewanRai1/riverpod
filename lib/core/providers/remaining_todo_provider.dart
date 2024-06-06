import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/presentations/controller/todo_controller.dart';

final remainingTodoProvider = Provider<int>((ref) {
  final todos = ref.watch(todoControllerProvider).todos;
  return todos.where((task) => !task.isCompleted).length;
});
