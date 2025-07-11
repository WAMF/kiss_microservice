import 'package:shelf_plus/shelf_plus.dart';
import 'package:todo_microservice/todo_microservice.dart';

/// Example implementation of the Todo microservice
///
/// This demonstrates how to use the Todo microservice library
/// with the default in-memory repository configuration.
void main() => shelfRun(init);

Handler init() {
  final app = Router().plus;

  // Create configuration with in-memory repository
  final config = TodoApiConfiguration.withInMemoryRepository();

  // Setup middleware
  app.use(logRequests());

  // Setup API endpoints
  config.setupRootEndpoint(app);
  config.setupRoutes(app);

  // Optional: Pre-populate with sample data
  _setupSampleData(config.todoService);

  print('Todo Microservice running on http://localhost:8080');
  print('Visit http://localhost:8080 for API documentation');

  return app.call;
}

/// Pre-populate the service with sample todos for demonstration
void _setupSampleData(TodoService todoService) {
  // Add sample todos asynchronously
  Future.microtask(() async {
    try {
      await todoService.createTodo(TodoCreateExtensions.create(
        title: 'Learn Dart',
        description: 'Complete the Dart language tour and build a simple app',
      ));

      await todoService.createTodo(TodoCreateExtensions.create(
        title: 'Explore microservice architecture',
        description: 'Study the KISS microservice pattern and its benefits',
      ));

      final completedTodo =
          await todoService.createTodo(TodoCreateExtensions.create(
        title: 'Set up development environment',
        description: 'Install Dart SDK, VS Code, and necessary extensions',
      ));

      // Mark one as completed
      await todoService.markTodoCompleted(completedTodo.id);

      print('Sample todos created successfully!');
    } catch (e) {
      print('Error creating sample data: $e');
    }
  });
}
