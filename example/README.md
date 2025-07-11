# Todo Microservice Example

This example demonstrates how to use the Todo microservice library following the KISS architectural pattern.

## Features

- **Clean Architecture**: Separation of concerns across API, Service, Repository, and Model layers
- **OpenAPI-First**: Generated models from OpenAPI specification
- **Repository Pattern**: Flexible data access with `kiss_repository`
- **Comprehensive API**: Full CRUD operations plus advanced features
- **Type Safety**: Full Dart type safety with validation

## Running the Example

1. **Install dependencies:**
   ```bash
   dart pub get
   ```

2. **Run the server:**
   ```bash
   dart run example/main.dart
   ```

3. **Visit the API:**
   - Open http://localhost:8080 for API documentation
   - The server includes sample todos for demonstration

## API Endpoints

### Core CRUD Operations
- `GET /todos` - Get all todos (supports `?status=completed|pending`)
- `POST /todos` - Create a new todo
- `GET /todos/{id}` - Get a specific todo
- `PATCH /todos/{id}` - Update a todo
- `DELETE /todos/{id}` - Delete a todo
- `DELETE /todos` - Delete all todos

### Advanced Features
- `GET /todos/stats` - Get todo statistics
- `GET /todos/search/{query}` - Search todos by title
- `POST /todos/{id}/complete` - Mark todo as completed
- `POST /todos/{id}/pending` - Mark todo as pending
- `GET /todos/overdue` - Get overdue todos

## Usage Examples

### Create a Todo
```bash
curl -X POST http://localhost:8080/todos \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Learn Flutter",
    "description": "Build a mobile app with Flutter framework"
  }'
```

### Update a Todo
```bash
curl -X PATCH http://localhost:8080/todos/{id} \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Learn Flutter and Dart",
    "completed": true
  }'
```

### Get Statistics
```bash
curl http://localhost:8080/todos/stats
```

### Search Todos
```bash
curl http://localhost:8080/todos/search/Flutter
```

## Architecture Overview

```
┌─────────────────┐
│   API Layer     │  ← HTTP endpoints, request/response handling
├─────────────────┤
│ Service Layer   │  ← Business logic, orchestration
├─────────────────┤
│Repository Layer │  ← Data access abstraction (kiss_repository)
├─────────────────┤
│  Model Layer    │  ← Domain objects, extensions, validation
└─────────────────┘
```

## Customization

### Using a Custom Repository

```dart
import 'package:kiss_repository/kiss_repository.dart';
import 'package:todo_microservice/todo_microservice.dart';

void main() {
  // Use your own repository implementation
  final customRepository = MyCustomRepository<Todo>();
  
  final config = TodoApiConfiguration(
    repository: customRepository,
  );
  
  // Setup your server...
}
```

### Environment Configuration

The example uses an in-memory repository. For production, you might want to:

1. **Use a persistent repository** (file-based, database, etc.)
2. **Add authentication** and authorization
3. **Configure CORS** for web client access
4. **Add rate limiting** and other middleware
5. **Setup logging** and monitoring

## Testing

The library includes comprehensive tests:

```bash
# Run all tests
dart test

# Run only unit tests
dart test test/unit/

# Run only integration tests
dart test test/integration/
```

## Project Structure

```
example/
├── main.dart           # Example server implementation
├── README.md          # This file
lib/
├── api/               # API layer and generated models
├── models/            # Model extensions with domain logic
├── repositories/      # Repository queries and custom logic
├── services/          # Business logic layer
└── todo_microservice.dart  # Main library exports
test/
├── helpers/           # Test utilities and data
├── unit/             # Unit tests for each layer
└── integration/      # End-to-end API tests
```

## Next Steps

1. **Explore the tests** to understand the full API capabilities
2. **Check the OpenAPI specification** at `todo-api.yaml`
3. **Implement custom repositories** for your data storage needs
4. **Add authentication** and other production features
5. **Deploy** to your preferred hosting platform

## Documentation

- [MICROSERVICE_GUIDE.md](../MICROSERVICE_GUIDE.md) - Complete architectural guide
- [OpenAPI Spec](../todo-api.yaml) - API specification
- [Kiss Repository](https://pub.dev/packages/kiss_repository) - Repository pattern library 
