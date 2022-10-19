import 'package:flutter/material.dart';
import 'package:todo_list/app/core/notifier/default_listerner_notifier.dart';
import 'package:todo_list/app/core/ui/todo_list_icons.dart';
import 'package:todo_list/app/models/task_filter_enum.dart';
import 'package:todo_list/app/modules/home/home_controller.dart';
import 'package:todo_list/app/modules/home/widgets/home_drawer.dart';
import 'package:todo_list/app/core/ui/theme_extensions.dart';
import 'package:todo_list/app/modules/home/widgets/home_filters.dart';
import 'package:todo_list/app/modules/home/widgets/home_header.dart';
import 'package:todo_list/app/modules/home/widgets/home_task.dart';
import 'package:todo_list/app/modules/home/widgets/home_week_filter.dart';
import 'package:todo_list/app/modules/tasks/tasks_module.dart';

class HomePage extends StatefulWidget {
  final HomeController _homeController;

  const HomePage({Key? key, required HomeController homeController})
      : _homeController = homeController,
        super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    DefaultListernerNotifier(changeNotifier: widget._homeController).listener(
        context: context,
        successCallBack: ((notifier, listernerInstance) =>
            listernerInstance.dispose()));

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget._homeController.loadAllTasks();
      widget._homeController.findTasks(filter: TaskFilterEnum.today);
    });

    super.initState();
  }

  Future<void> _goToCreateTask(BuildContext context) async {
    await Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        animation =
            CurvedAnimation(parent: animation, curve: Curves.easeInQuad);
        return ScaleTransition(
          scale: animation,
          alignment: Alignment.bottomRight,
          child: child,
        );
      },
      pageBuilder: ((context, animation, secondaryAnimation) =>
          TasksModule().getPage("/task/create", context)),
    ));
    widget._homeController.reloadPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: context.primaryColor),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton(
            icon: const Icon(TodoListIcons.filter),
            onSelected: ((value) {
              widget._homeController.showOrHideFinishingTask();
            }),
            itemBuilder: ((context) => [
                  PopupMenuItem<bool>(
                    value: true,
                    child: Text(
                        "${widget._homeController.showFinishingTasks ? 'Esconder' : 'Mostrar'} tarefas concluidas"),
                  )
                ]),
          ),
        ],
        title: const Text(''),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.primaryColor,
        onPressed: () => _goToCreateTask(context),
        child: const Icon(
          Icons.add,
        ),
      ),
      drawer: HomeDrawer(),
      body: LayoutBuilder(
          builder: ((context, constrains) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constrains.maxHeight,
                    minWidth: constrains.maxWidth,
                  ),
                  child: IntrinsicHeight(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        HomeHeader(),
                        SizedBox(
                          height: 20,
                        ),
                        HomeFilters(),
                        HomeWeekFilter(),
                        HomeTask()
                      ],
                    ),
                  )),
                ),
              ))),
    );
  }
}
