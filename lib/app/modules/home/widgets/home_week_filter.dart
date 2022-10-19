import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/app/core/ui/theme_extensions.dart';

class HomeWeekFilter extends StatelessWidget {
  const HomeWeekFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
          child: DatePicker(
            DateTime.now(),
            initialSelectedDate: DateTime.now(),
            locale: "pt_BR",
            selectionColor: context.primaryColor,
            selectedTextColor: Colors.white,
            daysCount: 7,
            monthTextStyle: const TextStyle(fontSize: 8),
            dateTextStyle: const TextStyle(fontSize: 13),
            dayTextStyle: const TextStyle(fontSize: 13),
          ),
        )
      ],
    );
  }
}
