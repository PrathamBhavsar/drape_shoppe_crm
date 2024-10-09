import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String dealNo;
  final DateTime createdAt;
  final String createdBy;
  final List<String> assignedTo;
  final String priority;
  final String title;
  final String description;
  final DateTime dueDate;
  final String designer;
  final Map<String, String> comments;
  final String status;
  final int progress;
  final List<String> attachments;

  TaskModel({
    required this.dealNo,
    required this.createdAt,
    required this.createdBy,
    required this.assignedTo,
    required this.priority,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.designer,
    required this.comments,
    required this.status,
    required this.progress,
    required this.attachments,
  });

  // JSON to TaskModel object
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      dealNo: json['deal_no'] as String,
      createdAt: (json['created_at'] as Timestamp).toDate(),
      createdBy: json['created_by'] as String,
      assignedTo: List<String>.from(json['assigned_to']),
      priority: json['priority'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: (json['due_date'] as Timestamp).toDate(),
      designer: json['designer'] as String,
      comments: Map<String, String>.from(json['comments'] as Map),
      status: json['status'] as String,
      progress: json['progress'] as int,
      attachments: List<String>.from(json['attachments']),
    );
  }

  // TaskModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'deal_no': dealNo,
      'created_at': Timestamp.fromDate(createdAt),
      'created_by': createdBy,
      'assigned_to': assignedTo,
      'priority': priority,
      'title': title,
      'description': description,
      'due_date': Timestamp.fromDate(dueDate),
      'designer': designer,
      'comments': comments,
      'status': status,
      'progress': progress,
      'attachments': attachments,
    };
  }
}
