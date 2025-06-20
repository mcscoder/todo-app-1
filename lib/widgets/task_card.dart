import 'package:flutter/material.dart';
import 'package:todo_app_1/database/database.dart';
import 'package:todo_app_1/utils/app_colors.dart';

class TaskCard extends StatelessWidget {
  final TaskData task;
  final bool isGridView;
  final VoidCallback onDelete;
  final VoidCallback onComplete;

  const TaskCard({
    super.key,
    required this.task,
    this.isGridView = false,
    required this.onDelete,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    if (isGridView) {
      return _buildGridView();
    }
    return _buildListView();
  }

  Widget _buildListView() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onComplete,
            icon: Icon(
              task.isCompleted
                  ? Icons.check_box_rounded
                  : Icons.check_box_outline_blank_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontStyle: task.isCompleted
                        ? FontStyle.italic
                        : FontStyle.normal,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: Colors.white,
                    decorationThickness: 2,
                  ),
                ),
                if (task.description?.isNotEmpty == true)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      task.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontStyle: task.isCompleted
                            ? FontStyle.italic
                            : FontStyle.normal,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: Colors.white70,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return Container(
      padding: const EdgeInsets.all(12).copyWith(bottom: 0),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontStyle: task.isCompleted
                        ? FontStyle.italic
                        : FontStyle.normal,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: Colors.white,
                    decorationThickness: 2,
                  ),
                ),
                if (task.description?.isNotEmpty == true)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      task.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontStyle: task.isCompleted
                            ? FontStyle.italic
                            : FontStyle.normal,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: Colors.white70,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: onComplete,
                icon: Icon(
                  task.isCompleted
                      ? Icons.check_box_rounded
                      : Icons.check_box_outline_blank_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
