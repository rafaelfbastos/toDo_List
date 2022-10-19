import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/modules/todo_list_module.dart';
import 'package:todo_list/app/modules/tasks/task_create_controller.dart';
import 'package:todo_list/app/modules/tasks/task_create_page.dart';
import 'package:todo_list/app/repositories/task/task_repository.dart';
import 'package:todo_list/app/repositories/task/task_repository_impl.dart';
import 'package:todo_list/app/services/task/task_service.dart';
import 'package:todo_list/app/services/task/task_service_impl.dart';

class TasksModule extends TodoListModule {
  TasksModule()
      : super(routers: {
          "/task/create": ((context) => TaskCreatePage(
                controller: context.read(),
              ))
        }, bindings: [
          Provider<TaskRepository>(
            create: (context) =>
                TaskRepositoryImpl(connectionFactory: context.read()),
          ),
          Provider<TaskService>(
            create: (context) =>
                TaskServiceImpl(taskRepository: context.read()),
          ),
          ChangeNotifierProvider(
            create: (context) =>
                TaskCreateController(taskService: context.read()),
          )
        ]);
}
