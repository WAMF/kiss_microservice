import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_plus/shelf_plus.dart';
import 'package:test/test.dart';
import 'package:todo_microservice/todo_microservice.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('Todo API Integration Tests', () {
    late HttpServer server;
    late String baseUrl;
    late TodoApiConfiguration config;

    setUpAll(() async {
      // Create the app with test configuration
      final app = Router().plus;
      config = TodoApiConfiguration.withInMemoryRepository();

      // Add middleware before routes
      app
        ..use(logRequests())
        ..get('/', (Request request) {
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
  }
}
            ''',
            headers: {'Content-Type': 'application/json'},
          );
        });
      
      config.setupRoutes(app);

      // Start the test server
      server = await shelf_io.serve(app.call, 'localhost', 0);
      baseUrl = 'http://localhost:${server.port}';
    });

    tearDownAll(() async {
      await server.close();
      config.dispose();
    });

    setUp(() async {
      // Clean up todos before each test
      await config.todoService.deleteAllTodos();
    });

    group('Root Endpoint', () {
      test('should return API information', () async {
        final response = await http.get(Uri.parse(baseUrl));

        expect(response.statusCode, equals(200));
        expect(response.headers['content-type'], contains('application/json'));

        final data = jsonDecode(response.body) as Map<String, dynamic>;
        expect(data['name'], equals('Todo Microservice API'));
        expect(data['version'], equals('1.0.0'));
        expect(data['endpoints'], isA<Map>());
      });
    });

    group('Todo CRUD Operations', () {
      test('should create and retrieve todo via API', () async {
        // Create todo
        final createResponse = await http.post(
          Uri.parse('$baseUrl/todos'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(TestData.createTodoJson(
            title: 'API Test Todo',
            description: 'Created via API',
          )),
        );

        expect(createResponse.statusCode, equals(201));
        final created = jsonDecode(createResponse.body) as Map<String, dynamic>;
        expect(created['title'], equals('API Test Todo'));
        expect(created['description'], equals('Created via API'));
        expect(created['id'], isNotEmpty);

        // Retrieve todo
        final getResponse = await http.get(
          Uri.parse('$baseUrl/todos/${created['id']}'),
        );

        expect(getResponse.statusCode, equals(200));
        final retrieved = jsonDecode(getResponse.body) as Map<String, dynamic>;
        expect(retrieved['id'], equals(created['id']));
        expect(retrieved['title'], equals('API Test Todo'));
      });

      test('should update todo via API', () async {
        // Create todo first
        final created = await _createTestTodo(baseUrl, 'Original Title');

        // Update todo
        final updateResponse = await http.patch(
          Uri.parse('$baseUrl/todos/${created['id']}'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'title': 'Updated Title',
            'completed': true,
          }),
        );

        expect(updateResponse.statusCode, equals(200));
        final updated = jsonDecode(updateResponse.body) as Map<String, dynamic>;
        expect(updated['title'], equals('Updated Title'));
        expect(updated['completed'], isTrue);
        expect(updated['completedAt'], isNotNull);
      });

      test('should delete todo via API', () async {
        // Create todo first
        final created = await _createTestTodo(baseUrl, 'To Delete');

        // Delete todo
        final deleteResponse = await http.delete(
          Uri.parse('$baseUrl/todos/${created['id']}'),
        );

        expect(deleteResponse.statusCode, equals(200));
        final result = jsonDecode(deleteResponse.body) as Map<String, dynamic>;
        expect(result['message'], equals('Todo deleted successfully'));

        // Verify it's deleted
        final getResponse = await http.get(
          Uri.parse('$baseUrl/todos/${created['id']}'),
        );
        expect(getResponse.statusCode, equals(404));
      });
    });

    group('Todo Listing and Filtering', () {
      setUp(() async {
        // Create test data
        await _createTestTodo(baseUrl, 'Pending Todo 1');
        final todo2 = await _createTestTodo(baseUrl, 'Todo to Complete');
        await _createTestTodo(baseUrl, 'Pending Todo 2');

        // Mark one as completed
        await http.patch(
          Uri.parse('$baseUrl/todos/${todo2['id']}'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'completed': true}),
        );
      });

      test('should get all todos', () async {
        final response = await http.get(Uri.parse('$baseUrl/todos'));

        expect(response.statusCode, equals(200));
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        expect(data['total'], equals(3));
        expect(data['todos'], isA<List>());
        expect(data['todos'].length, equals(3));
      });

      test('should filter completed todos', () async {
        final response = await http.get(
          Uri.parse('$baseUrl/todos?status=completed'),
        );

        expect(response.statusCode, equals(200));
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        expect(data['total'], equals(1));
        expect(data['todos'][0]['completed'], isTrue);
      });

      test('should filter pending todos', () async {
        final response = await http.get(
          Uri.parse('$baseUrl/todos?status=pending'),
        );

        expect(response.statusCode, equals(200));
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        expect(data['total'], equals(2));
        expect(
            data['todos'].every((todo) => todo['completed'] == false), isTrue);
      });

      test('should search todos by title', () async {
        final response = await http.get(
          Uri.parse('$baseUrl/todos/search/Pending'),
        );

        expect(response.statusCode, equals(200));
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        expect(data['total'], equals(2));
        expect(
            data['todos']
                .every((todo) => (todo['title'] as String).contains('Pending')),
            isTrue);
      });
    });

    group('Advanced Features', () {
      test('should get todo statistics', () async {
        // Create test data
        await _createTestTodo(baseUrl, 'Pending 1');
        await _createTestTodo(baseUrl, 'Pending 2');
        final completed = await _createTestTodo(baseUrl, 'To Complete');

        // Complete one
        await http.patch(
          Uri.parse('$baseUrl/todos/${completed['id']}'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'completed': true}),
        );

        final response = await http.get(Uri.parse('$baseUrl/todos/stats'));

        expect(response.statusCode, equals(200));
        final stats = jsonDecode(response.body) as Map<String, dynamic>;
        expect(stats['total'], equals(3));
        expect(stats['completed'], equals(1));
        expect(stats['pending'], equals(2));
        expect(stats['overdue'], equals(0));
      });

      test('should mark todo as completed via convenience endpoint', () async {
        final created = await _createTestTodo(baseUrl, 'To Mark Complete');

        final response = await http.post(
          Uri.parse('$baseUrl/todos/${created['id']}/complete'),
        );

        expect(response.statusCode, equals(200));
        final updated = jsonDecode(response.body) as Map<String, dynamic>;
        expect(updated['completed'], isTrue);
        expect(updated['completedAt'], isNotNull);
      });

      test('should mark todo as pending via convenience endpoint', () async {
        final created = await _createTestTodo(baseUrl, 'To Mark Pending');

        // First mark as completed
        await http.post(Uri.parse('$baseUrl/todos/${created['id']}/complete'));

        // Then mark as pending
        final response = await http.post(
          Uri.parse('$baseUrl/todos/${created['id']}/pending'),
        );

        expect(response.statusCode, equals(200));
        final updated = jsonDecode(response.body) as Map<String, dynamic>;
        expect(updated['completed'], isFalse);
        expect(updated['completedAt'], isNull);
      });

      test('should delete all todos', () async {
        // Create multiple todos
        await _createTestTodo(baseUrl, 'Todo 1');
        await _createTestTodo(baseUrl, 'Todo 2');
        await _createTestTodo(baseUrl, 'Todo 3');

        final deleteResponse = await http.delete(Uri.parse('$baseUrl/todos'));

        expect(deleteResponse.statusCode, equals(200));
        final result = jsonDecode(deleteResponse.body) as Map<String, dynamic>;
        expect(result['message'], equals('All todos deleted successfully'));

        // Verify all are deleted
        final getAllResponse = await http.get(Uri.parse('$baseUrl/todos'));
        final data = jsonDecode(getAllResponse.body) as Map<String, dynamic>;
        expect(data['total'], equals(0));
      });
    });

    group('Error Handling', () {
      test('should return 404 for non-existent todo', () async {
        final response = await http.get(
          Uri.parse('$baseUrl/todos/non-existent-id'),
        );

        expect(response.statusCode, equals(404));
        final error = jsonDecode(response.body) as Map<String, dynamic>;
        expect(error['error'], equals('Todo not found'));
      });

      test('should return 400 for invalid todo creation', () async {
        final response = await http.post(
          Uri.parse('$baseUrl/todos'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(TestData.createInvalidTodoJson()),
        );

        expect(response.statusCode, equals(400));
        final error = jsonDecode(response.body) as Map<String, dynamic>;
        expect(error['error'], isNotEmpty);
      });

      test('should return 400 for malformed JSON', () async {
        final response = await http.post(
          Uri.parse('$baseUrl/todos'),
          headers: {'Content-Type': 'application/json'},
          body: 'invalid json',
        );

        expect(response.statusCode, equals(400));
      });

      test('should return 404 for updating non-existent todo', () async {
        final response = await http.patch(
          Uri.parse('$baseUrl/todos/non-existent'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'title': 'New Title'}),
        );

        expect(response.statusCode, equals(404));
      });

      test('should return 404 for deleting non-existent todo', () async {
        final response = await http.delete(
          Uri.parse('$baseUrl/todos/non-existent'),
        );

        expect(response.statusCode, equals(404));
      });
    });

    group('API Response Format', () {
      test('should return consistent response format for lists', () async {
        await _createTestTodo(baseUrl, 'Test Todo');

        final response = await http.get(Uri.parse('$baseUrl/todos'));
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        expect(data.keys, containsAll(['todos', 'total']));
        expect(data['todos'], isA<List>());
        expect(data['total'], isA<int>());
      });

      test('should return consistent error format', () async {
        final response = await http.get(
          Uri.parse('$baseUrl/todos/non-existent'),
        );

        expect(response.statusCode, equals(404));
        final error = jsonDecode(response.body) as Map<String, dynamic>;
        expect(error.keys, contains('error'));
        expect(error['error'], isA<String>());
      });

      test('should set correct content-type headers', () async {
        final response = await http.get(Uri.parse('$baseUrl/todos'));

        expect(response.headers['content-type'], contains('application/json'));
      });
    });
  });
}

/// Helper function to create a test todo via API
Future<Map<String, dynamic>> _createTestTodo(
    String baseUrl, String title) async {
  final response = await http.post(
    Uri.parse('$baseUrl/todos'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'title': title,
      'description': 'Test description for $title',
    }),
  );

  expect(response.statusCode, equals(201));
  return jsonDecode(response.body) as Map<String, dynamic>;
}
