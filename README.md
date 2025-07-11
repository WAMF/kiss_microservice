# Todo Microservice

A comprehensive Todo microservice built with Dart following the KISS architectural pattern. This project demonstrates clean architecture, OpenAPI-first development, and modern microservice design principles.

## 🚀 Features

- ✅ **Clean Architecture**: Clear separation of concerns across layers
- 🔄 **Repository Pattern**: Flexible data access via `kiss_repository`
- 📝 **OpenAPI-First**: Generated models from OpenAPI specification
- 🧪 **Comprehensive Testing**: Unit, integration, and API tests
- 🏗️ **Dependency Injection**: Flexible configuration through DI
- 🔧 **Type Safety**: Full Dart type safety with validation
- 📦 **Package Design**: Reusable library with example implementation

## 🏗️ Architecture

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

### Key Components

- **Generated Models**: OpenAPI specification drives model generation
- **Domain Extensions**: Business logic in model extensions
- **Repository Queries**: Custom queries for complex data operations
- **Service Layer**: Pure business logic, repository-agnostic
- **API Service**: HTTP request handling with proper error management
- **Configuration**: Dependency injection with multiple repository options

## 🚦 Getting Started

### Prerequisites

- Dart SDK >= 3.0.0

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd todo_microservice
   ```

2. **Install dependencies:**
   ```bash
   dart pub get
   ```

3. **Generate models from OpenAPI spec:**
   ```bash
   dart run build_runner build
   ```

4. **Run the server:**
   ```bash
   dart run lib/main.dart
   ```

   Or run the example with sample data:
   ```bash
   dart run example/main.dart
   ```

5. **Visit the API:**
   - Open http://localhost:8080 for API documentation
   - Explore the comprehensive API endpoints

## 📡 API Endpoints

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

## 💡 Usage Examples

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
curl -X PATCH http://localhost:8080/todos/{id} \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Learn Dart and Flutter",
    "completed": true
  }'
```

### Get Statistics
```bash
curl http://localhost:8080/todos/stats
```

## 🏛️ Project Structure

```
lib/
├── api/                          # API layer
│   ├── todo-api.openapi.dart     # Generated models
│   ├── todo-api.openapi.g.dart   # Generated serialization
│   ├── todo-api.openapi.yaml     # OpenAPI spec copy
│   ├── todo_api_configuration.dart  # DI configuration
│   └── todo_api_service.dart     # HTTP endpoint handlers
├── models/
│   └── todo_extensions.dart      # Domain model extensions
├── repositories/
│   └── todo_queries.dart         # Custom query implementations
├── services/
│   └── todo_service.dart         # Business logic
└── todo_microservice.dart        # Library exports

example/
├── main.dart                     # Example server implementation
└── README.md                     # Usage examples

test/
├── helpers/
│   └── test_helpers.dart         # Test utilities and data
├── unit/
│   └── services/
│       └── todo_service_test.dart  # Unit tests
└── integration/
    └── api_test.dart             # End-to-end API tests

todo-api.yaml                     # OpenAPI specification
build.yaml                       # Code generation config
MICROSERVICE_GUIDE.md            # Complete architectural guide
```

## 🧪 Testing

The project includes comprehensive tests covering all layers:

```bash
# Run all tests
dart test

# Run only unit tests
dart test test/unit/

# Run only integration tests
dart test test/integration/

# Run with coverage
dart test --coverage=coverage
```

### Test Coverage

- **Unit Tests**: Services, models, repositories
- **Integration Tests**: End-to-end API testing
- **Test Helpers**: Comprehensive utilities and test data
- **Error Scenarios**: Validation, not found, malformed data

## 🔧 Configuration

### Using Custom Repository

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

### In-Memory Repository (Default)

```dart
final config = TodoApiConfiguration.withInMemoryRepository();
```

## 📚 Documentation

- [MICROSERVICE_GUIDE.md](MICROSERVICE_GUIDE.md) - Complete architectural guide
- [OpenAPI Specification](todo-api.yaml) - API contract definition
- [Example README](example/README.md) - Usage examples and customization

## 🛠️ Development

### Code Generation

The project uses OpenAPI-first development:

1. **Edit the OpenAPI spec**: `todo-api.yaml`
2. **Copy to lib/api/**: `cp todo-api.yaml lib/api/todo-api.openapi.yaml`
3. **Regenerate models**: `dart run build_runner build --delete-conflicting-outputs`
4. **Update extensions** and services as needed

### Adding New Features

1. **Update OpenAPI spec** with new endpoints/models
2. **Regenerate models** using build runner
3. **Add domain logic** in model extensions
4. **Implement business logic** in services
5. **Add API endpoints** in API service
6. **Write tests** for all layers

## 🚀 Deployment

The microservice is designed for easy deployment:

- **Docker**: Containerize with official Dart image
- **Cloud Run**: Deploy on Google Cloud Run
- **AWS Lambda**: Use with AWS Lambda for Dart
- **Kubernetes**: Deploy as a pod with health checks
- **Traditional Hosting**: Run on any server with Dart runtime

## 🤝 Contributing

1. **Follow the architectural patterns** outlined in MICROSERVICE_GUIDE.md
2. **Write comprehensive tests** for new features
3. **Update OpenAPI specification** for API changes
4. **Maintain clean separation** between layers
5. **Document new features** and usage examples

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Kiss Repository](https://pub.dev/packages/kiss_repository) - Repository pattern implementation
- [Shelf Plus](https://pub.dev/packages/shelf_plus) - HTTP server framework
- [OpenAPI Code Builder](https://pub.dev/packages/openapi_code_builder) - Code generation

---

**Built with ❤️ using Dart and modern microservice principles**
