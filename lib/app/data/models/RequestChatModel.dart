import 'package:flutter_chat_types/flutter_chat_types.dart';

class RequestChatModel {
  String id;
  String from;
  String to;
  User? fromUser;
  User? toUser;
  int? createdAt;

  RequestChatModel({
    required this.id,
    required this.from,
    required this.to,
    this.fromUser,
    this.toUser,
    this.createdAt,
  });

  factory RequestChatModel.fromJson(Map<String, dynamic> json) {
    return RequestChatModel(
      id: json['id'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
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
    data['from'] = this.from;
    data['to'] = this.to;
    data['created_at'] = DateTime.now().millisecondsSinceEpoch;
    return data;
  }
}
