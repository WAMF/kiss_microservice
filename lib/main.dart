import 'dart:io';
import 'dart:convert';
import 'package:shelf_plus/shelf_plus.dart';
import 'dependencies.dart';
import 'routes/todo_routes.dart';
import 'package:kiss_dependencies/kiss_dependencies.dart';

void main() async {
  // Setup dependencies
  setupDependencies();

  // Create the server
  final app = Router();

  // Root endpoint
  app.get('/', (Request request) {
    return Response.ok(
      jsonEncode({
        'message': 'Welcome to Todo API',
        'version': '1.0.0',
        'endpoints': {
          'GET /todos': 'Get all todos',
          'POST /todos': 'Create a new todo',
          'GET /todos/:id': 'Get a todo by ID',
          'PUT /todos/:id': 'Update a todo',
          'DELETE /todos/:id': 'Delete a todo',
          'DELETE /todos': 'Delete all todos',
          'GET /todos/status/completed': 'Get completed todos',
          'GET /todos/status/pending': 'Get pending todos',
        }
      }),
      headers: {'Content-Type': 'application/json'},
    );
  });

  // Mount routes
  final todoRoutes = resolve<TodoRoutes>();
  app.mount('/', todoRoutes.router);

  // Start the server
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  await shelfRun(
    () => app,
    defaultBindPort: port,
    defaultBindAddress: '0.0.0.0',
  );
}
