// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: prefer_initializing_formals, library_private_types_in_public_api, annotate_overrides

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:openapi_base/openapi_base.dart';
part 'todo-api.openapi.g.dart';

@JsonSerializable()
@ApiUuidJsonConverter()
class Todo implements OpenApiContent {
  const Todo({
    required this.id,
    required this.title,
    this.description,
    required this.completed,
    required this.createdAt,
    this.completedAt,
  });

  factory Todo.fromJson(Map<String, dynamic> jsonMap) =>
      _$TodoFromJson(jsonMap);

  /// Unique identifier for the todo
  @JsonKey(
    name: 'id',
    includeIfNull: false,
  )
  final String id;

  /// The todo title
  @JsonKey(
    name: 'title',
    includeIfNull: false,
  )
  final String title;

  /// Optional detailed description
  @JsonKey(
    name: 'description',
    includeIfNull: false,
  )
  final String? description;

  /// Whether the todo is completed
  @JsonKey(
    name: 'completed',
    includeIfNull: false,
  )
  final bool completed;

  /// When the todo was created
  @JsonKey(
    name: 'createdAt',
    includeIfNull: false,
  )
  final DateTime createdAt;

  /// When the todo was completed (if completed)
  @JsonKey(
    name: 'completedAt',
    includeIfNull: false,
  )
  final DateTime? completedAt;

  Map<String, dynamic> toJson() => _$TodoToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable()
@ApiUuidJsonConverter()
class TodoCreate implements OpenApiContent {
  const TodoCreate({
    required this.title,
    this.description,
  });

  factory TodoCreate.fromJson(Map<String, dynamic> jsonMap) =>
      _$TodoCreateFromJson(jsonMap);

  /// The todo title
  @JsonKey(
    name: 'title',
    includeIfNull: false,
  )
  final String title;

  /// Optional detailed description
  @JsonKey(
    name: 'description',
    includeIfNull: false,
  )
  final String? description;

  Map<String, dynamic> toJson() => _$TodoCreateToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable()
@ApiUuidJsonConverter()
class TodoUpdate implements OpenApiContent {
  const TodoUpdate({
    this.title,
    this.description,
    this.completed,
  });

  factory TodoUpdate.fromJson(Map<String, dynamic> jsonMap) =>
      _$TodoUpdateFromJson(jsonMap);

  /// Updated title
  @JsonKey(
    name: 'title',
    includeIfNull: false,
  )
  final String? title;

  /// Updated description
  @JsonKey(
    name: 'description',
    includeIfNull: false,
  )
  final String? description;

  /// Updated completion status
  @JsonKey(
    name: 'completed',
    includeIfNull: false,
  )
  final bool? completed;

  Map<String, dynamic> toJson() => _$TodoUpdateToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable()
@ApiUuidJsonConverter()
class TodoListResponse implements OpenApiContent {
  const TodoListResponse({
    required this.todos,
    required this.total,
  });

  factory TodoListResponse.fromJson(Map<String, dynamic> jsonMap) =>
      _$TodoListResponseFromJson(jsonMap);

  /// List of todos
  @JsonKey(
    name: 'todos',
    includeIfNull: false,
  )
  final List<Todo> todos;

  /// Total number of todos
  @JsonKey(
    name: 'total',
    includeIfNull: false,
  )
  final int total;

  Map<String, dynamic> toJson() => _$TodoListResponseToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable()
@ApiUuidJsonConverter()
class MessageResponse implements OpenApiContent {
  const MessageResponse({required this.message});

  factory MessageResponse.fromJson(Map<String, dynamic> jsonMap) =>
      _$MessageResponseFromJson(jsonMap);

  /// Success message
  @JsonKey(
    name: 'message',
    includeIfNull: false,
  )
  final String message;

  Map<String, dynamic> toJson() => _$MessageResponseToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable()
@ApiUuidJsonConverter()
class ErrorResponse implements OpenApiContent {
  const ErrorResponse({required this.error});

  factory ErrorResponse.fromJson(Map<String, dynamic> jsonMap) =>
      _$ErrorResponseFromJson(jsonMap);

  /// Error message
  @JsonKey(
    name: 'error',
    includeIfNull: false,
  )
  final String error;

  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);

