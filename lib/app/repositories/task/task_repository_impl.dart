// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:todo_list/app/core/database/sqlite_connection_factory.dart';
import 'package:todo_list/app/repositories/task/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final SqliteConnectionFactory _connectionFactory;

  TaskRepositoryImpl({
    required SqliteConnectionFactory connectionFactory,
  }) : _connectionFactory = connectionFactory;

  @override
  Future<void> saveTask(DateTime date, String description) async {
    final conn = await _connectionFactory.openConnection();
    conn.insert("todo", {
      "id": null,
      "descricao": description,
      "data_hora": date.toIso8601String(),
      "finalizado": 0
    });
  }
}
