import 'package:kiss_repository/kiss_repository.dart';
import 'package:todo_microservice/api/todo-api.openapi.dart';
import 'package:todo_microservice/repositories/todo_queries.dart';

class TodoInMemoryQueryBuilder extends QueryBuilder<InMemoryFilterQuery<Todo>> {
  @override
  InMemoryFilterQuery<Todo> build(Query query) {
    if (query is TodoByStatusQuery) {
      return InMemoryFilterQuery<Todo>(
        (todo) => todo.completed == query.completed,
      );
    }
    
    if (query is TodoByTitleQuery) {
      return InMemoryFilterQuery<Todo>(
        (todo) => todo.title.toLowerCase().contains(query.title.toLowerCase()),
      );
    }
    
    if (query is TodoOverdueQuery) {
      final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
      return InMemoryFilterQuery<Todo>(
        (todo) => !todo.completed && todo.createdAt.isBefore(sevenDaysAgo),
      );
    }
    
    if (query is TodoCreatedAfterQuery) {
      return InMemoryFilterQuery<Todo>(
        (todo) => todo.createdAt.isAfter(query.date),
      );
    }
    
    if (query is TodoCreatedBeforeQuery) {
      return InMemoryFilterQuery<Todo>(
        (todo) => todo.createdAt.isBefore(query.date),
      );
    }
    
    if (query is TodoSortByCreatedDateQuery) {
      return InMemoryFilterQuery<Todo>(
        (todo) => true,
      );
    }
    
    if (query is TodoSortByTitleQuery) {
      return InMemoryFilterQuery<Todo>(
        (todo) => true,
      );
    }
    
    if (query is TodoSortByCompletionDateQuery) {
      return InMemoryFilterQuery<Todo>(
        (todo) => true,
      );
    }
    
    if (query is CompletedTodosQuery) {
      return InMemoryFilterQuery<Todo>(
        (todo) => todo.completed,
      );
    }
    
    if (query is PendingTodosQuery) {
      return InMemoryFilterQuery<Todo>(
        (todo) => !todo.completed,
      );
    }
    
    return InMemoryFilterQuery<Todo>((todo) => true);
  }
}
