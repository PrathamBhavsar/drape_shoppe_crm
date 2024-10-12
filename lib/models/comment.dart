import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drape_shoppe_crm/providers/home_provider.dart';

class CommentModel {
  final String user;
  final DateTime createdAt;
  final String comment;

  CommentModel({
    required this.user,
    required this.createdAt,
    required this.comment,
  });

  // // JSON to TaskModel object
  // factory CommentModel.fromJson(Map<String, dynamic> json) {
  //   return CommentModel(
  //     commentId: json['commentId'] as int,
  //     user: json['user'] as String,
  //     createdAt: (json['created_at'] as Timestamp).toDate(),
  //     comment: json['comment'] as String,
  //   );
  // }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
        user: json['user'] as String,
        createdAt: (json['created_at'] as Timestamp).toDate(),
        comment: json['comment'] as String);
  }

  // TaskModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'created_at': Timestamp.fromDate(createdAt),
      'comment': comment,
    };
  }
}
