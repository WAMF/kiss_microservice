import 'package:kiss_repository/kiss_repository.dart';
import 'package:todo_microservice/api/todo-api.openapi.dart';

/// Query for filtering todos by completion status
class TodoByStatusQuery extends Query {
  const TodoByStatusQuery(this.completed);
  final bool completed;

  @override
  String toString() => 'TodoByStatusQuery(completed: $completed)';
}

/// Query for filtering todos by title (case-insensitive contains)
class TodoByTitleQuery extends Query {
  const TodoByTitleQuery(this.title);
  final String title;

  @override
  String toString() => 'TodoByTitleQuery(title: $title)';
}

/// Query for finding overdue todos (older than 7 days and not completed)
class TodoOverdueQuery extends Query {
  const TodoOverdueQuery();

  @override
  String toString() => 'TodoOverdueQuery()';
}

/// Query for todos created after a specific date
class TodoCreatedAfterQuery extends Query {
  const TodoCreatedAfterQuery(this.date);
  final DateTime date;

  @override
  String toString() => 'TodoCreatedAfterQuery(date: $date)';
}

/// Query for todos created before a specific date
class TodoCreatedBeforeQuery extends Query {
  const TodoCreatedBeforeQuery(this.date);
  final DateTime date;

  @override
  String toString() => 'TodoCreatedBeforeQuery(date: $date)';
}

/// Query for sorting todos by creation date
class TodoSortByCreatedDateQuery extends Query {
  const TodoSortByCreatedDateQuery({this.ascending = false});
  final bool ascending;

  @override
  String toString() => 'TodoSortByCreatedDateQuery(ascending: $ascending)';
}

/// Query for sorting todos by title
class TodoSortByTitleQuery extends Query {
  const TodoSortByTitleQuery({this.ascending = true});
  final bool ascending;

  @override
  String toString() => 'TodoSortByTitleQuery(ascending: $ascending)';
}

/// Query for sorting todos by completion date
class TodoSortByCompletionDateQuery extends Query {
  const TodoSortByCompletionDateQuery({this.ascending = false});
  final bool ascending;

  @override
  String toString() => 'TodoSortByCompletionDateQuery(ascending: $ascending)';
}

/// Combined query for completed todos sorted by completion date
class CompletedTodosQuery extends Query {
  const CompletedTodosQuery();

  @override
  String toString() => 'CompletedTodosQuery()';
}

/// Combined query for pending todos sorted by creation date
class PendingTodosQuery extends Query {
  const PendingTodosQuery();

  @override
  String toString() => 'PendingTodosQuery()';
}

/// Query builder extensions for convenience methods
extension TodoQueryBuilderExtensions on QueryBuilder {
  /// Filter completed todos
  Query get completed => const TodoByStatusQuery(true);

  /// Filter pending todos
  Query get pending => const TodoByStatusQuery(false);

  /// Find overdue todos
  Query get overdue => const TodoOverdueQuery();

  /// Sort by creation date (newest first by default)
  Query sortByCreatedDate({bool ascending = false}) =>
      TodoSortByCreatedDateQuery(ascending: ascending);

  /// Sort by title (alphabetical)
  Query sortByTitle({bool ascending = true}) =>
      TodoSortByTitleQuery(ascending: ascending);

  /// Sort by completion date (most recent first by default)
  Query sortByCompletionDate({bool ascending = false}) =>
      TodoSortByCompletionDateQuery(ascending: ascending);
}

/// Repository extensions for common Todo operations
extension TodoRepositoryExtensions on Repository<Todo> {
  /// Get all completed todos
  Future<List<Todo>> getCompleted() async {
    return query(query: const TodoByStatusQuery(true)).then((todos) =>
        todos..sort((a, b) => b.completedAt!.compareTo(a.completedAt!)));
  }

  /// Get all pending todos
  Future<List<Todo>> getPending() async {
    return query(query: const TodoByStatusQuery(false)).then(
        (todos) => todos..sort((a, b) => b.createdAt.compareTo(a.createdAt)));
  }

  /// Search todos by title
  Future<List<Todo>> searchByTitle(String title) async {
    return query(query: TodoByTitleQuery(title));
  }

  /// Get overdue todos
  Future<List<Todo>> getOverdue() async {
    return query(query: const TodoOverdueQuery());
  }

  /// Get todos created after a date
  Future<List<Todo>> getCreatedAfter(DateTime date) async {
    return query(query: TodoCreatedAfterQuery(date));
  }

  /// Get todos created before a date
  Future<List<Todo>> getCreatedBefore(DateTime date) async {
    return query(query: TodoCreatedBeforeQuery(date));
  }
}
