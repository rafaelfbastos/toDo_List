import 'package:todo_list/app/models/task_model.dart';

abstract class TaskRepository {
  Future<void> saveTask(DateTime date, String description);
  Future<List<TaskModel>> findByPeriod(DateTime start, DateTime end);
  Future<void> checkOrUncheckTask(TaskModel task);
}
