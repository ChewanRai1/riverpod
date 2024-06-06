import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../models/task.dart';

class TodoController extends StateNotifier<TodoState> {
  TodoController() : super(TodoState());

  void addTask(String title) {
    final task = Task(id: Uuid().v4(), title: title);
    state = state.copyWith(todos: [...state.todos, task]);
  }

  void updateTask(Task updatedTask) {
    state = state.copyWith(todos: [
      for (final task in state.todos)
        if (task.id == updatedTask.id) updatedTask else task,
    ]);
  }

  void updatePinned(Task updatedTask) {
    state = state.copyWith(todos: [
      for (final task in state.todos)
        if (task.id == updatedTask.id)
          task.copyWith(isPinned: !task.isPinned)
        else
          task,
    ]);
  }

  void deleteTask(String id) {
    state = state.copyWith(
        todos: state.todos.where((task) => task.id != id).toList());
  }
}

final todoControllerProvider =
    StateNotifierProvider<TodoController, TodoState>((ref) {
  return TodoController();
});

class TodoState {
  final List<Task> todos;
  final bool isLoading;

  TodoState({this.todos = const [], this.isLoading = false});

  TodoState copyWith({List<Task>? todos, bool? isLoading}) {
    return TodoState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
