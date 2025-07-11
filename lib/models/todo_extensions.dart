import 'package:todo_microservice/api/todo-api.openapi.dart';

/// Extensions for Todo model with domain logic and validation
extension TodoExtensions on Todo {
  /// Create a new Todo with validation
  static Todo create({
    required String id,
    required String title,
    String? description,
    bool completed = false,
    required DateTime createdAt,
    DateTime? completedAt,
  }) {
    return Todo(
      id: id,
      title: title,
      description: description,
      completed: completed,
      createdAt: createdAt,
      completedAt: completedAt,
    );
  }

  /// Validate the todo
  void validate() {
    if (id.isEmpty) {
      throw ArgumentError('Todo ID cannot be empty');
    }

    if (title.isEmpty) {
      throw ArgumentError('Todo title cannot be empty');
    }

    if (title.length > 200) {
      throw ArgumentError('Todo title cannot exceed 200 characters');
    }

    if (description != null && description!.length > 1000) {
      throw ArgumentError('Todo description cannot exceed 1000 characters');
    }

    if (completed && completedAt == null) {
      throw ArgumentError('Completed todos must have a completion date');
    }

    if (!completed && completedAt != null) {
      throw ArgumentError('Pending todos cannot have a completion date');
    }
  }

  /// Get validated ID
  String get validId {
    validate();
    return id;
  }

  /// Get validated title
  String get validTitle {
    validate();
    return title;
  }

  /// Check if todo is overdue (for demonstration - could add due date to schema)
  bool get isOverdue {
    if (completed) return false;
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return createdAt.isBefore(weekAgo);
  }

  /// Get display text for the todo
  String get displayText {
    final prefix = completed ? '✅' : '⏳';
    return '$prefix $title${description?.isNotEmpty == true ? ' - $description' : ''}';
  }

  /// Mark as completed
  Todo markCompleted() {
    if (completed) return this;

    return Todo(
      id: id,
      title: title,
      description: description,
      completed: true,
      createdAt: createdAt,
      completedAt: DateTime.now(),
    );
  }

  /// Mark as pending
  Todo markPending() {
    if (!completed) return this;

    return Todo(
      id: id,
      title: title,
      description: description,
      completed: false,
      createdAt: createdAt,
      completedAt: null,
    );
  }
}

/// Extensions for TodoCreate model with validation
extension TodoCreateExtensions on TodoCreate {
  /// Create a new TodoCreate with validation
  static TodoCreate create({
    required String title,
    String? description,
  }) {
    return TodoCreate(
      title: title,
      description: description,
    );
  }

  /// Validate the todo creation request
  void validate() {
    if (title.isEmpty) {
      throw ArgumentError('Todo title cannot be empty');
    }

    if (title.length > 200) {
      throw ArgumentError('Todo title cannot exceed 200 characters');
    }

    if (description != null && description!.length > 1000) {
      throw ArgumentError('Todo description cannot exceed 1000 characters');
    }
  }

  /// Get validated title
  String get validTitle {
    validate();
    return title;
  }

  /// Get validated description
  String? get validDescription {
    validate();
    return description;
  }
}

/// Extensions for TodoUpdate model with validation
extension TodoUpdateExtensions on TodoUpdate {
  /// Create a new TodoUpdate with validation
  static TodoUpdate create({
    String? title,
    String? description,
    bool? completed,
  }) {
    return TodoUpdate(
      title: title,
      description: description,
      completed: completed,
    );
  }

  /// Validate the todo update request
  void validate() {
    if (title != null) {
      if (title!.isEmpty) {
        throw ArgumentError('Todo title cannot be empty');
      }

      if (title!.length > 200) {
        throw ArgumentError('Todo title cannot exceed 200 characters');
      }
    }

    if (description != null && description!.length > 1000) {
      throw ArgumentError('Todo description cannot exceed 1000 characters');
    }
  }

  /// Check if this update has any changes
  bool get hasChanges {
    return title != null || description != null || completed != null;
  }

  /// Apply this update to a todo
  Todo applyTo(Todo todo) {
    validate();

    final newCompleted = completed ?? todo.completed;
    DateTime? newCompletedAt = todo.completedAt;

    if (completed != null && completed != todo.completed) {
      if (completed!) {
        newCompletedAt = DateTime.now();
      } else {
        newCompletedAt = null;
      }
    }

    return Todo(
      id: todo.id,
      title: title ?? todo.title,
      description: description ?? todo.description,
      completed: newCompleted,
      createdAt: todo.createdAt,
      completedAt: newCompletedAt,
    );
  }
}
