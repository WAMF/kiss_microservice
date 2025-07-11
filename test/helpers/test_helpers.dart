import 'package:todo_microservice/api/todo-api.openapi.dart';
import 'package:todo_microservice/models/todo_extensions.dart';

/// Test data factory for creating test objects
class TestData {
  /// Create a test Todo with customizable fields
  static Todo createTestTodo({
    String? id,
    String? title,
    String? description,
    bool? completed,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return TodoExtensions.create(
      id: id ?? 'test-todo-id',
      title: title ?? 'Test Todo',
      description: description ?? 'Test description',
      completed: completed ?? false,
      createdAt: createdAt ?? DateTime.now(),
      completedAt: completedAt,
    );
  }

  /// Create a TodoCreate request object
  static TodoCreate createTodoCreate({
    String? title,
    String? description,
  }) {
    return TodoCreateExtensions.create(
      title: title ?? 'New Todo',
      description: description ?? 'New todo description',
    );
  }

  /// Create a TodoUpdate request object
  static TodoUpdate createTodoUpdate({
    String? title,
    String? description,
    bool? completed,
  }) {
    return TodoUpdateExtensions.create(
      title: title,
      description: description,
      completed: completed,
    );
  }

  /// Create a completed todo
  static Todo createCompletedTodo({
    String? id,
    String? title,
    DateTime? completedAt,
  }) {
    final now = DateTime.now();
    return createTestTodo(
      id: id,
      title: title ?? 'Completed Todo',
      completed: true,
      createdAt: now.subtract(const Duration(hours: 1)),
      completedAt: completedAt ?? now,
    );
  }

  /// Create an overdue todo (older than 7 days and not completed)
  static Todo createOverdueTodo({
    String? id,
    String? title,
  }) {
    return createTestTodo(
      id: id,
      title: title ?? 'Overdue Todo',
      completed: false,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    );
  }

  /// Create multiple test todos
  static List<Todo> createMultipleTodos(int count) {
    return List.generate(
        count,
        (index) => createTestTodo(
              id: 'todo-$index',
              title: 'Todo $index',
              description: 'Description for todo $index',
            ));
  }

  /// Create a mix of completed and pending todos
  static List<Todo> createMixedTodos({
    int totalCount = 5,
    int completedCount = 2,
  }) {
    final todos = <Todo>[];
    final now = DateTime.now();

    // Create completed todos
    for (int i = 0; i < completedCount; i++) {
      todos.add(createTestTodo(
        id: 'completed-$i',
        title: 'Completed Todo $i',
        completed: true,
        createdAt: now.subtract(Duration(hours: i + 1)),
        completedAt: now.subtract(Duration(minutes: i * 10)),
      ));
    }

    // Create pending todos
    for (int i = 0; i < (totalCount - completedCount); i++) {
      todos.add(createTestTodo(
        id: 'pending-$i',
        title: 'Pending Todo $i',
        completed: false,
        createdAt: now.subtract(Duration(minutes: i * 5)),
      ));
    }

    return todos;
  }

  /// Create sample JSON for API testing
  static Map<String, dynamic> createTodoJson({
    String? title,
    String? description,
  }) {
    return {
      'title': title ?? 'Sample Todo',
      'description': description ?? 'Sample description',
    };
  }

  /// Create invalid todo JSON for testing validation
  static Map<String, dynamic> createInvalidTodoJson() {
    return {
      'title': '', // Invalid empty title
      'description': 'Valid description',
    };
  }
}

/// Test helper utilities
class TestHelpers {
  /// Validate that a todo has all required fields
  static void validateTodo(Todo todo) {
    assert(todo.id.isNotEmpty, 'Todo ID should not be empty');
    assert(todo.title.isNotEmpty, 'Todo title should not be empty');

    if (todo.completed) {
      assert(todo.completedAt != null,
          'Completed todo should have completion date');
    } else {
      assert(todo.completedAt == null,
          'Pending todo should not have completion date');
    }
  }

  /// Validate TodoCreate request
  static void validateTodoCreate(TodoCreate todoCreate) {
    assert(todoCreate.title.isNotEmpty, 'TodoCreate title should not be empty');
  }

  /// Check if two todos are functionally equivalent
  static bool todosAreEquivalent(Todo a, Todo b) {
    return a.id == b.id &&
        a.title == b.title &&
        a.description == b.description &&
        a.completed == b.completed &&
        a.createdAt.isAtSameMomentAs(b.createdAt) &&
        ((a.completedAt == null && b.completedAt == null) ||
            (a.completedAt?.isAtSameMomentAs(b.completedAt ?? DateTime(0)) ??
                false));
  }

  /// Sort todos by creation date (newest first)
  static List<Todo> sortTodosByCreatedDate(List<Todo> todos,
      {bool ascending = false}) {
    final sorted = List<Todo>.from(todos);
    sorted.sort((a, b) => ascending
        ? a.createdAt.compareTo(b.createdAt)
        : b.createdAt.compareTo(a.createdAt));
    return sorted;
  }

  /// Filter todos by completion status
  static List<Todo> filterTodosByStatus(List<Todo> todos, bool completed) {
    return todos.where((todo) => todo.completed == completed).toList();
  }

  /// Create a test error message for assertions
  static String createAssertionMessage(
      String operation, String expected, String actual) {
    return '$operation failed: expected $expected, but got $actual';
  }

  /// Wait for async operations in tests
  static Future<void> waitFor(Duration duration) async {
    await Future.delayed(duration);
  }

  /// Generate a unique test ID
  static String generateTestId([String? prefix]) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${prefix ?? 'test'}-$timestamp';
  }
}

/// Test constants
class TestConstants {
  static const String sampleTitle = 'Sample Todo Title';
  static const String sampleDescription = 'Sample todo description for testing';
  static const String longTitle =
      'This is a very long todo title that exceeds normal expectations and might be used to test validation limits';
  static const String longDescription =
      'This is an extremely long description that goes on and on and might be used to test validation rules for description length in the todo application. It contains multiple sentences and provides comprehensive details about what the todo item might entail in a real-world scenario.';

  static const Duration shortDelay = Duration(milliseconds: 10);
  static const Duration mediumDelay = Duration(milliseconds: 100);
  static const Duration longDelay = Duration(milliseconds: 500);

  static const int defaultTodoCount = 5;
  static const int largeTodoCount = 100;
}
