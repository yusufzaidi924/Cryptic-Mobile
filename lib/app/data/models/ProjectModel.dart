import 'dart:convert';

import 'package:edmonscan/utils/formatDateTime.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  String id = "";
  DateTime createdAt = DateTime.now();
  String creator = "";
  String title = "";
  String organisation = "";
  DateTime updatedAt = DateTime.now();

  ProjectModel({
    required this.id,
    required this.createdAt,
    required this.creator,
    required this.title,
    required this.organisation,
    required this.updatedAt,
  }) {
    this.createdAt = createdAt;
    this.creator = creator;
    this.id = id;
    this.title = title;
    this.organisation = organisation;
    this.updatedAt = updatedAt;
  }

  ProjectModel.fromJson(Map json) {
    creator = json['creator'] ?? '';
    // id = json['id'] ?? '';

    title = json['title'] ?? '';
    organisation = json['organisation'] ?? '';

    updatedAt = json['updatedAt'] != null
        ? convertUtcToLocal(
            DateTime.fromMillisecondsSinceEpoch(json['updatedAt']))
        : DateTime.now();

    createdAt = json['createdAt'] != null
        ? convertUtcToLocal(
            DateTime.fromMillisecondsSinceEpoch(json['createdAt']))
        : DateTime.now();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['creator'] = this.creator;
    data['updatedAt'] = FieldValue.serverTimestamp();
    return data;
  }

  // @override
  // bool operator ==(Object other) {
  //   if (identical(this, other)) return true;

  //   return other is ProjectModel && other.createdAt == createdAt;
  // }
}