  @override
  String toString() => toJson().toString();
}

class TodosGetResponse200 extends TodosGetResponse
    implements OpenApiResponseBodyJson {
  /// List of todos
  TodosGetResponse200.response200(this.body)
      : status = 200,
        bodyJson = body.toJson();

  @override
  final int status;

  final TodoListResponse body;

  @override
  final Map<String, dynamic> bodyJson;

  @override
  final OpenApiContentType contentType =
      OpenApiContentType.parse('application/json');

  @override
  Map<String, Object?> propertiesToString() => {
        'status': status,
        'body': body,
        'bodyJson': bodyJson,
        'contentType': contentType,
      };
}

sealed class TodosGetResponse extends OpenApiResponse
    implements HasSuccessResponse<TodoListResponse> {
  TodosGetResponse();

  /// List of todos
  factory TodosGetResponse.response200(TodoListResponse body) =>
      TodosGetResponse200.response200(body);

  R map<R>({
    required ResponseMap<TodosGetResponse200, R> on200,
    ResponseMap<TodosGetResponse, R>? onElse,
  }) {
    if (this is TodosGetResponse200) {
      return on200((this as TodosGetResponse200));
    } else if (onElse != null) {
      return onElse(this);
    } else {
      throw StateError('Invalid instance of type $this');
    }
  }

  /// status 200:  List of todos
  @override
  TodoListResponse requireSuccess() {
    if (this is TodosGetResponse200) {
      return (this as TodosGetResponse200).body;
    } else {
      throw StateError('Expected success response, but got $this');
    }
  }
}

enum TodosGet {
  @JsonValue('completed')
  completed,
  @JsonValue('pending')
  pending,
}

extension TodosGetExt on TodosGet {
  static final Map<String, TodosGet> _names = {
    'completed': TodosGet.completed,
    'pending': TodosGet.pending,
  };
  static TodosGet fromName(String name) =>
      _names[name] ?? _throwStateError('Invalid enum name: $name for TodosGet');
  String get name => toString().substring(9);
}

class TodosPostResponse201 extends TodosPostResponse
    implements OpenApiResponseBodyJson {
  /// Todo created successfully
  TodosPostResponse201.response201(this.body)
      : status = 201,
        bodyJson = body.toJson();

  @override
  final int status;

  final Todo body;

  @override
  final Map<String, dynamic> bodyJson;

  @override
  final OpenApiContentType contentType =
      OpenApiContentType.parse('application/json');

  @override
  Map<String, Object?> propertiesToString() => {
        'status': status,
        'body': body,
        'bodyJson': bodyJson,
        'contentType': contentType,
      };
}

class TodosPostResponse400 extends TodosPostResponse
    implements OpenApiResponseBodyJson {
  /// Invalid request
  TodosPostResponse400.response400(this.body)
      : status = 400,
        bodyJson = body.toJson();

  @override
  final int status;

  final ErrorResponse body;

  @override
  final Map<String, dynamic> bodyJson;

  @override
  final OpenApiContentType contentType =
      OpenApiContentType.parse('application/json');

  @override
  Map<String, Object?> propertiesToString() => {
        'status': status,
        'body': body,
        'bodyJson': bodyJson,
        'contentType': contentType,
      };
}

sealed class TodosPostResponse extends OpenApiResponse
    implements HasSuccessResponse<Todo> {
  TodosPostResponse();

  /// Todo created successfully
  factory TodosPostResponse.response201(Todo body) =>
      TodosPostResponse201.response201(body);

  /// Invalid request
  factory TodosPostResponse.response400(ErrorResponse body) =>
      TodosPostResponse400.response400(body);

  R map<R>({
    required ResponseMap<TodosPostResponse201, R> on201,
    required ResponseMap<TodosPostResponse400, R> on400,
    ResponseMap<TodosPostResponse, R>? onElse,
  }) {
    if (this is TodosPostResponse201) {
      return on201((this as TodosPostResponse201));
    } else if (this is TodosPostResponse400) {
      return on400((this as TodosPostResponse400));
    } else if (onElse != null) {
      return onElse(this);
    } else {
      throw StateError('Invalid instance of type $this');
    }
  }

  /// status 201:  Todo created successfully
  @override
  Todo requireSuccess() {
    if (this is TodosPostResponse201) {
      return (this as TodosPostResponse201).body;
    } else {
      throw StateError('Expected success response, but got $this');
    }
  }
}

class TodosDeleteResponse200 extends TodosDeleteResponse
    implements OpenApiResponseBodyJson {
  /// All todos deleted
  TodosDeleteResponse200.response200(this.body)
      : status = 200,
        bodyJson = body.toJson();

  @override
  final int status;

  final MessageResponse body;

  @override
  final Map<String, dynamic> bodyJson;

  @override
  final OpenApiContentType contentType =
      OpenApiContentType.parse('application/json');

  @override
  Map<String, Object?> propertiesToString() => {
        'status': status,
        'body': body,
        'bodyJson': bodyJson,
        'contentType': contentType,
      };
}

sealed class TodosDeleteResponse extends OpenApiResponse
    implements HasSuccessResponse<MessageResponse> {
  TodosDeleteResponse();

  /// All todos deleted
  factory TodosDeleteResponse.response200(MessageResponse body) =>
      TodosDeleteResponse200.response200(body);

  R map<R>({
    required ResponseMap<TodosDeleteResponse200, R> on200,
    ResponseMap<TodosDeleteResponse, R>? onElse,
  }) {
    if (this is TodosDeleteResponse200) {
      return on200((this as TodosDeleteResponse200));
    } else if (onElse != null) {
      return onElse(this);
    } else {
      throw StateError('Invalid instance of type $this');
    }
  }

  /// status 200:  All todos deleted
  @override
  MessageResponse requireSuccess() {
    if (this is TodosDeleteResponse200) {
      return (this as TodosDeleteResponse200).body;
    } else {
      throw StateError('Expected success response, but got $this');
    }
  }
}

class TodosIdGetResponse200 extends TodosIdGetResponse
    implements OpenApiResponseBodyJson {
  /// Todo found
  TodosIdGetResponse200.response200(this.body)
      : status = 200,
        bodyJson = body.toJson();

  @override
  final int status;

  final Todo body;

  @override
  final Map<String, dynamic> bodyJson;

  @override
  final OpenApiContentType contentType =
      OpenApiContentType.parse('application/json');

  @override
  Map<String, Object?> propertiesToString() => {
        'status': status,
        'body': body,
        'bodyJson': bodyJson,
        'contentType': contentType,
      };
}

class TodosIdGetResponse404 extends TodosIdGetResponse
    implements OpenApiResponseBodyJson {
  /// Todo not found
  TodosIdGetResponse404.response404(this.body)
      : status = 404,
        bodyJson = body.toJson();

  @override
  final int status;

  final ErrorResponse body;

  @override
  final Map<String, dynamic> bodyJson;

  @override
  final OpenApiContentType contentType =
      OpenApiContentType.parse('application/json');

  @override
  Map<String, Object?> propertiesToString() => {
        'status': status,
        'body': body,
        'bodyJson': bodyJson,
        'contentType': contentType,
      };
}

sealed class TodosIdGetResponse extends OpenApiResponse
    implements HasSuccessResponse<Todo> {
  TodosIdGetResponse();

  /// Todo found
  factory TodosIdGetResponse.response200(Todo body) =>
      TodosIdGetResponse200.response200(body);

  /// Todo not found
  factory TodosIdGetResponse.response404(ErrorResponse body) =>
      TodosIdGetResponse404.response404(body);

  R map<R>({
    required ResponseMap<TodosIdGetResponse200, R> on200,
    required ResponseMap<TodosIdGetResponse404, R> on404,
    ResponseMap<TodosIdGetResponse, R>? onElse,
  }) {
    if (this is TodosIdGetResponse200) {
      return on200((this as TodosIdGetResponse200));
    } else if (this is TodosIdGetResponse404) {
      return on404((this as TodosIdGetResponse404));
    } else if (onElse != null) {
      return onElse(this);
    } else {
      throw StateError('Invalid instance of type $this');
    }
  }

  /// status 200:  Todo found
  @override
  Todo requireSuccess() {
    if (this is TodosIdGetResponse200) {
      return (this as TodosIdGetResponse200).body;
    } else {
      throw StateError('Expected success response, but got $this');
    }
  }
}

class TodosIdDeleteResponse200 extends TodosIdDeleteResponse
    implements OpenApiResponseBodyJson {
  /// Todo deleted successfully
  TodosIdDeleteResponse200.response200(this.body)
      : status = 200,
        bodyJson = body.toJson();

  @override
  final int status;

  final MessageResponse body;

  @override
  final Map<String, dynamic> bodyJson;

  @override
  final OpenApiContentType contentType =
      OpenApiContentType.parse('application/json');

  @override
  Map<String, Object?> propertiesToString() => {
        'status': status,
        'body': body,
        'bodyJson': bodyJson,
        'contentType': contentType,
      };
}

class TodosIdDeleteResponse404 extends TodosIdDeleteResponse
    implements OpenApiResponseBodyJson {
  /// Todo not found
  TodosIdDeleteResponse404.response404(this.body)
      : status = 404,
        bodyJson = body.toJson();

  @override
  final int status;

  final ErrorResponse body;

  @override
  final Map<String, dynamic> bodyJson;

  @override
  final OpenApiContentType contentType =
      OpenApiContentType.parse('application/json');

  @override
  Map<String, Object?> propertiesToString() => {
        'status': status,
        'body': body,
        'bodyJson': bodyJson,
        'contentType': contentType,
      };
}

sealed class TodosIdDeleteResponse extends OpenApiResponse
    implements HasSuccessResponse<MessageResponse> {
  TodosIdDeleteResponse();

  /// Todo deleted successfully
  factory TodosIdDeleteResponse.response200(MessageResponse body) =>
      TodosIdDeleteResponse200.response200(body);

  /// Todo not found
  factory TodosIdDeleteResponse.response404(ErrorResponse body) =>
      TodosIdDeleteResponse404.response404(body);

  R map<R>({
    required ResponseMap<TodosIdDeleteResponse200, R> on200,
    required ResponseMap<TodosIdDeleteResponse404, R> on404,
    ResponseMap<TodosIdDeleteResponse, R>? onElse,
  }) {
    if (this is TodosIdDeleteResponse200) {
      return on200((this as TodosIdDeleteResponse200));
    } else if (this is TodosIdDeleteResponse404) {
      return on404((this as TodosIdDeleteResponse404));
    } else if (onElse != null) {
      return onElse(this);
    } else {
      throw StateError('Invalid instance of type $this');
    }
  }

  /// status 200:  Todo deleted successfully
  @override
  MessageResponse requireSuccess() {
    if (this is TodosIdDeleteResponse200) {
      return (this as TodosIdDeleteResponse200).body;
    } else {
      throw StateError('Expected success response, but got $this');
    }
  }
}

class TodosIdPatchResponse200 extends TodosIdPatchResponse
    implements OpenApiResponseBodyJson {
  /// Todo updated successfully
  TodosIdPatchResponse200.response200(this.body)
      : status = 200,
        bodyJson = body.toJson();

  @override
  final int status;

  final Todo body;

  @override
  final Map<String, dynamic> bodyJson;

  @override
  final OpenApiContentType contentType =
      OpenApiContentType.parse('application/json');

  @override
  Map<String, Object?> propertiesToString() => {
        'status': status,
        'body': body,
        'bodyJson': bodyJson,
        'contentType': contentType,
      };
}

class TodosIdPatchResponse404 extends TodosIdPatchResponse
    implements OpenApiResponseBodyJson {
  /// Todo not found
  TodosIdPatchResponse404.response404(this.body)
      : status = 404,
        bodyJson = body.toJson();

  @override
  final int status;

  final ErrorResponse body;

  @override
  final Map<String, dynamic> bodyJson;

  @override
  final OpenApiContentType contentType =
      OpenApiContentType.parse('application/json');

  @override
  Map<String, Object?> propertiesToString() => {
        'status': status,
        'body': body,
        'bodyJson': bodyJson,
        'contentType': contentType,
      };
}

class TodosIdPatchResponse400 extends TodosIdPatchResponse
    implements OpenApiResponseBodyJson {
  /// Invalid request
  TodosIdPatchResponse400.response400(this.body)
      : status = 400,
        bodyJson = body.toJson();

  @override
  final int status;

  final ErrorResponse body;

  @override
  final Map<String, dynamic> bodyJson;

  @override
  final OpenApiContentType contentType =
      OpenApiContentType.parse('application/json');

  @override
  Map<String, Object?> propertiesToString() => {
        'status': status,
        'body': body,
        'bodyJson': bodyJson,
        'contentType': contentType,
      };
}

sealed class TodosIdPatchResponse extends OpenApiResponse
    implements HasSuccessResponse<Todo> {
  TodosIdPatchResponse();

  /// Todo updated successfully
  factory TodosIdPatchResponse.response200(Todo body) =>
      TodosIdPatchResponse200.response200(body);

  /// Todo not found
  factory TodosIdPatchResponse.response404(ErrorResponse body) =>
      TodosIdPatchResponse404.response404(body);

  /// Invalid request
  factory TodosIdPatchResponse.response400(ErrorResponse body) =>
      TodosIdPatchResponse400.response400(body);

  R map<R>({
    required ResponseMap<TodosIdPatchResponse200, R> on200,
    required ResponseMap<TodosIdPatchResponse404, R> on404,
    required ResponseMap<TodosIdPatchResponse400, R> on400,
    ResponseMap<TodosIdPatchResponse, R>? onElse,
  }) {
    if (this is TodosIdPatchResponse200) {
      return on200((this as TodosIdPatchResponse200));
    } else if (this is TodosIdPatchResponse404) {
      return on404((this as TodosIdPatchResponse404));
    } else if (this is TodosIdPatchResponse400) {
      return on400((this as TodosIdPatchResponse400));
    } else if (onElse != null) {
      return onElse(this);
    } else {
      throw StateError('Invalid instance of type $this');
    }
  }

  /// status 200:  Todo updated successfully
  @override
  Todo requireSuccess() {
    if (this is TodosIdPatchResponse200) {
      return (this as TodosIdPatchResponse200).body;
    } else {
      throw StateError('Expected success response, but got $this');
    }
  }
}

abstract class TodoApi implements ApiEndpoint {
  /// Get all todos
  /// get: /todos
  Future<TodosGetResponse> todosGet({TodosGet? status});

