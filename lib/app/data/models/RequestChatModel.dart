import 'package:flutter_chat_types/flutter_chat_types.dart';

class RequestChatModel {
  String id;
  String fromUID;
  String toUID;
  User? fromUser;
  User? toUser;
  int? createdAt;

  RequestChatModel({
    required this.id,
    required this.fromUID,
    required this.toUID,
    this.fromUser,
    this.toUser,
    this.createdAt,
  });

  factory RequestChatModel.fromJson(Map<String, dynamic> json) {
    return RequestChatModel(
      id: json['id'] as String,
      fromUID: json['fromUID'] as String,
      toUID: json['toUID'] as String,
      fromUser:
          json['fromUser'] != null ? User.fromJson(json['fromUser']) : null,
      toUser: json['toUser'] != null ? User.fromJson(json['toUser']) : null,
      createdAt: json['created_at'] != null
          ? json['created_at'] as int
          : DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fromUID'] = this.fromUID;
    data['toUID'] = this.toUID;
    data['created_at'] = DateTime.now().millisecondsSinceEpoch;
    return data;
  }
}
