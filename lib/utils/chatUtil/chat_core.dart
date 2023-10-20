import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edmonscan/app/data/models/RequestChatModel.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';

import 'processRoomQuery.dart';

/// Provides access to Firebase chat data. Singleton, use
/// FirebaseChatCore.instance to aceess methods.
class MyChatCore {
  MyChatCore._privateConstructor() {
    final AuthCtrl = Get.find<AuthController>();
    // FirebaseAuth.instance.authStateChanges().listen((User? user) {
    //   firebaseUser = user;
    // });
    firebaseUser = AuthCtrl.chatUser;
  }

  /// Config to set custom names for rooms and users collections. Also
  /// see [FirebaseChatCoreConfig].
  FirebaseChatCoreConfig config = const FirebaseChatCoreConfig(
    null,
    'rooms',
    'users',
  );

  /// Current logged in user in Firebase. Does not update automatically.
  /// Use [FirebaseAuth.authStateChanges] to listen to the state changes.
  User? firebaseUser;

  /// Singleton instance.
  static final MyChatCore instance = MyChatCore._privateConstructor();

  /// Gets proper [FirebaseFirestore] instance.
  FirebaseFirestore getFirebaseFirestore() => config.firebaseAppName != null
      ? FirebaseFirestore.instanceFor(
          app: Firebase.app(config.firebaseAppName!),
        )
      : FirebaseFirestore.instance;

  /// Sets custom config to change default names for rooms
  /// and users collections. Also see [FirebaseChatCoreConfig].
  void setConfig(FirebaseChatCoreConfig firebaseChatCoreConfig) {
    config = firebaseChatCoreConfig;
  }

  /// Creates a chat group room with [users]. Creator is automatically
  /// added to the group. [name] is required and will be used as
  /// a group name. Add an optional [imageUrl] that will be a group avatar
  /// and [metadata] for any additional custom data.
  Future<Room> createGroupRoom({
    Role creatorRole = Role.admin,
    String? imageUrl,
    Map<String, dynamic>? metadata,
    required String name,
    required List<User> users,
  }) async {
    if (firebaseUser == null) return Future.error('User does not exist');

    final currentUser = await fetchUser(
      getFirebaseFirestore(),
      firebaseUser!.id,
      config.usersCollectionName,
      role: creatorRole.toShortString(),
    );

    final roomUsers = [User.fromJson(currentUser)] + users;

    final room = await getFirebaseFirestore()
        .collection(config.roomsCollectionName)
        .add({
      'createdAt': FieldValue.serverTimestamp(),
      'imageUrl': imageUrl,
      'metadata': metadata,
      'name': name,
      'type': RoomType.group.toShortString(),
      'updatedAt': FieldValue.serverTimestamp(),
      'userIds': roomUsers.map((u) => u.id).toList(),
      'userRoles': roomUsers.fold<Map<String, String?>>(
        {},
        (previousValue, user) => {
          ...previousValue,
          user.id: user.role?.toShortString(),
        },
      ),
    });

    return Room(
      id: room.id,
      imageUrl: imageUrl,
      metadata: metadata,
      name: name,
      type: RoomType.group,
      users: roomUsers,
    );
  }

  /******************
   * Check Room Exist
   */
  Future<bool> checkRoomExist(User otherUser) async {
    final fu = firebaseUser;

    final userIds = [fu!.id, otherUser.id]..sort();

    final roomQuery = await getFirebaseFirestore()
        .collection(config.roomsCollectionName)
        .where('type', isEqualTo: RoomType.direct.toShortString())
        .where('userIds', isEqualTo: userIds)
        .limit(1)
        .get();

    // Check if room already exist.
    return roomQuery.docs.isNotEmpty;
  }

