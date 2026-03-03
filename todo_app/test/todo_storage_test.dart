import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/todo_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TodoStorage Tests', () {
    late TodoStorage storage;

    setUp(() {
      storage = TodoStorage();
      SharedPreferences.setMockInitialValues({});
    });

    test('Should save and load todos correctly', () async {
      final todos = [
        Todo(title: 'Task 1'),
        Todo(title: 'Task 2', isDone: true),
      ];

      await storage.saveTodos(todos);
      final loadedTodos = await storage.loadTodos();

      expect(loadedTodos.length, 2);
      expect(loadedTodos[0].title, 'Task 1');
      expect(loadedTodos[1].isDone, true);
    });

    test('Should return empty list when no data exists', () async {
      final loadedTodos = await storage.loadTodos();
      expect(loadedTodos, isEmpty);
    });

    test('addTodo persists new todo', () async {
      await storage.clearTodos();

      final todo = Todo(title: 'New Task');
      await storage.addTodo(todo);

      final loaded = await storage.loadTodos();
      expect(loaded.length, 1);
      expect(loaded[0].title, 'New Task');
    });

    test('updateTodo saves updated state', () async {
      await storage.clearTodos();

      final todo = Todo(title: 'Toggle Task');
      await storage.addTodo(todo);

      await storage.updateTodo(0, Todo(title: 'Toggle Task', isDone: true));

      final loaded = await storage.loadTodos();
      expect(loaded.length, 1);
      expect(loaded[0].isDone, true);
    });

    test('removeTodoAt removes the correct item', () async {
      await storage.clearTodos();

      await storage.saveTodos([
        Todo(title: 'A'),
        Todo(title: 'B'),
        Todo(title: 'C'),
      ]);

      await storage.removeTodoAt(1);
      final loaded = await storage.loadTodos();
      expect(loaded.length, 2);
      expect(loaded.map((t) => t.title).toList(), ['A', 'C']);
    });

    test('loadTodos returns empty on corrupted stored data', () async {
      SharedPreferences.setMockInitialValues({'todos': 'not a json'});
      final loaded = await storage.loadTodos();
      expect(loaded, isEmpty);
    });

    test('handles duplicate todos correctly', () async {
      await storage.clearTodos();

      final todo = Todo(title: 'Dup');
      await storage.saveTodos([todo, todo, Todo(title: 'Other')]);

      final loaded = await storage.loadTodos();
      expect(loaded.length, 3);
      expect(loaded.where((t) => t.title == 'Dup').length, 2);
    });

    test('handles large lists efficiently', () async {
      await storage.clearTodos();

      final large = List.generate(200, (i) => Todo(title: 'Item $i'));
      await storage.saveTodos(large);

      final loaded = await storage.loadTodos();
      expect(loaded.length, 200);
      expect(loaded[199].title, 'Item 199');
    });
  });
}
