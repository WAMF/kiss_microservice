# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Build and Run
```bash
# Install dependencies
dart pub get

# Generate JSON serialization code
dart run build_runner build

# Run the server
dart run lib/main.dart
```

### Testing and Linting
```bash
# Run tests
dart test

# Run linter
dart analyze

# Clean and rebuild generated files
dart run build_runner clean
dart run build_runner build
```

### Docker
```bash
# Build Docker image
docker build -t todo-api .

# Run with Docker
docker run -p 8080:8080 todo-api
```

## Architecture Overview

This is a simple Todo API example built with Dart and the `shelf_plus` web framework. It demonstrates a clean architecture pattern with separation of concerns.

### Core Components

- **Todo Model** (`lib/models/todo.dart`): Defines the Todo entity with id, title, description, completed status, and timestamps
- **Todo Service** (`lib/services/todo_service.dart`): In-memory storage and business logic for todo operations
- **Todo Routes** (`lib/routes/todo_routes.dart`): HTTP endpoints for todo management

### Key Features

1. **Todo Management**: Full CRUD operations for todos
2. **Status Filtering**: Get todos by status (completed/pending)
3. **RESTful API**: Clean REST endpoints following standard conventions
4. **In-Memory Storage**: Simple storage for demo purposes (data lost on restart)

### HTTP Endpoints

- `GET /` - API information and available endpoints
- `GET /todos` - Get all todos
- `POST /todos` - Create a new todo
- `GET /todos/{id}` - Get a specific todo
- `PUT /todos/{id}` - Update a todo
- `DELETE /todos/{id}` - Delete a specific todo
- `DELETE /todos` - Delete all todos
- `GET /todos/status/completed` - Get completed todos
- `GET /todos/status/pending` - Get pending todos

### Request/Response Examples

#### Create Todo
```bash
curl -X POST http://localhost:8080/todos \
  -H "Content-Type: application/json" \
  -d '{"title": "Buy groceries", "description": "Milk, eggs, bread"}'
```

#### Update Todo
```bash
curl -X PUT http://localhost:8080/todos/{id} \
  -H "Content-Type: application/json" \
  -d '{"completed": true}'
```

### Dependencies

- `shelf_plus`: Web framework built on Shelf
- `json_annotation`/`json_serializable`: JSON serialization with code generation
- `kiss_dependencies`: Simple dependency injection
- `uuid`: UUID generation for todo IDs

### Code Generation

The project uses `build_runner` for generating JSON serialization code. All model classes with `@JsonSerializable()` annotations require regeneration when modified.

### Storage

Currently uses in-memory storage via `TodoService`. All todo data is lost on server restart. For production use, integrate with a database.