import 'package:todo_list/app/core/notifier/default_notifier.dart';
import 'package:todo_list/app/models/task_filter_enum.dart';
import 'package:todo_list/app/models/task_model.dart';
import 'package:todo_list/app/models/total_task_model.dart';
import 'package:todo_list/app/models/week_task_model.dart';
import 'package:todo_list/app/services/task/task_service.dart';

class HomeController extends DefaultNotifier {
  final TaskService _taskService;
  TotalTaskModel? totalTaskToday;
  TotalTaskModel? totalTaskTomorrow;
  TotalTaskModel? totalTaskWeek;
  var filterSelectded = TaskFilterEnum.tomorrow;
  List<TaskModel> allTasks = [];
  List<TaskModel> filteredTasks = [];
  DateTime? initialDateWeek;
  DateTime? selectDate;
  bool showFinishingTasks = false;

  HomeController({
    required TaskService taskService,
  }) : _taskService = taskService;

  Future<void> loadAllTasks() async {
    var allTasks = await Future.wait([
      _taskService.getToday(),
      _taskService.getTomorrow(),
      _taskService.getWeek()
    ]);

    final taskToday = allTasks[0] as List<TaskModel>;
    final taskTomorrow = allTasks[1] as List<TaskModel>;
    final taskWeek = allTasks[2] as WeekTaskModel;

    totalTaskToday = TotalTaskModel(
        totalTask: taskToday.length,
        totalTaskFinish: taskToday.where((e) => e.finished).length);

    totalTaskTomorrow = TotalTaskModel(
        totalTask: taskTomorrow.length,
        totalTaskFinish: taskTomorrow.where((e) => e.finished).length);

    totalTaskWeek = TotalTaskModel(
        totalTask: taskWeek.tasks.length,
        totalTaskFinish: taskWeek.tasks.where((e) => e.finished).length);

    notifyListeners();
  }

  Future<void> findTasks({required TaskFilterEnum filter}) async {
    filterSelectded = filter;
    showLoading();
    notifyListeners();
    List<TaskModel> tasks;

    switch (filter) {
      case TaskFilterEnum.today:
        tasks = await _taskService.getToday();
        break;
      case TaskFilterEnum.tomorrow:
        tasks = await _taskService.getTomorrow();
        break;
      case TaskFilterEnum.week:
        final weekModel = await _taskService.getWeek();
        initialDateWeek = weekModel.startDate;
        tasks = weekModel.tasks;
        break;
    }
    allTasks = tasks;
    filteredTasks = tasks;

    if (filter == TaskFilterEnum.week) {
      if (selectDate != null) {
        filterByDay(selectDate!);
      } else if (initialDateWeek != null) {
        filterByDay(initialDateWeek!);
      }
    } else {
      selectDate = null;
    }

    if (!showFinishingTasks) {
      filteredTasks = filteredTasks.where((task) => task.finished).toList();
    }
    hideLoading();
    notifyListeners();
  }

  Future<void> reloadPage() async {
    await loadAllTasks();
    await findTasks(filter: filterSelectded);
    notifyListeners();
  }

  void filterByDay(DateTime date) {
    selectDate = date;
    filteredTasks =
        allTasks.where((task) => task.dateTime == selectDate).toList();
    notifyListeners();
  }

  Future<void> checkOrUncheckTask(TaskModel task) async {
    showLoadingAndResetState();
    notifyListeners();
    final taskUpdate = task.copyWith(finished: !task.finished);
    await _taskService.checkOrUncheckTask(taskUpdate);
    hideLoading();
    reloadPage();
  }

  void showOrHideFinishingTask() {
    showFinishingTasks = !showFinishingTasks;
    reloadPage();
  }
}
