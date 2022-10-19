// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:todo_list/app/core/notifier/default_notifier.dart';
import 'package:todo_list/app/services/task/task_service.dart';

class TaskCreateController extends DefaultNotifier {
  final TaskService _taskService;
  DateTime? _selectedDate;

  bool get hasDate => (_selectedDate != null);

  TaskCreateController({
    required TaskService taskService,
  }) : _taskService = taskService;

  set selectedDate(DateTime? selectedDate) {
    resetState();
    _selectedDate = selectedDate;
    notifyListeners();
  }

  DateTime? get selectedDate => _selectedDate;

  Future<void> save(String description) async {
    try {
      showLoadingAndResetState();
      notifyListeners();
      await _taskService.saveTask(_selectedDate!, description);
      success();
    } on Exception catch (e) {
      print(e);
      setError("Erro ao salvar Task");
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
