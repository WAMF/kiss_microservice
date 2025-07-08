# Todo API Example

A simple Todo REST API built with Dart and Shelf framework. This project serves as a starting point for building backend services with Dart.

## Features

- ✅ Full CRUD operations for todos
- 🔍 Filter todos by status (completed/pending)
- 🚀 Fast and lightweight using Shelf framework
- 📝 Clean architecture with separation of concerns
- 🔧 Dependency injection with kiss_dependencies
- 📦 JSON serialization with code generation

## Getting Started

### Prerequisites

- Dart SDK >= 3.0.0

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd todo-api-example
```

2. Install dependencies
```bash
dart pub get
```

3. Generate JSON serialization code
```bash
dart run build_runner build
```

4. Run the server
```bash
dart run lib/main.dart
```

The server will start on `http://localhost:8080`

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | API information |
| GET | `/todos` | Get all todos |
| POST | `/todos` | Create a new todo |
| GET | `/todos/{id}` | Get a todo by ID |
| PUT | `/todos/{id}` | Update a todo |
| DELETE | `/todos/{id}` | Delete a todo |
| DELETE | `/todos` | Delete all todos |
| GET | `/todos/status/completed` | Get completed todos |
| GET | `/todos/status/pending` | Get pending todos |

## Usage Examples

### Create a Todo
```bash
curl -X POST http://localhost:8080/todos \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Learn Dart",
    "description": "Complete the Dart language tour"
  }'
```

### Update a Todo
```bash
curl -X PUT http://localhost:8080/todos/{id} \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Learn Dart and Flutter",
    "completed": true
  }'
```

### Get All Todos
```bash
curl http://localhost:8080/todos
```

## Project Structure

```
lib/
├── main.dart              # Application entry point
├── dependencies.dart      # Dependency injection setup
├── models/
│   └── todo.dart         # Todo model
├── services/
│   └── todo_service.dart # Business logic
└── routes/
    └── todo_routes.dart  # HTTP endpoints
```

## Development

### Running Tests
```bash
dart test
```

### Linting
```bash
dart analyze
```

### Regenerate JSON Serialization
```bash
dart run build_runner build
```

## Docker Support

Build and run with Docker:

```bash
docker build -t todo-api .
docker run -p 8080:8080 todo-api
```

## Next Steps

This is a basic example with in-memory storage. For production use, consider:

- [ ] Add database integration (PostgreSQL, MongoDB, etc.)
- [ ] Implement authentication and authorization
- [ ] Add request validation middleware
- [ ] Implement pagination for list endpoints
- [ ] Add logging and monitoring
- [ ] Create API documentation with OpenAPI/Swagger
- [ ] Add rate limiting
- [ ] Implement caching strategies

## License

This project is open source and available under the MIT License.