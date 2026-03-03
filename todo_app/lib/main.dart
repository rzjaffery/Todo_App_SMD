import 'package:flutter/material.dart';
import 'models/todo.dart';
import 'services/todo_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodoPage(),
    );
  }
}

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TodoStorage storage = TodoStorage();
  final TextEditingController controller = TextEditingController();
  List<Todo> todos = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    todos = await storage.loadTodos();
    setState(() {});
  }

  Future<void> addTodo() async {
    if (controller.text.isEmpty) return;

    todos.add(Todo(title: controller.text));
    controller.clear();
    await storage.saveTodos(todos);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ToDo List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'New Todo',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: addTodo,
            child: const Text('Add'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(todos[i].title),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
