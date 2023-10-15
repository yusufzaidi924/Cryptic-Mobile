// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dio/dio.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:opentrip/Helpers/constant.dart';
// import 'package:opentrip/Helpers/local_storage.dart';
// import 'package:opentrip/Models/chat_model.dart';
// import 'package:opentrip/Models/message_model.dart';

// class FirestoreService {
//   static final instance = FirebaseFirestore.instance;
//   static const String userCollection = 'users';
//   static const String roomCollection = 'rooms';
//   static const String messageCollection = "messages";
//   static final storageRef = FirebaseStorage.instance.ref();
//   static Future<String?> getDocIdByEmail(String email) async {
//     var result = await instance
//         .collection(userCollection)
//         .where("email", isEqualTo: email)
//         .get();
//     if (result.docs.isEmpty) {
//       return null;
//     }
//     return result.docs.first.id;
//   }

//   static Future<UserChatModel> getUserDetails(String docId) async {
//     final result = await instance.collection(userCollection).doc(docId).get();
//     return UserChatModel.fromJson(result.data()!, id: result.id);
//   }

//   static Future addUser(
//       {required String email,
//       required String name,
//       required String role,
//       required String companyCode}) async {
//     var result = await instance
//         .collection(userCollection)
//         .where("email", isEqualTo: email)
//         .get();
//     var docs = result.docs;
//     if (docs.isEmpty) {
//       await instance.collection(userCollection).add({
//         "email": email,
//         "name": name,
//         "role": role,
//         "companyCode": companyCode,
//       });
//     } else {
//       var id = docs.first.id;
//       await instance.collection(userCollection).doc(id).update({
//         "email": email,
//         "name": name,
//         "role": role,
//         "companyCode": companyCode,
//       });
//     }
//   }

//   static Future updateFCM(
//       {required String email, required String fcmToken}) async {
//     var id = await getDocIdByEmail(email);
//     if (id != null) {
//       await instance
//           .collection(userCollection)
//           .doc(id)
//           .update({"fcm": fcmToken});
//     }
//   }

//   static Future<String?> getCurrentEmail() async {
//     var email = await getDataInLocal(
//         key: AppLocalKeys.EMAIL, type: StorableDataType.String);
//     return email;
//   }

//   static Future<UserChatModel> getCurrentUser() async {
//     var email = await getCurrentEmail();
//     var userId = await getDocIdByEmail(email!);
//     var userModel = await getUserDetails(userId!);
//     return userModel;
//   }

//   static Future joinToGroupChatGeneral() async {
//     var email = await getCurrentEmail();
//     var userId = await getDocIdByEmail(email!);
//     var userModel = await getUserDetails(userId!);
//     var result = await instance
//         .collection(roomCollection)
//         .where("is_general", isEqualTo: true)
//         .where("type", isEqualTo: AppConstans.roomPublic)
//         .where("company_code", isEqualTo: userModel.companyCode)
//         .get();

//     var docs = result.docs;
//     var dateTime = DateTime.now().toUtc().toIso8601String();
//     if (docs.isEmpty) {
//       await createRoom(RoomModel(
//         createdAt: dateTime,
//         isGeneral: true,
//         title: "All members",
//         updatedAt: dateTime,
//         userIds: [
//           userId,
//         ],
//         type: AppConstans.roomPublic,
//         users: [userModel],
//         companyCode: userModel.companyCode,
//       ));
//     } else {
//       var response =
//           await instance.collection(roomCollection).doc(docs.first.id).get();
//       var room = RoomModel.fromJson(response.data()!, response.id);
//       if (room.userIds!.contains(userId) == false) {
//         room = room.copyWith(
//           userIds: (room.userIds ?? []) + [userId],
//           updatedAt: dateTime,
//           users: (room.users ?? []) + [userModel],
//         );
//         await instance
//             .collection(roomCollection)
//             .doc(docs.first.id)
//             .update(room.toMap());
//       }
//     }
//   }

//   static Future<String> createRoom(RoomModel roomModel) async {
//     final result =
//         await instance.collection(roomCollection).add(roomModel.toMap());
//     return result.id;
//   }

