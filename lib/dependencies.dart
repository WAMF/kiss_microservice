import 'package:kiss_dependencies/kiss_dependencies.dart';
import 'services/todo_service.dart';
import 'routes/todo_routes.dart';

void setupDependencies() {
  // Register services as lazy singletons
  registerLazy<TodoService>(() => TodoService());

  // Register routes with dependency on TodoService
  registerLazy<TodoRoutes>(
    () => TodoRoutes(
      resolve<TodoService>(),
    ),
  );
}
