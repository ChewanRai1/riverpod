import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/presentations/controller/todo_controller.dart';
import '../../../models/task.dart';

class CommonTodoProvider extends ConsumerWidget {
  const CommonTodoProvider(this.todoProvider, {Key? key}) : super(key: key);

  final Provider<List<Task>> todoProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoProvider);
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(8),
          ),
          height: 70,
          child: InkWell(
            onTap: () {
              ref
                  .read(todoControllerProvider.notifier)
                  .updateTask(todos[index]);
            },
            child: ListTile(
              leading: Radio(
                value: todos[index].isCompleted,
                groupValue: true,
                onChanged: (value) {},
              ),
              title: Text(todos[index].title),
              trailing: IconButton(
                onPressed: () {
                  ref
                      .read(todoControllerProvider.notifier)
                      .updatePinned(todos[index]);
                },
                icon: Icon(Icons.star,
                    color:
                        todos[index].isPinned ? Colors.yellow : Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}