//   static Future<RoomModel?> checkRoomExist(List<String> usersId) async {
//     final result = await instance
//         .collection(roomCollection)
//         .where("userIds", isEqualTo: usersId)
//         .get();
//     if (result.docs.isNotEmpty) {
//       return RoomModel.fromJson(result.docs.first.data(), result.docs.first.id);
//     }
//     return null;
//   }

//   static Future<RoomModel> getRoomDetails(String roomId) async {
//     var result = await instance.collection(roomCollection).doc(roomId).get();
//     return RoomModel.fromJson(result.data()!, result.id);
//   }

//   static Future<void> sendAMessage(
//       {required roomId,
//       required ChatModel chatModel,
//       required List<UserChatModel> users}) async {
//     await instance
//         .collection(roomCollection)
//         .doc(roomId)
//         .collection(messageCollection)
//         .add(chatModel.toJson());
//     String dateTime = DateTime.now().toUtc().toIso8601String();
//     await instance.collection(roomCollection).doc(roomId).update({
//       "updated_at": dateTime,
//       "lasted_message": chatModel.message,
//       "meta_data": chatModel.metaData,
//     });
//     for (var user in users) {
//       await sendNotification(
//           title: "New message",
//           content: chatModel.message ?? "File",
//           fcmToken: user.fcmToken!);
//     }
//   }

//   // static Future sendNotification() {
//   //   // FirebaseMessaging.instance.sendMessage();
//   // }

//   static Future<List<UserChatModel>> getListUsers(
//       {required String companyCode, required String currentUserId}) async {
//     var result = await instance
//         .collection(userCollection)
//         .where("companyCode", isEqualTo: companyCode)
//         .get();

//     var list = result.docs
//         .map((e) => UserChatModel.fromJson(e.data(), id: e.id))
//         .toList();
//     list.removeWhere((element) => element.docId == currentUserId);
//     return list;
//   }

//   /// Stream
//   static Stream<List<RoomModel>> getListRoomsStream(
//       {required String companyCode, required String userId}) {
//     return instance
//         .collection(roomCollection)
//         .where(
//           "company_code",
//           isEqualTo: companyCode,
//         )
//         .where("userIds", arrayContainsAny: [userId])
//         .snapshots()
//         .map((event) =>
//             event.docs.map((e) => RoomModel.fromJson(e.data(), e.id)).toList());
//   }

//   static Stream<List<ChatModel>> getListMessageStream(
//       {required String roomId}) {
//     return instance
//         .collection(roomCollection)
//         .doc(roomId)
//         .collection(messageCollection)
//         .orderBy("created_at", descending: true)
//         .snapshots()
//         .map((event) =>
//             event.docs.map((e) => ChatModel.fromJson(e.data(), e.id)).toList());
//   }

//   static Future<UploadTask> uploadFileToFireStorage(File file) async {
//     var prefix = file.path.split('.').last;
//     String path = "${DateTime.now().millisecondsSinceEpoch}.$prefix";

//     Reference storageReference = storageRef.child('medias').child(path);
//     UploadTask uploadTask = storageReference.putFile(file);

//     return uploadTask;
//   }

//   static Future<void> sendNotification(
//       {required String title,
//       required String content,
//       required String fcmToken}) async {
//     try {
//       var dio = Dio();
//       dio.post(
//         "https://fcm.googleapis.com/fcm/send",
//         options: Options(
//           headers: {
//             "Content-Type": "application/json",
//             "Authorization": "key=${AppConstans.fcmServerKey}",
//           },
//         ),
//         data: {
//           "to": fcmToken,
//           "notification": {
//             "title": title,
//             "body": content,
//             "mutable_content": true,
//             "sound": "Tri-tone"
//           },
//           // "data": {
//           //   "url": "<url of media image>",
//           //   "dl": "<deeplink action on tap of notification>"
//           // }
//         },
//       );
//     } catch (e) {
//       print("error: ${e.toString()}");
//     }
//   }
// }
