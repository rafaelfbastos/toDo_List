import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/ui/theme_extensions.dart';
import 'package:todo_list/app/models/task_filter_enum.dart';
import 'package:todo_list/app/models/total_task_model.dart';
import 'package:todo_list/app/modules/home/home_controller.dart';
import 'package:todo_list/app/modules/home/widgets/todo_card_filter.dart';

class HomeFilters extends StatelessWidget {
  const HomeFilters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "FILTROS",
          style: context.titleStyle,
        ),
        const SizedBox(
          height: 10,
        ),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                TodoCardFilter(
                  label: "HOJE",
                  taskFilter: TaskFilterEnum.today,
                  totalTaskModel:
                      TotalTaskModel(totalTask: 10, totalTaskFinish: 8),
                  selected: context.select<HomeController, TaskFilterEnum>(
                          (value) => value.filterSelectded) ==
                      TaskFilterEnum.today,
                ),
                TodoCardFilter(
                    label: "AMANHÃ",
                    taskFilter: TaskFilterEnum.tomorrow,
                    selected: context.select<HomeController, TaskFilterEnum>(
                            (value) => value.filterSelectded) ==
                        TaskFilterEnum.tomorrow),
                TodoCardFilter(
                    label: "SEMANA",
                    taskFilter: TaskFilterEnum.week,
                    selected: context.select<HomeController, TaskFilterEnum>(
                            (value) => value.filterSelectded) ==
                        TaskFilterEnum.week),
              ],
            ))
      ],
    );
  }
}
