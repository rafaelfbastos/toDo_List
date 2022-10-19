import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/ui/theme_extensions.dart';
import 'package:todo_list/app/models/task_filter_enum.dart';

import '../home_controller.dart';

class HomeWeekFilter extends StatelessWidget {
  const HomeWeekFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: context.select<HomeController, bool>(
          (controler) => controler.filterSelectded == TaskFilterEnum.week),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            "DIA DA SEMANA",
            style: context.titleStyle,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 95,
            child: Selector<HomeController, DateTime>(
              selector: ((context, controller) =>
                  controller.initialDateWeek ?? DateTime.now()),
              builder: (__, initialDate, _) {
                return DatePicker(
                  initialDate,
                  initialSelectedDate: DateTime.now(),
                  locale: "pt_BR",
                  selectionColor: context.primaryColor,
                  selectedTextColor: Colors.white,
                  daysCount: 7,
                  monthTextStyle: const TextStyle(fontSize: 8),
                  dateTextStyle: const TextStyle(fontSize: 13),
                  dayTextStyle: const TextStyle(fontSize: 13),
                  onDateChange: (date) =>
                      context.read<HomeController>().filterByDay(date),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
