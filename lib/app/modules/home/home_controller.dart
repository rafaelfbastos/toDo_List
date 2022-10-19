import 'package:flutter/material.dart';
import 'package:todo_list/app/core/notifier/default_notifier.dart';
import 'package:todo_list/app/models/task_filter_enum.dart';

class HomeController extends DefaultNotifier {
  var filterSelectded = TaskFilterEnum.today;
}
