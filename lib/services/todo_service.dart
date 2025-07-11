import 'package:kiss_repository/kiss_repository.dart';
import 'package:todo_microservice/api/todo-api.openapi.dart';
import 'package:todo_microservice/models/todo_extensions.dart';
import 'package:todo_microservice/repositories/todo_queries.dart';
import 'package:uuid/uuid.dart';

/// Service layer for Todo business logic using Repository pattern
class TodoService {
  TodoService(this._repository);

  final Repository<Todo> _repository;
  final Uuid _uuid = const Uuid();

  /// Create a new todo
  Future<Todo> createTodo(TodoCreate todoCreate) async {
    todoCreate.validate();

    final id = _uuid.v4();

    final todo = TodoExtensions.create(
      id: id,
      title: todoCreate.validTitle,
      description: todoCreate.validDescription,
      completed: false,
      createdAt: DateTime.now(),
    );

    todo.validate();
    return _repository.add(IdentifiedObject(todo.validId, todo));
  }

  /// Get a todo by ID
  Future<Todo> getTodo(String id) async {
    return _repository.get(id);
  }

  /// Update a todo
  Future<Todo> updateTodo(String id, TodoUpdate todoUpdate) async {
    if (!todoUpdate.hasChanges) {
      return _repository.get(id);
    }

    return _repository.update(id, (current) {
      return todoUpdate.applyTo(current);
    });
  }

  /// Delete a todo
  Future<void> deleteTodo(String id) async {
    await _repository.get(id);
    await _repository.delete(id);
  }

  /// Delete all todos
  Future<void> deleteAllTodos() async {
    final allTodos = await _repository.query();
    for (final todo in allTodos) {
      await _repository.delete(todo.id);
    }
  }

  /// Get all todos (sorted by creation date, newest first)
  Future<List<Todo>> getAllTodos() async {
    final todos = await _repository.query();
    final sortedTodos = List<Todo>.from(todos);
    sortedTodos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedTodos;
  }

  /// Get completed todos
  Future<List<Todo>> getCompletedTodos() async {
    final todos = await _repository.query(query: const TodoByStatusQuery(true));
    final sortedTodos = List<Todo>.from(todos);
    sortedTodos.sort((a, b) => b.completedAt!.compareTo(a.completedAt!));
    return sortedTodos;
  }

  /// Get pending todos
  Future<List<Todo>> getPendingTodos() async {
    final todos =
        await _repository.query(query: const TodoByStatusQuery(false));
    final sortedTodos = List<Todo>.from(todos);
    sortedTodos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedTodos;
  }

  /// Search todos by title
  Future<List<Todo>> searchTodosByTitle(String title) async {
    if (title.isEmpty) {
      return getAllTodos();
    }

    final todos = await _repository.query(query: TodoByTitleQuery(title));
    final sortedTodos = List<Todo>.from(todos);
    sortedTodos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedTodos;
  }

  /// Get overdue todos (not completed and older than 7 days)
  Future<List<Todo>> getOverdueTodos() async {
    final todos = await _repository.query(query: const TodoOverdueQuery());
    final sortedTodos = List<Todo>.from(todos);
    sortedTodos.sort((a, b) =>
        a.createdAt.compareTo(b.createdAt));
    return sortedTodos;
  }

  /// Get todos created after a specific date
  Future<List<Todo>> getTodosCreatedAfter(DateTime date) async {
    final todos = await _repository.query(query: TodoCreatedAfterQuery(date));
    todos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return todos;
  }

  /// Get todos created before a specific date
  Future<List<Todo>> getTodosCreatedBefore(DateTime date) async {
    final todos = await _repository.query(query: TodoCreatedBeforeQuery(date));
    todos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return todos;
  }

  /// Mark a todo as completed
  Future<Todo> markTodoCompleted(String id) async {
    return _repository.update(id, (current) => current.markCompleted());
  }

  /// Mark a todo as pending
  Future<Todo> markTodoPending(String id) async {
    return _repository.update(id, (current) => current.markPending());
  }

  /// Get todo statistics
  Future<TodoStats> getTodoStats() async {
    final allTodos = await _repository.query();
    final completed = allTodos.where((todo) => todo.completed).length;
    final pending = allTodos.where((todo) => !todo.completed).length;
    final overdue = allTodos.where((todo) {
      if (todo.completed) return false;
      final weekAgo = DateTime.now().subtract(const Duration(days: 7));
      return todo.createdAt.isBefore(weekAgo);
    }).length;

    return TodoStats(
      total: allTodos.length,
      completed: completed,
      pending: pending,
      overdue: overdue,
    );
  }

  /// Dispose of the service
  void dispose() {
    _repository.dispose();
  }
}

/// Statistics for todos
class TodoStats {
  const TodoStats({
    required this.total,
    required this.completed,
    required this.pending,
    required this.overdue,
  });

  final int total;
  final int completed;
  final int pending;
  final int overdue;

  Map<String, dynamic> toJson() => {
        'total': total,
        'completed': completed,
        'pending': pending,
        'overdue': overdue,
      };
}
