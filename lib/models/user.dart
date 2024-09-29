class UserModel {
  final String createdAt;
  final String userName;


  UserModel({
    required this.createdAt,
    required this.userName,
  });

  // json to User object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      createdAt: json['created_at'],
      userName: json['user_name'],
    );
  }

  // User object to json
  Map<String, dynamic> toJson() {
    return {
      'created_at': createdAt,
      'user_name': userName,
    };
  }
}