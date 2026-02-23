import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task_entity.dart';
import '../cubit/task_cubit.dart';
import 'edit_task_bottom_sheet.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final String userId;

  const TaskCard({super.key, required this.task, required this.userId});

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (val) {
            final updated = task.copyWith(isCompleted: val ?? false);
            context.read<TaskCubit>().updateTask(task: updated, userId: userId);
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description.isNotEmpty) Text(task.description),
            const SizedBox(height: 4),
            Row(
  children: [
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _priorityColor(task.priority),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        task.priority.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
    ),
    const SizedBox(width: 8),
    if (task.category.isNotEmpty)
      Flexible(
        child: Text(task.category, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
      ),
    const Spacer(),
    if (task.dueDate != null)
      Text(
        '${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
        style: const TextStyle(fontSize: 12),
      ),
  ],
),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
          onSelected: (val) {
            if (val == 'edit') {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => EditTaskBottomSheet(task: task, userId: userId),
              );
            } else if (val == 'delete') {
              context.read<TaskCubit>().deleteTask(taskId: task.id, userId: userId);
            }
          },
        ),
      ),
    );
  }
}