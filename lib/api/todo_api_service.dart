import 'dart:convert';

import 'package:kiss_repository/kiss_repository.dart';
import 'package:shelf_plus/shelf_plus.dart';
import 'package:todo_microservice/api/todo-api.openapi.dart';
import 'package:todo_microservice/services/todo_service.dart';

/// API service for handling HTTP requests for Todo operations
class TodoApiService {
  TodoApiService(this._todoService);

  final TodoService _todoService;

  /// Setup all routes for the Todo API
  void setupRoutes(RouterPlus app) {
    app
      ..get('/todos', _getAllTodos)
      ..post('/todos', _createTodo)
      ..delete('/todos', _deleteAllTodos)
      ..get('/todos/stats', _getTodoStats)
      ..get('/todos/search/<query>', _searchTodos)
      ..get('/todos/overdue', _getOverdueTodos)
      ..get('/todos/<id>', _getTodo)
      ..patch('/todos/<id>', _updateTodo)
      ..delete('/todos/<id>', _deleteTodo)
      ..post('/todos/<id>/complete', _markTodoCompleted)
      ..post('/todos/<id>/pending', _markTodoPending);
  }

  /// Get all todos with optional status filtering
  Future<Response> _getAllTodos(Request request) async {
    try {
      final status = request.url.queryParameters['status'];

      List<Todo> todos;
      if (status == 'completed') {
        todos = await _todoService.getCompletedTodos();
      } else if (status == 'pending') {
        todos = await _todoService.getPendingTodos();
      } else {
        todos = await _todoService.getAllTodos();
      }

      final response = TodoListResponse(
        todos: todos,
        total: todos.length,
      );

      return Response.ok(
        jsonEncode(response.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } on Exception catch (e) {
      return _errorResponse(500, 'Failed to get todos: ${e.toString()}');
    }
  }

  /// Create a new todo
  Future<Response> _createTodo(Request request) async {
    try {
      final bodyJson = await request.body.asJson;
      final todoCreate = TodoCreate.fromJson(bodyJson as Map<String, dynamic>);

      final todo = await _todoService.createTodo(todoCreate);

      return Response(
        201,
        body: jsonEncode(todo.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } on FormatException catch (e) {
      return _errorResponse(400, 'Invalid JSON: ${e.message}');
    } on ArgumentError catch (e) {
      return _errorResponse(400, e.message);
    } on Exception catch (e) {
      return _errorResponse(500, 'Failed to create todo: ${e.toString()}');
    }
  }

  /// Get a specific todo by ID
  Future<Response> _getTodo(Request request) async {
    try {
      final id = request.params['id']!;
      final todo = await _todoService.getTodo(id);

      return Response.ok(
        jsonEncode(todo.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } on RepositoryException catch (e) {
      if (e.code == RepositoryErrorCode.notFound) {
        return _errorResponse(404, 'Todo not found');
      }
      return _errorResponse(500, 'Repository error: ${e.message}');
    } on Exception catch (e) {
      return _errorResponse(500, 'Failed to get todo: ${e.toString()}');
    }
  }

  /// Update a todo
  Future<Response> _updateTodo(Request request) async {
    try {
      final id = request.params['id']!;
      final bodyJson = await request.body.asJson;
      final todoUpdate = TodoUpdate.fromJson(bodyJson as Map<String, dynamic>);

      final todo = await _todoService.updateTodo(id, todoUpdate);

      return Response.ok(
        jsonEncode(todo.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } on FormatException catch (e) {
      return _errorResponse(400, 'Invalid JSON: ${e.message}');
    } on RepositoryException catch (e) {
      if (e.code == RepositoryErrorCode.notFound) {
        return _errorResponse(404, 'Todo not found');
      }
      return _errorResponse(500, 'Repository error: ${e.message}');
    } on ArgumentError catch (e) {
      return _errorResponse(400, e.message);
    } on Exception catch (e) {
      return _errorResponse(500, 'Failed to update todo: ${e.toString()}');
    }
  }

  /// Delete a todo
  Future<Response> _deleteTodo(Request request) async {
    try {
      final id = request.params['id']!;
      await _todoService.deleteTodo(id);

      final response = MessageResponse(message: 'Todo deleted successfully');
      return Response.ok(
        jsonEncode(response.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } on RepositoryException catch (e) {
      if (e.code == RepositoryErrorCode.notFound) {
        return _errorResponse(404, 'Todo not found');
      }
      return _errorResponse(500, 'Repository error: ${e.message}');
    } on Exception catch (e) {
      return _errorResponse(500, 'Failed to delete todo: ${e.toString()}');
    }
  }

  /// Delete all todos
  Future<Response> _deleteAllTodos(Request request) async {
    try {
      await _todoService.deleteAllTodos();

      final response =
          MessageResponse(message: 'All todos deleted successfully');
      return Response.ok(
        jsonEncode(response.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } on Exception catch (e) {
      return _errorResponse(500, 'Failed to delete todos: ${e.toString()}');
    }
  }

  /// Get todo statistics
  Future<Response> _getTodoStats(Request request) async {
    try {
      final stats = await _todoService.getTodoStats();

      return Response.ok(
        jsonEncode(stats.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } on Exception catch (e) {
      return _errorResponse(500, 'Failed to get stats: ${e.toString()}');
    }
  }

  /// Search todos by title
  Future<Response> _searchTodos(Request request) async {
    try {
      final query = request.params['query']!;
      final todos = await _todoService.searchTodosByTitle(query);

      final response = TodoListResponse(
        todos: todos,
        total: todos.length,
      );

      return Response.ok(
        jsonEncode(response.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } on Exception catch (e) {
      return _errorResponse(500, 'Failed to search todos: ${e.toString()}');
    }
  }

  /// Mark a todo as completed
  Future<Response> _markTodoCompleted(Request request) async {
    try {
      final id = request.params['id']!;
      final todo = await _todoService.markTodoCompleted(id);

      return Response.ok(
        jsonEncode(todo.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } on RepositoryException catch (e) {
      if (e.code == RepositoryErrorCode.notFound) {
        return _errorResponse(404, 'Todo not found');
      }
      return _errorResponse(500, 'Repository error: ${e.message}');
    } on Exception catch (e) {
      return _errorResponse(500, 'Failed to complete todo: ${e.toString()}');
    }
  }

  /// Mark a todo as pending
  Future<Response> _markTodoPending(Request request) async {
    try {
      final id = request.params['id']!;
      final todo = await _todoService.markTodoPending(id);

      return Response.ok(
        jsonEncode(todo.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } on RepositoryException catch (e) {
      if (e.code == RepositoryErrorCode.notFound) {
        return _errorResponse(404, 'Todo not found');
      }
      return _errorResponse(500, 'Repository error: ${e.message}');
    } on Exception catch (e) {
      return _errorResponse(
          500, 'Failed to mark todo as pending: ${e.toString()}');
    }
  }

  /// Get overdue todos
  Future<Response> _getOverdueTodos(Request request) async {
    try {
      final todos = await _todoService.getOverdueTodos();

      final response = TodoListResponse(
        todos: todos,
        total: todos.length,
      );

      return Response.ok(
        jsonEncode(response.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } on Exception catch (e) {
      return _errorResponse(
          500, 'Failed to get overdue todos: ${e.toString()}');
    }
  }

  /// Create an error response
  Response _errorResponse(int statusCode, String message) {
    final errorResponse = ErrorResponse(error: message);
    return Response(
      statusCode,
      body: jsonEncode(errorResponse.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  }
}
