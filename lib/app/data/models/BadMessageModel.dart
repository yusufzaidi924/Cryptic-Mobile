import 'dart:convert';

import 'package:edmonscan/utils/formatDateTime.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BadMessageModel {
  String senderID = "";
  String content = "";
  String messageType = "";

  DateTime datetime = DateTime.now();

  BadMessageModel({
    required this.senderID,
    required this.content,
    required this.messageType,
  }) {
    this.senderID = senderID;
    this.content = content;
    this.messageType = messageType;
  }

  BadMessageModel.fromJson(Map<String, dynamic> json) {
    senderID = json['senderID'] ?? '';
    content = json['content'] ?? '';
    messageType = json['messageType'] ?? '';
    datetime = json['datetime'] != null
        ? convertUtcToLocal(DateTime.fromMillisecondsSinceEpoch(
            json['datetime'].millisecondsSinceEpoch))
        : DateTime.now();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['senderID'] = this.senderID;
    data['content'] = this.content;
    data['messageType'] = this.messageType;
    data['datetime'] = FieldValue.serverTimestamp();
    return data;
  }

  // @override
  // bool operator ==(Object other) {
  //   if (identical(this, other)) return true;

  //   return other is BadMessageModel && other.senderID == senderID;
  // }
}