  /// Create a new todo
  /// post: /todos
  Future<TodosPostResponse> todosPost(TodoCreate body);

  /// Delete all todos
  /// delete: /todos
  Future<TodosDeleteResponse> todosDelete();

  /// Get a todo by ID
  /// get: /todos/{id}
  Future<TodosIdGetResponse> todosIdGet({required String id});

  /// Delete a todo
  /// delete: /todos/{id}
  Future<TodosIdDeleteResponse> todosIdDelete({required String id});

  /// Update a todo
  /// patch: /todos/{id}
  Future<TodosIdPatchResponse> todosIdPatch(
    TodoUpdate body, {
    required String id,
  });
}

abstract class TodoApiClient implements OpenApiClient {
  factory TodoApiClient(
    Uri baseUri,
    OpenApiRequestSender requestSender,
  ) =>
      _TodoApiClientImpl._(
        baseUri,
        requestSender,
      );

  /// Get all todos
  /// get: /todos
  ///
  /// * [status]: Filter by completion status
  Future<TodosGetResponse> todosGet({TodosGet? status});

  /// Create a new todo
  /// post: /todos
  ///
  Future<TodosPostResponse> todosPost(TodoCreate body);

  /// Delete all todos
  /// delete: /todos
  ///
  Future<TodosDeleteResponse> todosDelete();