  /// Creates a direct chat for 2 people. Add [metadata] for any additional
  /// custom data.
  Future<Room> createRoom(
    User otherUser, {
    Map<String, dynamic>? metadata,
  }) async {
    final fu = firebaseUser;

    if (fu == null) return Future.error('User does not exist');

    // Sort two user ids array to always have the same array for both users,
    // this will make it easy to find the room if exist and make one read only.
    final userIds = [fu.id, otherUser.id]..sort();

    final roomQuery = await getFirebaseFirestore()
        .collection(config.roomsCollectionName)
        .where('type', isEqualTo: RoomType.direct.toShortString())
        .where('userIds', isEqualTo: userIds)
        .limit(1)
        .get();

    // Check if room already exist.
    if (roomQuery.docs.isNotEmpty) {
      final room = (await ProcessRoom.processRoomsQuery(
        fu,
        getFirebaseFirestore(),
        roomQuery,
        config.usersCollectionName,
      ))
          .first;

      return room;
    }

    // To support old chats created without sorted array,
    // try to check the room by reversing user ids array.
    final oldRoomQuery = await getFirebaseFirestore()
        .collection(config.roomsCollectionName)
        .where('type', isEqualTo: RoomType.direct.toShortString())
        .where('userIds', isEqualTo: userIds.reversed.toList())
        .limit(1)
        .get();

    // Check if room already exist.
    if (oldRoomQuery.docs.isNotEmpty) {
      final room = (await ProcessRoom.processRoomsQuery(
        fu,
        getFirebaseFirestore(),
        oldRoomQuery,
        config.usersCollectionName,
      ))
          .first;

      return room;
    }

    final currentUser = await fetchUser(
      getFirebaseFirestore(),
      fu.id,
      config.usersCollectionName,
    );

    final users = [User.fromJson(currentUser), otherUser];

    // Create new room with sorted user ids array.
    final room = await getFirebaseFirestore()
        .collection(config.roomsCollectionName)
        .add({
      'createdAt': FieldValue.serverTimestamp(),
      'imageUrl': null,
      'metadata': metadata,
      'name': null,
      'type': RoomType.direct.toShortString(),
      'updatedAt': FieldValue.serverTimestamp(),
      'userIds': userIds,
      'userRoles': null,
    });

    return Room(
      id: room.id,
      metadata: metadata,
      type: RoomType.direct,
      users: users,
    );
  }

