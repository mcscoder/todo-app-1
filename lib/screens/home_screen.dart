import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:todo_app_1/database/database.dart';
import 'package:todo_app_1/utils/app_colors.dart';
import 'package:todo_app_1/widgets/add_task_bottom_sheet.dart';
import 'package:todo_app_1/widgets/task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AppDatabase _db;
  bool _isGirdView = false;
  bool _isSearching = false;
  final _searchController = TextEditingController();

  @override
  void initState() {
    _db = AppDatabase();

    _searchController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _db.close();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleTaskCompletion(TaskData task) {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    _db.updateTask(updatedTask.toCompanion(false));
  }

  void _deleteTask(int id) {
    _db.deleteTask(id);
  }

  void _addTask(String title, String description) {
    final newTask = TasksCompanion.insert(
      title: title,
      description: drift.Value(description),
    );
    _db.insertTask(newTask);
  }

  void _showAddTaskSheet() async {
    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const AddTaskBottomSheet();
      },
    );

    if (result != null) {
      _addTask(result["title"]!, result["description"]!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskSheet,
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    if (_isSearching) {
      return PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryTextColor, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SizedBox(
                height: kToolbarHeight,
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  toolbarHeight: kToolbarHeight,
                  leading: IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = false;
                        _searchController.clear();
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  title: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: "Search tasks...",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: AppColors.primaryTextColor),
                    ),
                    cursorColor: AppColors.primaryTextColor,
                    style: const TextStyle(
                      color: AppColors.primaryTextColor,
                      fontSize: 18,
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        _searchController.clear();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          setState(() {
            _isGirdView = !_isGirdView;
          });
        },
        icon: Icon(
          _isGirdView ? Icons.view_list_rounded : Icons.grid_view_rounded,
          color: AppColors.primaryTextColor,
        ),
      ),
      title: const Text(
        "My Tasks",
        style: TextStyle(
          color: AppColors.primaryTextColor,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
          icon: const Icon(
            Icons.search,
            color: AppColors.primaryTextColor,
            size: 28,
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_isSearching)
            const Text(
              "What's on your mind?",
              style: TextStyle(
                color: AppColors.secondaryTextColor,
                fontSize: 18,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder(
              stream: _db.watchTasksByQuery(_searchController.text),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final tasks = snapshot.data ?? [];
                if (tasks.isEmpty) {
                  return Center(
                    child: Text(
                      _isSearching
                          ? "No tasks found."
                          : "No tasks yet. Add one!",
                    ),
                  );
                }

                return _isGirdView
                    ? _buildGridView(tasks)
                    : _buildListView(tasks);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<TaskData> tasks) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskCard(
          task: task,
          isGridView: _isGirdView,
          onDelete: () => _deleteTask(task.id),
          onComplete: () => _toggleTaskCompletion(task),
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 16),
      itemCount: tasks.length,
    );
  }

  Widget _buildGridView(List<TaskData> tasks) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskCard(
          task: task,
          isGridView: _isGirdView,
          onDelete: () => _deleteTask(task.id),
          onComplete: () => _toggleTaskCompletion(task),
        );
      },
      itemCount: tasks.length,
    );
  }

  Widget _buildBottomAppBar() {
    return BottomAppBar(
      color: AppColors.cardColor,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.home_outlined),
              color: AppColors.primaryColor,
            ),
            const SizedBox(width: 40),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.nightlight_outlined),
              color: AppColors.secondaryTextColor,
            ),
          ],
        ),
      ),
    );
  }
}
