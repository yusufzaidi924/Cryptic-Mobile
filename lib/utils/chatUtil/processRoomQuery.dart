import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edmonscan/app/data/models/RequestChatModel.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

class ProcessRoom {
  /// Fetches user from Firebase and returns a promise.
  static Future<Map<String, dynamic>> fetchUser(
    FirebaseFirestore instance,
    String userId,
    String usersCollectionName, {
    String? role,
  }) async {
    final doc =
        await instance.collection(usersCollectionName).doc(userId).get();

    final data = doc.data()!;

    data['createdAt'] = data['createdAt']?.millisecondsSinceEpoch;
    data['id'] = doc.id;
    data['lastSeen'] = data['lastSeen']?.millisecondsSinceEpoch;
    data['role'] = role;
    data['updatedAt'] = data['updatedAt']?.millisecondsSinceEpoch;

    return data;
  }

  /// Returns a list of [Room] created from Firebase query.
  /// If room has 2 participants, sets correct room name and image.
  static Future<List<Room>> processRoomsQuery(
    User firebaseUser,
    FirebaseFirestore instance,
    QuerySnapshot<Map<String, dynamic>> query,
    String usersCollectionName,
  ) async {
    final futures = query.docs.map(
      (doc) => processRoomDocument(
        doc,
        firebaseUser,
        instance,
        usersCollectionName,
      ),
    );

    return await Future.wait(futures);
  }

  /// Returns a list of [Room] created from Firebase query.
  /// If room has 2 participants, sets correct room name and image.
  static Future<List<RequestChatModel>> processRequestsQuery(
    User firebaseUser,
    FirebaseFirestore instance,
    QuerySnapshot<Map<String, dynamic>> query,
    String usersCollectionName,
  ) async {
    final futures = query.docs.map(
      (doc) => processRequestDocument(
        doc,
        firebaseUser,
        instance,
        usersCollectionName,
      ),
    );

    return await Future.wait(futures);
  }

  /// Returns a [Room] created from Firebase document.
  static Future<RequestChatModel> processRequestDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
    User firebaseUser,
    FirebaseFirestore instance,
    String usersCollectionName,
  ) async {
    final data = doc.data()!;

    data['createdAt'] = data['createdAt']?.millisecondsSinceEpoch;
    data['id'] = doc.id;
    final fromUser = await fetchUser(
        instance, data['fromUID'] as String, usersCollectionName);
    final toUser =
        await fetchUser(instance, data['toUID'] as String, usersCollectionName);

    data['fromUser'] = fromUser;
    data['toUser'] = toUser;

    return RequestChatModel.fromJson(data);
  }

  /// Returns a [Room] created from Firebase document.
  static Future<Room> processRoomDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
    User firebaseUser,
    FirebaseFirestore instance,
    String usersCollectionName,
  ) async {
    final data = doc.data()!;

    data['createdAt'] = data['createdAt']?.millisecondsSinceEpoch;
    data['id'] = doc.id;
    data['updatedAt'] = data['updatedAt']?.millisecondsSinceEpoch;

    var imageUrl = data['imageUrl'] as String?;
    var name = data['name'] as String?;
    final type = data['type'] as String;
    final userIds = data['userIds'] as List<dynamic>;
    final userRoles = data['userRoles'] as Map<String, dynamic>?;

    final users = await Future.wait(
      userIds.map(
        (userId) => fetchUser(
          instance,
          userId as String,
          usersCollectionName,
          role: userRoles?[userId] as String?,
        ),
      ),
    );

    if (type == RoomType.direct.toShortString()) {
      try {
        final otherUser = users.firstWhere(
          (u) => u['id'] != firebaseUser.id,
        );

        imageUrl = otherUser['imageUrl'] as String?;
        name = '${otherUser['firstName'] ?? ''} ${otherUser['lastName'] ?? ''}'
            .trim();
      } catch (e) {
        // Do nothing if other user is not found, because he should be found.
        // Consider falling back to some default values.
      }
    }

    data['imageUrl'] = imageUrl;
    data['name'] = name;
    data['users'] = users;

    if (data['lastMessages'] != null) {
      final lastMessages = data['lastMessages'].map((lm) {
        final author = users.firstWhere(
          (u) => u['id'] == lm['authorId'],
          orElse: () => {'id': lm['authorId'] as String},
        );

        lm['author'] = author;
        lm['createdAt'] = lm['createdAt']?.millisecondsSinceEpoch;
        lm['id'] = lm['id'] ?? '';
        lm['updatedAt'] = lm['updatedAt']?.millisecondsSinceEpoch;

        return lm;
      }).toList();

      data['lastMessages'] = lastMessages;
    }

    return Room.fromJson(data);
  }
}
