import 'package:test/test.dart';
import 'package:shelf_plus/shelf_plus.dart';
import 'package:todo_api_example/dependencies.dart';
import 'package:todo_api_example/routes/todo_routes.dart';
import 'package:todo_api_example/services/todo_service.dart';
import 'dart:convert';
import 'package:kiss_dependencies/kiss_dependencies.dart';

void main() {
  late Router app;
  late TodoService todoService;

  setUpAll(() {
    // Setup dependencies once for all tests
    setupDependencies();
  });

  setUp(() {
    // Get services for each test
    todoService = resolve<TodoService>();
    final todoRoutes = resolve<TodoRoutes>();

    // Create app for each test
    app = Router();
    app.mount('/', todoRoutes.router);
  });

  tearDown(() {
    // Clean up todo data after each test
    todoService.deleteAllTodos();
  });

  group('Todo API Tests', () {
    test('GET /todos returns empty list initially', () async {
      final response = await app.call(
        Request('GET', Uri.parse('http://localhost/todos')),
      );

      expect(response.statusCode, equals(200));
      final body = jsonDecode(await response.readAsString());
      expect(body['todos'], isEmpty);
      expect(body['total'], equals(0));
    });

    test('POST /todos creates a new todo', () async {
      final response = await app.call(
        Request(
          'POST',
          Uri.parse('http://localhost/todos'),
          body: jsonEncode({
            'title': 'Test Todo',
            'description': 'Test Description',
          }),
          headers: {'content-type': 'application/json'},
        ),
      );

      expect(response.statusCode, equals(201));
      final body = jsonDecode(await response.readAsString());
      expect(body['title'], equals('Test Todo'));
      expect(body['description'], equals('Test Description'));
      expect(body['completed'], equals(false));
      expect(body['id'], isNotEmpty);
    });

    test('GET /todos/{id} returns specific todo', () async {
      // Create a todo first
      final todo = todoService.createTodo(
        title: 'Get Test',
        description: 'Testing GET by ID',
      );

      final response = await app.call(
        Request('GET', Uri.parse('http://localhost/todos/${todo.id}')),
      );

      expect(response.statusCode, equals(200));
      final body = jsonDecode(await response.readAsString());
      expect(body['id'], equals(todo.id));
      expect(body['title'], equals('Get Test'));
    });

    test('GET /todos/{id} returns 404 for non-existent todo', () async {
      final response = await app.call(
        Request('GET', Uri.parse('http://localhost/todos/non-existent')),
      );

      expect(response.statusCode, equals(404));
      final body = jsonDecode(await response.readAsString());
      expect(body['error'], equals('Todo not found'));
    });

    test('PUT /todos/{id} updates a todo', () async {
      // Create a todo first
      final todo = todoService.createTodo(
        title: 'Original Title',
        description: 'Original Description',
      );

      final response = await app.call(
        Request(
          'PUT',
          Uri.parse('http://localhost/todos/${todo.id}'),
          body: jsonEncode({
            'title': 'Updated Title',
            'completed': true,
          }),
          headers: {'content-type': 'application/json'},
        ),
      );

      expect(response.statusCode, equals(200));
      final body = jsonDecode(await response.readAsString());
      expect(body['title'], equals('Updated Title'));
      expect(body['completed'], equals(true));
      expect(body['completedAt'], isNotNull);
    });

    test('DELETE /todos/{id} deletes a todo', () async {
      // Create a todo first
      final todo = todoService.createTodo(title: 'To Delete');

      final response = await app.call(
        Request('DELETE', Uri.parse('http://localhost/todos/${todo.id}')),
      );

      expect(response.statusCode, equals(200));
      final body = jsonDecode(await response.readAsString());
      expect(body['message'], equals('Todo deleted successfully'));

      // Verify it's deleted
      expect(todoService.getTodoById(todo.id), isNull);
    });

    test('GET /todos/status/completed returns only completed todos', () async {
      // Create some todos
      todoService.createTodo(title: 'Todo 1');
      final todo2 = todoService.createTodo(title: 'Todo 2');
      todoService.createTodo(title: 'Todo 3');

      // Complete one
      todoService.updateTodo(todo2.id, completed: true);

      final response = await app.call(
        Request('GET', Uri.parse('http://localhost/todos/status/completed')),
      );

      expect(response.statusCode, equals(200));
      final body = jsonDecode(await response.readAsString());
      expect(body['total'], equals(1));
      expect(body['todos'][0]['title'], equals('Todo 2'));
      expect(body['todos'][0]['completed'], equals(true));
    });

    test('GET /todos/status/pending returns only pending todos', () async {
      // Create some todos
      todoService.createTodo(title: 'Todo 1');
      final todo2 = todoService.createTodo(title: 'Todo 2');
      todoService.createTodo(title: 'Todo 3');

      // Complete one
      todoService.updateTodo(todo2.id, completed: true);

      final response = await app.call(
        Request('GET', Uri.parse('http://localhost/todos/status/pending')),
      );

      expect(response.statusCode, equals(200));
      final body = jsonDecode(await response.readAsString());
      expect(body['total'], equals(2));
      expect(body['todos'].every((todo) => todo['completed'] == false), isTrue);
    });

    test('POST /todos with missing title returns 400', () async {
      final response = await app.call(
        Request(
          'POST',
          Uri.parse('http://localhost/todos'),
          body: jsonEncode({
            'description': 'No title provided',
          }),
          headers: {'content-type': 'application/json'},
        ),
      );

      expect(response.statusCode, equals(400));
      final body = jsonDecode(await response.readAsString());
      expect(body['error'], equals('Title is required'));
    });

    test('DELETE /todos deletes all todos', () async {
      // Create some todos
      todoService.createTodo(title: 'Todo 1');
      todoService.createTodo(title: 'Todo 2');
      todoService.createTodo(title: 'Todo 3');

      final response = await app.call(
        Request('DELETE', Uri.parse('http://localhost/todos')),
      );

      expect(response.statusCode, equals(200));
      final body = jsonDecode(await response.readAsString());
      expect(body['message'], equals('All todos deleted successfully'));

      // Verify all are deleted
      expect(todoService.getAllTodos(), isEmpty);
    });
  });
}
