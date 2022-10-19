import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/ui/theme_extensions.dart';
import 'package:todo_list/app/modules/tasks/task_create_controller.dart';

class CalendarButton extends StatelessWidget {
  final dateFormat = DateFormat.yMMMEd('pt_BR');

  CalendarButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final currentDateTime = DateTime.now();
        final lastDate = currentDateTime.add(const Duration(days: 365 * 10));

        final DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: currentDateTime,
            firstDate: DateTime(2000),
            lastDate: lastDate);

        context.read<TaskCreateController>().selectedDate = selectedDate;
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.today,
              color: Colors.grey,
            ),
            const SizedBox(
              width: 7,
            ),
            Selector<TaskCreateController, DateTime?>(
              selector: ((context, taskCreateController) =>
                  taskCreateController.selectedDate),
              builder: ((context, selectedDate, child) {
                if (selectedDate != null) {
                  return Text(
                    dateFormat.format(selectedDate),
                    style: context.titleStyle,
                  );
                } else {
                  return Text(
                    "SELECIONE UMA DATA",
                    style: context.titleStyle,
                  );
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}