  /// Get a todo by ID
  /// get: /todos/{id}
  ///
  Future<TodosIdGetResponse> todosIdGet({required String id});

  /// Delete a todo
  /// delete: /todos/{id}
  ///
  Future<TodosIdDeleteResponse> todosIdDelete({required String id});

  /// Update a todo
  /// patch: /todos/{id}
  ///
  Future<TodosIdPatchResponse> todosIdPatch(
    TodoUpdate body, {
    required String id,
  });
}

class _TodoApiClientImpl extends OpenApiClientBase implements TodoApiClient {
  _TodoApiClientImpl._(
    this.baseUri,
    this.requestSender,
  );

  @override
  final Uri baseUri;

  @override
  final OpenApiRequestSender requestSender;

  /// Get all todos
  /// get: /todos
  ///
  /// * [status]: Filter by completion status
  @override
  Future<TodosGetResponse> todosGet({TodosGet? status}) async {
    final request = OpenApiClientRequest(
      'get',
      '/todos',
      [],
    );
    request.addQueryParameter(
      'status',
      encodeString(status?.name),
    );
    return await sendRequest(
      request,
      {
        '200': (OpenApiClientResponse response) async =>
            TodosGetResponse200.response200(
                TodoListResponse.fromJson(await response.responseBodyJson()))
      },
    );
  }

