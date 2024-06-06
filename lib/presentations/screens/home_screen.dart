import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/filtered_todo_providers.dart';
import 'package:todo_app/presentations/screens/widgets/header.dart';
import '../controller/todo_controller.dart';
import 'widgets/header_widget.dart';
import 'widgets/common_todo.dart';
import '../../core/providers/remaining_todo_provider.dart';

class TodoModel {
  final int id;
  final String title;
  final String description;
  final bool isCompleted;
  final bool isPinned;

  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.isPinned,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'],
      isPinned: json['isPinned'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'isPinned': isPinned,
    };
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late List<TodoModel> tasks;
  late List<TodoModel> filteredTasks;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadTasks();
    _tabController.addListener(_handleTabSelection);
  }

  void _loadTasks() {
    const jsonString = '''
    [
      {"id": 1, "title": "Task 1", "description": "Description of task 1", "isCompleted": false, "isPinned": true},
      {"id": 2, "title": "Task 2", "description": "Description of task 2", "isCompleted": false, "isPinned": false},
      {"id": 3, "title": "Task 3", "description": "Description of task 3", "isCompleted": false, "isPinned": false},
      {"id": 4, "title": "Task 4", "description": "Description of task 4", "isCompleted": false, "isPinned": false},
      {"id": 5, "title": "Task 5", "description": "Description of task 5", "isCompleted": false, "isPinned": false},
      {"id": 6, "title": "Task 6", "description": "Description of task 6", "isCompleted": false, "isPinned": false},
      {"id": 7, "title": "Task 7", "description": "Description of task 7", "isCompleted": false, "isPinned": false},
      {"id": 8, "title": "Task 8", "description": "Description of task 8", "isCompleted": false, "isPinned": false}
    ]
    ''';

    final jsonData = json.decode(jsonString) as List;
    tasks = jsonData.map((taskJson) => TodoModel.fromJson(taskJson)).toList();
    filteredTasks = List.from(tasks);
  }

  void _handleTabSelection() {
    setState(() {
      _filterTasks();
    });
  }

  void _filterTasks() {
    switch (_tabController.index) {
      case 0:
        filteredTasks = List.from(tasks); // All tasks
        break;
      case 1:
        filteredTasks =
            tasks.where((task) => !task.isCompleted).toList(); // Active tasks
        break;
      case 2:
        filteredTasks =
            tasks.where((task) => task.isPinned).toList(); // Favourite tasks
        break;
      case 3:
        filteredTasks =
            tasks.where((task) => task.isCompleted).toList(); // Done tasks
        break;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var todos = ref.watch(todoControllerProvider);

    if (todos.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: SafeArea(
          child: SizedBox.expand(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 40),
                const HeaderWidget(),
                const SizedBox(height: 40),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          TopRow(),
                          Header(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                labelText: 'What do you want to do?',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          // const SizedBox(height: 10),

                          TabBar(
                            controller: _tabController,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.grey[500],
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [Colors.blueAccent, Colors.green],
                              ),
                            ),
                            tabs: const [
                              Tab(
                                icon: Icon(Icons.list),
                                text: 'All',
                              ),
                              Tab(
                                icon: Icon(Icons.check_circle_outline),
                                text: 'Active',
                              ),
                              Tab(
                                icon: Icon(Icons.favorite_border),
                                text: 'Favourite',
                              ),
                              Tab(
                                icon: Icon(Icons.done),
                                text: 'Done',
                              ),
                            ],
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelPadding: EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 2.0),
                          ),
                          Expanded(
                            child: SizedBox(
                              child: ListView.builder(
                                itemCount: filteredTasks.length,
                                itemBuilder: (context, index) {
                                  final task = filteredTasks[index];
                                  return ListTile(
                                    leading: Icon(Icons.work),
                                    title: Text(task.title),
                                    subtitle: Text(task.description),
                                    trailing: Icon(
                                      task.isCompleted
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      color: task.isCompleted
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

class TopRow extends StatelessWidget {
  const TopRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.web),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.web_asset),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
      ],
    );
  }
}
