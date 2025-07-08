import 'package:shelf_plus/shelf_plus.dart';
import 'dart:convert';
import '../services/todo_service.dart';

class TodoRoutes {
  final TodoService _todoService;

  TodoRoutes(this._todoService);

  Handler get router {
    return Router()
      ..get('/todos', _getAllTodos)
      ..post('/todos', _createTodo)
      ..get('/todos/<id>', _getTodoById)
      ..put('/todos/<id>', _updateTodo)
      ..delete('/todos/<id>', _deleteTodo)
      ..delete('/todos', _deleteAllTodos)
      ..get('/todos/status/completed', _getCompletedTodos)
      ..get('/todos/status/pending', _getPendingTodos);
  }

  Future<Response> _getAllTodos(Request request) async {
    final todos = _todoService.getAllTodos();
    return Response.ok(
      jsonEncode({
        'todos': todos.map((t) => t.toJson()).toList(),
        'total': todos.length,
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<Response> _createTodo(Request request) async {
    try {
      final body = await request.body.asJson;
      
      if (body['title'] == null || body['title'].toString().isEmpty) {
        return Response(
          400,
          body: jsonEncode({'error': 'Title is required'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final todo = _todoService.createTodo(
        title: body['title'],
        description: body['description'],
      );

      return Response(
        201,
        body: jsonEncode(todo.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response(
        400,
        body: jsonEncode({'error': 'Invalid request body'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<Response> _getTodoById(Request request) async {
    final id = (request.context['shelf_router/params'] as Map<String, String>)['id']!;
    final todo = _todoService.getTodoById(id);

    if (todo == null) {
      return Response(
        404,
        body: jsonEncode({'error': 'Todo not found'}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    return Response.ok(
      jsonEncode(todo.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<Response> _updateTodo(Request request) async {
    try {
      final id = (request.context['shelf_router/params'] as Map<String, String>)['id']!;
      final body = await request.body.asJson;

      final todo = _todoService.updateTodo(
        id,
        title: body['title'],
        description: body['description'],
        completed: body['completed'],
      );

      if (todo == null) {
        return Response(
          404,
          body: jsonEncode({'error': 'Todo not found'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      return Response.ok(
        jsonEncode(todo.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response(
        400,
        body: jsonEncode({'error': 'Invalid request body'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<Response> _deleteTodo(Request request) async {
    final id = (request.context['shelf_router/params'] as Map<String, String>)['id']!;
    final deleted = _todoService.deleteTodo(id);

    if (!deleted) {
      return Response(
        404,
        body: jsonEncode({'error': 'Todo not found'}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    return Response.ok(
      jsonEncode({'message': 'Todo deleted successfully'}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<Response> _deleteAllTodos(Request request) async {
    _todoService.deleteAllTodos();
    return Response.ok(
      jsonEncode({'message': 'All todos deleted successfully'}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<Response> _getCompletedTodos(Request request) async {
    final todos = _todoService.getCompletedTodos();
    return Response.ok(
      jsonEncode({
        'todos': todos.map((t) => t.toJson()).toList(),
        'total': todos.length,
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<Response> _getPendingTodos(Request request) async {
    final todos = _todoService.getPendingTodos();
    return Response.ok(
      jsonEncode({
        'todos': todos.map((t) => t.toJson()).toList(),
        'total': todos.length,
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }
}