  /// Create a new todo
  /// post: /todos
  ///
  @override
  Future<TodosPostResponse> todosPost(TodoCreate body) async {
    final request = OpenApiClientRequest(
      'post',
      '/todos',
      [],
    );
    request.setHeader(
      'content-type',
      'application/json',
    );
    request.setBody(OpenApiClientRequestBodyJson(body.toJson()));
    return await sendRequest(
      request,
      {
        '201': (OpenApiClientResponse response) async =>
            TodosPostResponse201.response201(
                Todo.fromJson(await response.responseBodyJson())),
        '400': (OpenApiClientResponse response) async =>
            TodosPostResponse400.response400(
                ErrorResponse.fromJson(await response.responseBodyJson())),
      },
    );
  }

  /// Delete all todos
  /// delete: /todos
  ///
  @override
  Future<TodosDeleteResponse> todosDelete() async {
    final request = OpenApiClientRequest(
      'delete',
      '/todos',
      [],
    );
    return await sendRequest(
      request,
      {
        '200': (OpenApiClientResponse response) async =>
            TodosDeleteResponse200.response200(
                MessageResponse.fromJson(await response.responseBodyJson()))
      },
    );
  }

  /// Get a todo by ID
  /// get: /todos/{id}
  ///
  @override
  Future<TodosIdGetResponse> todosIdGet({required String id}) async {
    final request = OpenApiClientRequest(
      'get',
      '/todos/{id}',
      [],
    );
    request.addPathParameter(
      'id',
      encodeString(id),
    );
    return await sendRequest(
      request,
      {
        '200': (OpenApiClientResponse response) async =>
            TodosIdGetResponse200.response200(
                Todo.fromJson(await response.responseBodyJson())),
        '404': (OpenApiClientResponse response) async =>
            TodosIdGetResponse404.response404(
                ErrorResponse.fromJson(await response.responseBodyJson())),
      },
    );
  }

