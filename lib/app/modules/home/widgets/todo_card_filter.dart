import 'package:flutter/material.dart';
import 'package:todo_list/app/core/ui/theme_extensions.dart';
import 'package:todo_list/app/models/task_filter_enum.dart';
import 'package:todo_list/app/models/total_task_model.dart';

class TodoCardFilter extends StatelessWidget {
  final String label;
  final TaskFilterEnum taskFilter;
  final bool selected;
  final TotalTaskModel? totalTaskModel;

  const TodoCardFilter(
      {Key? key,
      required this.label,
      required this.taskFilter,
      required this.selected,
      this.totalTaskModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _getPercentFinish() {
      final total = totalTaskModel?.totalTask ?? 0.0;
      final totalFinish = totalTaskModel?.totalTaskFinish ?? 0.0;

      return (total == 0) ? 0 : totalFinish / total;
    }

    return Container(
      constraints: const BoxConstraints(minHeight: 120, maxWidth: 150),
      decoration: BoxDecoration(
        color: context.primaryColor,
        border: Border.all(
          width: 1,
          color: Colors.grey.withOpacity(.8),
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${totalTaskModel?.totalTask ?? 0} TASK",
            style:
                context.titleStyle.copyWith(fontSize: 10, color: Colors.white),
          ),
          Text(
            label,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: _getPercentFinish()),
            duration: const Duration(seconds: 1),
            builder: ((context, value, child) {
              return LinearProgressIndicator(
                backgroundColor: context.primaryColorLigth.withAlpha(80),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                value: value,
              );
            }),
          )
        ],
      ),
    );
  }
}
