import 'package:todo_list/app/models/task_model.dart';

class WeekTaskModel {
  DateTime startDate;
  DateTime endDate;
  List<TaskModel> tasks;
  WeekTaskModel({
    required this.startDate,
    required this.endDate,
    required this.tasks,
  });
}