  /// Delete a todo
  /// delete: /todos/{id}
  ///
  @override
  Future<TodosIdDeleteResponse> todosIdDelete({required String id}) async {
    final request = OpenApiClientRequest(
      'delete',
      '/todos/{id}',
      [],
    );
    request.addPathParameter(
      'id',
      encodeString(id),
    );
    return await sendRequest(
      request,
      {
        '200': (OpenApiClientResponse response) async =>
            TodosIdDeleteResponse200.response200(
                MessageResponse.fromJson(await response.responseBodyJson())),
        '404': (OpenApiClientResponse response) async =>
            TodosIdDeleteResponse404.response404(
                ErrorResponse.fromJson(await response.responseBodyJson())),
      },
    );
  }

  /// Update a todo
  /// patch: /todos/{id}
  ///
  @override
  Future<TodosIdPatchResponse> todosIdPatch(
    TodoUpdate body, {
    required String id,
  }) async {
    final request = OpenApiClientRequest(
      'patch',
      '/todos/{id}',
      [],
    );
    request.addPathParameter(
      'id',
      encodeString(id),
    );
    request.setHeader(
      'content-type',
      'application/json',
    );
    request.setBody(OpenApiClientRequestBodyJson(body.toJson()));
    return await sendRequest(
      request,
      {
        '200': (OpenApiClientResponse response) async =>
            TodosIdPatchResponse200.response200(
                Todo.fromJson(await response.responseBodyJson())),
        '404': (OpenApiClientResponse response) async =>
            TodosIdPatchResponse404.response404(
                ErrorResponse.fromJson(await response.responseBodyJson())),
        '400': (OpenApiClientResponse response) async =>
            TodosIdPatchResponse400.response400(
                ErrorResponse.fromJson(await response.responseBodyJson())),
      },
    );
  }
}

class TodoApiUrlResolve with OpenApiUrlEncodeMixin {
  /// Get all todos
  /// get: /todos
  ///
  /// * [status]: Filter by completion status
  OpenApiClientRequest todosGet({TodosGet? status}) {
    final request = OpenApiClientRequest(
      'get',
      '/todos',
      [],
    );
    request.addQueryParameter(
      'status',
      encodeString(status?.name),
    );
    return request;
  }

