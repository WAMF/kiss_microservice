import 'package:kiss_repository/kiss_repository.dart';
import 'package:shelf_plus/shelf_plus.dart';
import 'package:todo_microservice/api/todo-api.openapi.dart';
import 'package:todo_microservice/api/todo_api_service.dart';
import 'package:todo_microservice/repositories/todo_in_memory_builder.dart';
import 'package:todo_microservice/services/todo_service.dart';

/// Configuration class for the Todo microservice.
///
/// This class provides dependency injection configuration
/// for the service, allowing users to inject their own
/// repository implementations while providing sensible defaults.
class TodoApiConfiguration {
  /// Create a configuration with a custom repository.
  TodoApiConfiguration({required Repository<Todo> repository})
      : _repository = repository {
    _todoService = TodoService(_repository);
    _todoApiService = TodoApiService(_todoService);
  }

  /// Create a configuration with an in-memory repository for testing/demos.
  factory TodoApiConfiguration.withInMemoryRepository({String? path}) {
    final repository = InMemoryRepository<Todo>(
      queryBuilder: TodoInMemoryQueryBuilder(),
      path: path ?? 'todos',
    );
    return TodoApiConfiguration(repository: repository);
  }

  final Repository<Todo> _repository;
  late final TodoService _todoService;
  late final TodoApiService _todoApiService;

  /// Get the configured repository instance.
  Repository<Todo> get repository => _repository;

  /// Get the configured service instance.
  TodoService get todoService => _todoService;

  /// Get the configured API service instance.
  TodoApiService get apiService => _todoApiService;

  /// Set up routes on a Router instance.
  void setupRoutes(RouterPlus app) {
    _todoApiService.setupRoutes(app);
  }

  /// Add a root endpoint with API information
  void setupRootEndpoint(RouterPlus app) {
    app.get('/', (Request request) {
      return Response.ok(
        '''
{
  "name": "Todo Microservice API",
  "version": "1.0.0",
  "description": "A Todo microservice following the KISS architectural pattern",
  "endpoints": {
    "GET /todos": "Get all todos (optional ?status=completed|pending)",
    "POST /todos": "Create a new todo",
    "GET /todos/{id}": "Get a todo by ID",
    "PATCH /todos/{id}": "Update a todo",
    "DELETE /todos/{id}": "Delete a todo",
    "DELETE /todos": "Delete all todos",
    "GET /todos/stats": "Get todo statistics",
    "GET /todos/search/{query}": "Search todos by title",
    "POST /todos/{id}/complete": "Mark todo as completed",
    "POST /todos/{id}/pending": "Mark todo as pending",
    "GET /todos/overdue": "Get overdue todos"
  },
  "examples": {
    "create_todo": {
      "url": "POST /todos",
      "body": {
        "title": "Learn Dart",
        "description": "Complete the Dart language tour"
      }
    },
    "update_todo": {
      "url": "PATCH /todos/{id}",
      "body": {
        "title": "Learn Dart and Flutter",
        "completed": true
      }
    }
  }
}
        ''',
        headers: {'Content-Type': 'application/json'},
      );
    });
  }

  /// Dispose of all resources.
  void dispose() {
    _todoService.dispose();
  }
}
