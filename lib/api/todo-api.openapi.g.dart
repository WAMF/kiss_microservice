// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo-api.openapi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) => Todo(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      completed: json['completed'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      if (instance.description case final value?) 'description': value,
      'completed': instance.completed,
      'createdAt': instance.createdAt.toIso8601String(),
      if (instance.completedAt?.toIso8601String() case final value?)
        'completedAt': value,
    };

TodoCreate _$TodoCreateFromJson(Map<String, dynamic> json) => TodoCreate(
      title: json['title'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$TodoCreateToJson(TodoCreate instance) =>
    <String, dynamic>{
      'title': instance.title,
      if (instance.description case final value?) 'description': value,
    };

TodoUpdate _$TodoUpdateFromJson(Map<String, dynamic> json) => TodoUpdate(
      title: json['title'] as String?,
      description: json['description'] as String?,
      completed: json['completed'] as bool?,
    );

Map<String, dynamic> _$TodoUpdateToJson(TodoUpdate instance) =>
    <String, dynamic>{
      if (instance.title case final value?) 'title': value,
      if (instance.description case final value?) 'description': value,
      if (instance.completed case final value?) 'completed': value,
    };

TodoListResponse _$TodoListResponseFromJson(Map<String, dynamic> json) =>
    TodoListResponse(
      todos: (json['todos'] as List<dynamic>)
          .map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$TodoListResponseToJson(TodoListResponse instance) =>
    <String, dynamic>{
      'todos': instance.todos,
      'total': instance.total,
    };

MessageResponse _$MessageResponseFromJson(Map<String, dynamic> json) =>
    MessageResponse(
      message: json['message'] as String,
    );

Map<String, dynamic> _$MessageResponseToJson(MessageResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
    };

ErrorResponse _$ErrorResponseFromJson(Map<String, dynamic> json) =>
    ErrorResponse(
      error: json['error'] as String,
    );

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
    };