  /// Create a new todo
  /// post: /todos
  ///
  OpenApiClientRequest todosPost() {
    final request = OpenApiClientRequest(
      'post',
      '/todos',
      [],
    );
    return request;
  }

  /// Delete all todos
  /// delete: /todos
  ///
  OpenApiClientRequest todosDelete() {
    final request = OpenApiClientRequest(
      'delete',
      '/todos',
      [],
    );
    return request;
  }

  /// Get a todo by ID
  /// get: /todos/{id}
  ///
  OpenApiClientRequest todosIdGet({required String id}) {
    final request = OpenApiClientRequest(
      'get',
      '/todos/{id}',
      [],
    );
    request.addPathParameter(
      'id',
      encodeString(id),
    );
    return request;
  }

  /// Delete a todo
  /// delete: /todos/{id}
  ///
  OpenApiClientRequest todosIdDelete({required String id}) {
    final request = OpenApiClientRequest(
      'delete',
      '/todos/{id}',
      [],
    );
    request.addPathParameter(
      'id',
      encodeString(id),
    );
    return request;
  }

  /// Update a todo
  /// patch: /todos/{id}
  ///
  OpenApiClientRequest todosIdPatch({required String id}) {
    final request = OpenApiClientRequest(
      'patch',
      '/todos/{id}',
      [],
    );
    request.addPathParameter(
      'id',
      encodeString(id),
    );
    return request;
  }
}

class TodoApiRouter extends OpenApiServerRouterBase {
  TodoApiRouter(this.impl);

  final ApiEndpointProvider<TodoApi> impl;

  @override
  void configure() {
    addRoute(
      '/todos',
      'get',
      (OpenApiRequest request) async {
        return await impl.invoke(
          request,
          (TodoApi impl) async => impl.todosGet(
              status: paramOpt(
            name: 'status',
            value: request.queryParameter('status'),
            decode: (value) => TodosGetExt.fromName(paramToString(value)),
          )),
        );
      },
      security: [],
    );
    addRoute(
      '/todos',
      'post',
      (OpenApiRequest request) async {
        return await impl.invoke(
          request,
          (TodoApi impl) async =>
              impl.todosPost(TodoCreate.fromJson(await request.readJsonBody())),
        );
      },
      security: [],
    );
    addRoute(
      '/todos',
      'delete',
      (OpenApiRequest request) async {
        return await impl.invoke(
          request,
          (TodoApi impl) async => impl.todosDelete(),
        );
      },
      security: [],
    );
    addRoute(
      '/todos/{id}',
      'get',
      (OpenApiRequest request) async {
        return await impl.invoke(
          request,
          (TodoApi impl) async => impl.todosIdGet(
              id: paramRequired(
            name: 'id',
            value: request.pathParameter('id'),
            decode: (value) => paramToString(value),
          )),
        );
      },
      security: [],
    );
    addRoute(
      '/todos/{id}',
      'delete',
      (OpenApiRequest request) async {
        return await impl.invoke(
          request,
          (TodoApi impl) async => impl.todosIdDelete(
              id: paramRequired(
            name: 'id',
            value: request.pathParameter('id'),
            decode: (value) => paramToString(value),
          )),
        );
      },
      security: [],
    );
    addRoute(
      '/todos/{id}',
      'patch',
      (OpenApiRequest request) async {
        return await impl.invoke(
          request,
          (TodoApi impl) async => impl.todosIdPatch(
            TodoUpdate.fromJson(await request.readJsonBody()),
            id: paramRequired(
              name: 'id',
              value: request.pathParameter('id'),
              decode: (value) => paramToString(value),
            ),
          ),
        );
      },
      security: [],
    );
  }
}

class SecuritySchemes {}

T _throwStateError<T>(String message) => throw StateError(message);