  /// Creates [User] in Firebase to store name and avatar used on
  /// rooms list.
  Future<void> createUserInFirestore(User user) async {
    await getFirebaseFirestore()
        .collection(config.usersCollectionName)
        .doc(user.id)
        .set({
      'createdAt': FieldValue.serverTimestamp(),
      'firstName': user.firstName,
      'imageUrl': user.imageUrl,
      'lastName': user.lastName,
      'lastSeen': FieldValue.serverTimestamp(),
      'metadata': user.metadata,
      'role': user.role?.toShortString(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Removes message document.
  Future<void> deleteMessage(String roomId, String messageId) async {
    await getFirebaseFirestore()
        .collection('${config.roomsCollectionName}/$roomId/messages')
        .doc(messageId)
        .delete();
  }

  /// Removes room document.
  Future<void> deleteRoom(String roomId) async {
    await getFirebaseFirestore()
        .collection(config.roomsCollectionName)
        .doc(roomId)
        .delete();
  }

  /// Removes [User] from `users` collection in Firebase.
  Future<void> deleteUserFromFirestore(String userId) async {
    await getFirebaseFirestore()
        .collection(config.usersCollectionName)
        .doc(userId)
        .delete();
  }

  /// Returns a stream of messages from Firebase for a given room.
  Stream<List<Message>> messages(
    Room room, {
    List<Object?>? endAt,
    List<Object?>? endBefore,
    int? limit,
    List<Object?>? startAfter,
    List<Object?>? startAt,
  }) {
    var query = getFirebaseFirestore()
        .collection('${config.roomsCollectionName}/${room.id}/messages')
        .orderBy('createdAt', descending: true);

    if (endAt != null) {
      query = query.endAt(endAt);
    }

    if (endBefore != null) {
      query = query.endBefore(endBefore);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    if (startAfter != null) {
      query = query.startAfter(startAfter);
    }

    if (startAt != null) {
      query = query.startAt(startAt);
    }

    return query.snapshots().map(
          (snapshot) => snapshot.docs.fold<List<Message>>(
            [],
            (previousValue, doc) {
              final data = doc.data();
              final author = room.users.firstWhere(
                (u) => u.id == data['authorId'],
                orElse: () => User(id: data['authorId'] as String),
              );

              data['author'] = author.toJson();
              data['createdAt'] = data['createdAt']?.millisecondsSinceEpoch;
              data['id'] = doc.id;
              data['updatedAt'] = data['updatedAt']?.millisecondsSinceEpoch;

              return [...previousValue, Message.fromJson(data)];
            },
          ),
        );
  }

  /// Returns a stream of changes in a room from Firebase.
  Stream<Room> room(String roomId) {
    final fu = firebaseUser;

    if (fu == null) return const Stream.empty();

    return getFirebaseFirestore()
        .collection(config.roomsCollectionName)
        .doc(roomId)
        .snapshots()
        .asyncMap(
          (doc) => ProcessRoom.processRoomDocument(
            doc,
            fu,
            getFirebaseFirestore(),
            config.usersCollectionName,
          ),
        );
  }

  /// Returns a stream of rooms from Firebase. Only rooms where current
  /// logged in user exist are returned. [orderByUpdatedAt] is used in case
  /// you want to have last modified rooms on top, there are a couple
  /// of things you will need to do though:
  /// 1) Make sure `updatedAt` exists on all rooms
  /// 2) Write a Cloud Function which will update `updatedAt` of the room
  /// when the room changes or new messages come in
  /// 3) Create an Index (Firestore Database -> Indexes tab) where collection ID
  /// is `rooms`, field indexed are `userIds` (type Arrays) and `updatedAt`
  /// (type Descending), query scope is `Collection`.
  Stream<List<Room>> rooms({bool orderByUpdatedAt = false}) {
    final fu = firebaseUser;

    if (fu == null) return const Stream.empty();

    final collection = orderByUpdatedAt
        ? getFirebaseFirestore()
            .collection(config.roomsCollectionName)
            .where('userIds', arrayContains: fu.id)
            .orderBy('updatedAt', descending: true)
        : getFirebaseFirestore()
            .collection(config.roomsCollectionName)
            .where('userIds', arrayContains: fu.id);

    return collection.snapshots().asyncMap(
          (query) => ProcessRoom.processRoomsQuery(
            fu,
            getFirebaseFirestore(),
            query,
            config.usersCollectionName,
          ),
        );
  }

  /// Returns a stream of requests from Firebase. Only requests where current
  /// logged in user exist are returned. [orderByUpdatedAt] is used in case
  /// you want to have last modified requests on top, there are a couple
  /// of things you will need to do though:
  /// 1) Make sure `updatedAt` exists on all requests
  /// 2) Write a Cloud Function which will update `updatedAt` of the room
  /// when the room changes or new messages come in
  /// 3) Create an Index (Firestore Database -> Indexes tab) where collection ID
  /// is `requests`, field indexed are `userIds` (type Arrays) and `updatedAt`
  /// (type Descending), query scope is `Collection`.
  Stream<List<RequestChatModel>> requests({bool orderByCreatedAt = false}) {
    final fu = firebaseUser;

    if (fu == null) return const Stream.empty();

    final collection = orderByCreatedAt
        ? getFirebaseFirestore()
            .collection(DatabaseConfig.CHAT_REQUEST_COLLECTION)
            .where('toUID', arrayContains: fu.id)
            .orderBy('createdAt', descending: true)
        : getFirebaseFirestore()
            .collection(config.roomsCollectionName)
            .where('toUID', arrayContains: fu.id);

    return collection.snapshots().asyncMap(
          (query) => ProcessRoom.processRequestsQuery(
            fu,
            getFirebaseFirestore(),
            query,
            config.usersCollectionName,
          ),
        );
  }

  /// Sends a message to the Firestore. Accepts any partial message and a
  /// room ID. If arbitraty data is provided in the [partialMessage]
  /// does nothing.
  void sendMessage(dynamic partialMessage, String roomId) async {
    if (firebaseUser == null) return;

    Message? message;

    if (partialMessage is PartialCustom) {
      message = CustomMessage.fromPartial(
        author: User(id: firebaseUser!.id),
        id: '',
        partialCustom: partialMessage,
      );
    } else if (partialMessage is PartialFile) {
      message = FileMessage.fromPartial(
        author: User(id: firebaseUser!.id),
        id: '',
        partialFile: partialMessage,
      );
    } else if (partialMessage is PartialImage) {
      message = ImageMessage.fromPartial(
        author: User(id: firebaseUser!.id),
        id: '',
        partialImage: partialMessage,
      );
    } else if (partialMessage is PartialText) {
      message = TextMessage.fromPartial(
        author: User(id: firebaseUser!.id),
        id: '',
        partialText: partialMessage,
      );
    }

    if (message != null) {
      final messageMap = message.toJson();
      messageMap.removeWhere((key, value) => key == 'author' || key == 'id');
      messageMap['authorId'] = firebaseUser!.id;
      messageMap['createdAt'] = FieldValue.serverTimestamp();
      messageMap['updatedAt'] = FieldValue.serverTimestamp();

      await getFirebaseFirestore()
          .collection('${config.roomsCollectionName}/$roomId/messages')
          .add(messageMap);

      await getFirebaseFirestore()
          .collection(config.roomsCollectionName)
          .doc(roomId)
          .update({'updatedAt': FieldValue.serverTimestamp()});
    }
  }

  /// Updates a message in the Firestore. Accepts any message and a
  /// room ID. Message will probably be taken from the [messages] stream.
  void updateMessage(Message message, String roomId) async {
    if (firebaseUser == null) return;
    if (message.author.id != firebaseUser!.id) return;

    final messageMap = message.toJson();
    messageMap.removeWhere(
      (key, value) => key == 'author' || key == 'createdAt' || key == 'id',
    );
    messageMap['authorId'] = message.author.id;
    messageMap['updatedAt'] = FieldValue.serverTimestamp();

    await getFirebaseFirestore()
        .collection('${config.roomsCollectionName}/$roomId/messages')
        .doc(message.id)
        .update(messageMap);
  }

  /// Updates a room in the Firestore. Accepts any room.
  /// Room will probably be taken from the [rooms] stream.
  void updateRoom(Room room) async {
    if (firebaseUser == null) return;

    final roomMap = room.toJson();
    roomMap.removeWhere((key, value) =>
        key == 'createdAt' ||
        key == 'id' ||
        key == 'lastMessages' ||
        key == 'users');

    if (room.type == RoomType.direct) {
      roomMap['imageUrl'] = null;
      roomMap['name'] = null;
    }

    roomMap['lastMessages'] = room.lastMessages?.map((m) {
      final messageMap = m.toJson();

      messageMap.removeWhere((key, value) =>
          key == 'author' ||
          key == 'createdAt' ||
          key == 'id' ||
          key == 'updatedAt');

      messageMap['authorId'] = m.author.id;

      return messageMap;
    }).toList();
    roomMap['updatedAt'] = FieldValue.serverTimestamp();
    roomMap['userIds'] = room.users.map((u) => u.id).toList();

    await getFirebaseFirestore()
        .collection(config.roomsCollectionName)
        .doc(room.id)
        .update(roomMap);
  }

  /// Returns a stream of all users from Firebase.
  Stream<List<User>> users() {
    if (firebaseUser == null) return const Stream.empty();
    return getFirebaseFirestore()
        .collection(config.usersCollectionName)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.fold<List<User>>(
            [],
            (previousValue, doc) {
              if (firebaseUser!.id == doc.id) return previousValue;

              final data = doc.data();

              data['createdAt'] = data['createdAt']?.millisecondsSinceEpoch;
              data['id'] = doc.id;
              data['lastSeen'] = data['lastSeen']?.millisecondsSinceEpoch;
              data['updatedAt'] = data['updatedAt']?.millisecondsSinceEpoch;

              return [...previousValue, User.fromJson(data)];
            },
          ),
        );
  }
}
