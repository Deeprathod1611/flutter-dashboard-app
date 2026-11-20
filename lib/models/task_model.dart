import 'package:flutter/material.dart';

enum TaskStatus { active, pending, done }

class TaskModel {
  final String title;
  final String subtitle;
  final TaskStatus status;

  TaskModel({
    required this.title,
    required this.subtitle,
    required this.status,
  });

  // Returns readable string for the status
  String get statusLabel {
    switch (status) {
      case TaskStatus.active:
        return 'Active';
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.done:
        return 'Done';
    }
  }

  // Returns defined color for each status
  Color get statusColor {
    switch (status) {
      case TaskStatus.active:
        return Colors.greenAccent; // Or your theme color
      case TaskStatus.pending:
        return Colors.blue;
      case TaskStatus.done:
        return Colors.grey;
    }
  }
}