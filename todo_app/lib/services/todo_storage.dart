import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

class TodoStorage {
  static const String _key = 'todos';

  Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString =
        jsonEncode(todos.map((t) => t.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  Future<List<Todo>> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString == null) return [];

    try {
      final List decoded = jsonDecode(jsonString);
      return decoded.map((e) => Todo.fromJson(e)).toList();
    } catch (_) {
      // If stored data is corrupted or not valid JSON, return empty list
      return [];
    }
  }

  Future<void> addTodo(Todo todo) async {
    final todos = await loadTodos();
    todos.add(todo);
    await saveTodos(todos);
  }

  Future<void> updateTodo(int index, Todo updated) async {
    final todos = await loadTodos();
    if (index < 0 || index >= todos.length) return;
    todos[index] = updated;
    await saveTodos(todos);
  }

  Future<void> removeTodoAt(int index) async {
    final todos = await loadTodos();
    if (index < 0 || index >= todos.length) return;
    todos.removeAt(index);
    await saveTodos(todos);
  }

  Future<void> clearTodos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
