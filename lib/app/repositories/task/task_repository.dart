abstract class TaskRepository {
  Future<void> saveTask(DateTime date, String description);
}
