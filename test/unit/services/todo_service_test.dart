import 'package:kiss_repository/kiss_repository.dart';
import 'package:test/test.dart';
import 'package:todo_microservice/todo_microservice.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('TodoService Tests', () {
    late Repository<Todo> repository;
    late TodoService service;

    setUp(() {
      // Create an in-memory repository for testing
      // Using the TodoApiConfiguration factory as a reference for proper setup
      final config =
          TodoApiConfiguration.withInMemoryRepository(path: 'test_todos');
      repository = config.repository;
      service = config.todoService;
    });

    tearDown(() {
      service.dispose();
    });

    group('Todo Creation', () {
      test('should create a todo successfully', () async {
        final todoCreate = TestData.createTodoCreate(
          title: 'Test Todo',
          description: 'Test description',
        );

        final created = await service.createTodo(todoCreate);

        expect(created.id, isNotEmpty);
        expect(created.title, equals('Test Todo'));
        expect(created.description, equals('Test description'));
        expect(created.completed, isFalse);
        expect(created.createdAt, isNotNull);
        expect(created.completedAt, isNull);

        TestHelpers.validateTodo(created);
      });

      test('should create todo with minimal data', () async {
        final todoCreate = TestData.createTodoCreate(title: 'Minimal Todo');

        final created = await service.createTodo(todoCreate);

        expect(created.title, equals('Minimal Todo'));
        expect(created.description, equals('New todo description'));
        TestHelpers.validateTodo(created);
      });

      test('should throw on invalid todo creation', () async {
        final todoCreate = TodoCreateExtensions.create(
          title: '', // Invalid empty title
          description: 'Valid description',
        );

        expect(
          () => service.createTodo(todoCreate),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should create todos with unique IDs', () async {
        final todoCreate1 = TestData.createTodoCreate(title: 'Todo 1');
        final todoCreate2 = TestData.createTodoCreate(title: 'Todo 2');

        final created1 = await service.createTodo(todoCreate1);
        final created2 = await service.createTodo(todoCreate2);

        expect(created1.id, isNot(equals(created2.id)));
      });
    });

    group('Todo Retrieval', () {
      test('should get todo by ID', () async {
        final todoCreate = TestData.createTodoCreate();
        final created = await service.createTodo(todoCreate);

        final retrieved = await service.getTodo(created.id);

        expect(retrieved.id, equals(created.id));
        expect(retrieved.title, equals(created.title));
        TestHelpers.validateTodo(retrieved);
      });

      test('should throw on non-existent todo', () async {
        expect(
          () => service.getTodo('non-existent-id'),
          throwsA(isA<RepositoryException>()),
        );
      });

      test('should get all todos sorted by creation date', () async {
        // Create multiple todos with slight delays
        final todo1 =
            await service.createTodo(TestData.createTodoCreate(title: 'First'));
        await TestHelpers.waitFor(TestConstants.shortDelay);
        final todo2 = await service
            .createTodo(TestData.createTodoCreate(title: 'Second'));
        await TestHelpers.waitFor(TestConstants.shortDelay);
        final todo3 =
            await service.createTodo(TestData.createTodoCreate(title: 'Third'));

        final allTodos = await service.getAllTodos();

        expect(allTodos.length, equals(3));
        // Should be sorted newest first
        expect(allTodos[0].title, equals('Third'));
        expect(allTodos[1].title, equals('Second'));
        expect(allTodos[2].title, equals('First'));
      });
    });

    group('Todo Updates', () {
      test('should update todo title', () async {
        final created = await service.createTodo(TestData.createTodoCreate());
        final update = TestData.createTodoUpdate(title: 'Updated Title');

        final updated = await service.updateTodo(created.id, update);

        expect(updated.title, equals('Updated Title'));
        expect(updated.id, equals(created.id));
        expect(updated.createdAt, equals(created.createdAt));
      });

      test('should mark todo as completed', () async {
        final created = await service.createTodo(TestData.createTodoCreate());
        final update = TestData.createTodoUpdate(completed: true);

        final updated = await service.updateTodo(created.id, update);

        expect(updated.completed, isTrue);
        expect(updated.completedAt, isNotNull);
        TestHelpers.validateTodo(updated);
      });

      test('should mark todo as pending', () async {
        // First create and complete a todo
        final created = await service.createTodo(TestData.createTodoCreate());
        await service.updateTodo(
            created.id, TestData.createTodoUpdate(completed: true));

        // Then mark as pending
        final update = TestData.createTodoUpdate(completed: false);
        final updated = await service.updateTodo(created.id, update);

        expect(updated.completed, isFalse);
        expect(updated.completedAt, isNull);
        TestHelpers.validateTodo(updated);
      });

      test('should return same todo if no changes', () async {
        final created = await service.createTodo(TestData.createTodoCreate());
        final update = TestData.createTodoUpdate(); // No changes

        final result = await service.updateTodo(created.id, update);

        expect(result.id, equals(created.id));
        expect(result.title, equals(created.title));
      });

      test('should throw on updating non-existent todo', () async {
        final update = TestData.createTodoUpdate(title: 'New Title');

        expect(
          () => service.updateTodo('non-existent', update),
          throwsA(isA<RepositoryException>()),
        );
      });
    });

    group('Todo Deletion', () {
      test('should delete todo by ID', () async {
        final created = await service.createTodo(TestData.createTodoCreate());

        await service.deleteTodo(created.id);

        expect(
          () => service.getTodo(created.id),
          throwsA(isA<RepositoryException>()),
        );
      });

      test('should delete all todos', () async {
        // Create multiple todos
        await service.createTodo(TestData.createTodoCreate(title: 'Todo 1'));
        await service.createTodo(TestData.createTodoCreate(title: 'Todo 2'));
        await service.createTodo(TestData.createTodoCreate(title: 'Todo 3'));

        await service.deleteAllTodos();

        final allTodos = await service.getAllTodos();
        expect(allTodos, isEmpty);
      });
    });

    group('Todo Filtering and Searching', () {
      setUp(() async {
        // Create test data with mixed statuses
        await service
            .createTodo(TestData.createTodoCreate(title: 'Pending Todo 1'));
        final todo2 = await service
            .createTodo(TestData.createTodoCreate(title: 'Todo to Complete'));
        await service
            .createTodo(TestData.createTodoCreate(title: 'Pending Todo 2'));

        // Mark one as completed
        await service.updateTodo(
            todo2.id, TestData.createTodoUpdate(completed: true));
      });

      test('should get completed todos', () async {
        final completed = await service.getCompletedTodos();

        expect(completed.length, equals(1));
        expect(completed[0].title, equals('Todo to Complete'));
        expect(completed[0].completed, isTrue);
      });

      test('should get pending todos', () async {
        final pending = await service.getPendingTodos();

        expect(pending.length, equals(2));
        expect(pending.every((todo) => !todo.completed), isTrue);
      });

      test('should search todos by title', () async {
        final searchResults = await service.searchTodosByTitle('Pending');

        expect(searchResults.length, equals(2));
        expect(searchResults.every((todo) => todo.title.contains('Pending')),
            isTrue);
      });

      test('should return all todos for empty search', () async {
        final searchResults = await service.searchTodosByTitle('');

        expect(searchResults.length, equals(3));
      });
    });

    group('Todo Statistics', () {
      setUp(() async {
        // Create test data
        await service.createTodo(TestData.createTodoCreate(title: 'Pending 1'));
        await service.createTodo(TestData.createTodoCreate(title: 'Pending 2'));
        final todo3 = await service
            .createTodo(TestData.createTodoCreate(title: 'To Complete'));

        // Mark one as completed
        await service.updateTodo(
            todo3.id, TestData.createTodoUpdate(completed: true));
      });

      test('should get correct todo statistics', () async {
        final stats = await service.getTodoStats();

        expect(stats.total, equals(3));
        expect(stats.completed, equals(1));
        expect(stats.pending, equals(2));
        expect(stats.overdue, equals(0)); // None are old enough
      });
    });

    group('Convenience Methods', () {
      test('should mark todo as completed using convenience method', () async {
        final created = await service.createTodo(TestData.createTodoCreate());

        final completed = await service.markTodoCompleted(created.id);

        expect(completed.completed, isTrue);
        expect(completed.completedAt, isNotNull);
      });

      test('should mark todo as pending using convenience method', () async {
        final created = await service.createTodo(TestData.createTodoCreate());
        await service.markTodoCompleted(created.id);

        final pending = await service.markTodoPending(created.id);

        expect(pending.completed, isFalse);
        expect(pending.completedAt, isNull);
      });
    });
  });
}
