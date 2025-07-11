/// A Todo microservice library with dependency injection support.
///
/// This library provides a complete Todo microservice implementation
/// that can work with any Repository<Todo> implementation from kiss_repository.
///
/// It follows the KISS architectural pattern with clean architecture,
/// OpenAPI-first development, and comprehensive testing.
library;

export 'api/todo-api.openapi.dart';
export 'api/todo_api_configuration.dart';
export 'api/todo_api_service.dart';
export 'models/todo_extensions.dart';
export 'repositories/todo_queries.dart';
export 'services/todo_service.dart';
