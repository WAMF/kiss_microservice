import 'package:uuid/uuid.dart';
import '../models/todo.dart';

class TodoService {
  final Map<String, Todo> _todos = {};
  final _uuid = Uuid();

  List<Todo> getAllTodos() {
    return _todos.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Todo? getTodoById(String id) {
    return _todos[id];
  }

  Todo createTodo({
    required String title,
    String? description,
  }) {
    final todo = Todo(
      id: _uuid.v4(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );
    _todos[todo.id] = todo;
    return todo;
  }

  Todo? updateTodo(String id, {
    String? title,
    String? description,
    bool? completed,
  }) {
    final existingTodo = _todos[id];
    if (existingTodo == null) return null;

    final updatedTodo = existingTodo.copyWith(
      title: title ?? existingTodo.title,
      description: description ?? existingTodo.description,
      completed: completed ?? existingTodo.completed,
      completedAt: completed == true && !existingTodo.completed
          ? DateTime.now()
          : completed == false
              ? null
              : existingTodo.completedAt,
    );

    _todos[id] = updatedTodo;
    return updatedTodo;
  }

  bool deleteTodo(String id) {
    return _todos.remove(id) != null;
  }

  void deleteAllTodos() {
    _todos.clear();
  }

  List<Todo> getCompletedTodos() {
    return _todos.values
        .where((todo) => todo.completed)
        .toList()
      ..sort((a, b) => b.completedAt!.compareTo(a.completedAt!));
  }

  List<Todo> getPendingTodos() {
    return _todos.values
        .where((todo) => !todo.completed)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}