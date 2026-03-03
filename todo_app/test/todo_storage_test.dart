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
  });
}
