import 'package:flutter/material.dart';
import 'package:sqlite/components/add_task_dialog.dart';
import 'package:sqlite/components/task_item.dart';
import 'package:sqlite/components/edit_task_dialog.dart'; // Import dialog edit
import '../models/task.dart';
import '../services/task_service.dart';

class HomeScreen extends StatefulWidget {
  final TaskService taskService;

  const HomeScreen({super.key, required this.taskService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
    widget.taskService.checkDeadlineTasks(); // Cek deadline saat init
  }

  // Load tasks dari database
  Future<void> _loadTasks() async {
    final tasks = await widget.taskService.getTask();
    setState(() => _tasks = tasks);
  }

  // Tambah task baru
  Future<void> _addTask() async {
    final newTask = await showDialog<Task>(
      context: context,
      builder: (context) => AddTaskDialog(),
    );

    if (newTask != null) {
      await widget.taskService.addTask(newTask);
      _loadTasks(); // Refresh list
    }
  }

  // Edit task
  Future<void> _editTask(Task task) async {
    final updatedTask = await showDialog<Task>(
      context: context,
      builder: (context) => EditTaskDialog(task: task),
    );

    if (updatedTask != null) {
      await widget.taskService.updateTask(updatedTask);
      _loadTasks();
    }
  }

  // Hapus task
  Future<void> _deleteTask(Task task) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Hapus Task'),
            content: Text('Yakin ingin menghapus task "${task.title}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Hapus'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await widget.taskService.deleteTask(task.id!);
      _loadTasks(); // Refresh list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager')),
      body:
          _tasks.isEmpty
              ? const Center(child: Text('No tasks yet!'))
              : ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return TaskItem(
                    task: task,
                    onDelete: () => _deleteTask(task),
                    onEdit: () => _editTask(task),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
