import 'dart:math';
import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../widgets/dashboard_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Starts at 3 so the first refresh adds Task 4 and Subtitle 4
  int _taskCounter = 3;

  // Tracks the currently selected filter chip
  String _selectedFilter = 'All';

  // Initial list containing Task 1, 2, and 3
  final List<TaskModel> _tasks = [
    TaskModel(title: 'Task 1', subtitle: 'Subtitle 1', status: TaskStatus.active),
    TaskModel(title: 'Task 2', subtitle: 'Subtitle 2', status: TaskStatus.pending),
    TaskModel(title: 'Task 3', subtitle: 'Subtitle 3', status: TaskStatus.done),
  ];

  final Random _random = Random();

  // Part 1: Add new task on Refresh button click with strict incrementing numbering
  void _addNewTask() {
    setState(() {
      _taskCounter++; // Increments strictly by 1 (4, then 5, 6...)

      // Pick a random status from Active, Pending, Done
      final List<TaskStatus> allStatuses = TaskStatus.values;
      final TaskStatus randomStatus = allStatuses[_random.nextInt(allStatuses.length)];

      // Append new card item to the list
      _tasks.add(
        TaskModel(
          title: 'Task $_taskCounter',
          subtitle: 'Subtitle $_taskCounter',
          status: randomStatus,
        ),
      );
    });
  }

  // Part 3: Filter logic to only show items matching the selected status chip
  List<TaskModel> get _filteredTasks {
    if (_selectedFilter == 'All') {
      return _tasks;
    }
    return _tasks.where((task) {
      return task.statusLabel.toLowerCase() == _selectedFilter.toLowerCase();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF7A1CAC);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black54),
        title: const Text(
          'Dashboard',
          style: TextStyle(color: primaryPurple, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.orange.shade100,
              child: const Icon(Icons.person, color: Colors.brown, size: 20),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Hello, User',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 4),
            const Text(
              'Check your recent activity today.',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),

            // Part 3: Interactive Filter Chips (All, Active, Pending, Done)
            Row(
              children: ['All', 'Active', 'Pending', 'Done'].map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    selectedColor: primaryPurple,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                    backgroundColor: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    showCheckmark: false,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Task List View or "No tasks available" message
            Expanded(
              child: _filteredTasks.isEmpty
                  ? const Center(
                child: Text(
                  'No tasks available',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black45,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: _filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = _filteredTasks[index];
                  return DashboardCard(
                    title: task.title,
                    subtitle: task.subtitle,
                    status: task.statusLabel,
                    statusColor: task.statusColor,
                  );
                },
              ),
            ),

            // Part 1: Refresh Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _addNewTask,
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text(
                  'Refresh',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: primaryPurple,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.insights), label: 'INSIGHTS'),
          BottomNavigationBarItem(icon: Icon(Icons.folder_copy), label: 'PROJECTS'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'ACCOUNT'),
        ],
      ),
    );
  }
}