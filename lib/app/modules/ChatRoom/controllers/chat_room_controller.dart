import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/modules/CallPage/controllers/call_page_controller.dart';
import 'package:edmonscan/app/modules/CallPage/views/testCall.dart';
import 'package:edmonscan/app/repositories/app_repository.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:edmonscan/app/services/api.dart';
import 'package:edmonscan/app/services/fcm_helper.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:edmonscan/utils/chatUtil/chat_core.dart';
import 'package:edmonscan/utils/chatUtil/chat_util.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class ChatRoomController extends GetxController {
  //TODO: Implement ChatRoomController
  final authCtrl = Get.find<AuthController>();
  final TextEditingController reportController = TextEditingController();

  final count = 0.obs;

  final _room = Rxn<Room>();
  Room? get room => _room.value;

  final _messages = Rx<List<Message>>([]);
  List<Message> get messages => _messages.value;

  @override
  void onInit() {
    super.onInit();
    final params = Get.arguments;
    _room.value = params['room'];
    initRoom(room);
    clearUnreadCount();

    checkUserBlock(room);
    update();
  }

  /*************************************
   * Init Room
   */
  initRoom(Room? room) async {
    if (room == null) return _messages.bindStream(const Stream.empty());

    try {
      final streamMessages = MyChatCore.instance.messages(room);
      // await MyChatCore.instance.users();
      _messages.bindStream(streamMessages);

      _messages.listen((e) {
        // print("$e");
        Logger().i(e);
        update();
      });
    } catch (e) {
      print("$e");
      Logger().e('$e');
    }
  }

  /*****************************
   * Handle Attachment Click
   */
  void handleAttachmentPressed() {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.camera_alt_outlined,
                  color: LightThemeColors.primaryColor,
                ),
                title: const Text('Take a Photo'),
                onTap: () {
                  Get.back();
                  handleImageSelection(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library_sharp,
                  color: LightThemeColors.primaryColor,
                ),
                title: const Text('From Gallery'),
                onTap: () {
                  Get.back();
                  handleImageSelection(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.folder_open_outlined,
                  color: LightThemeColors.primaryColor,
                ),
                title: const Text('File'),
                onTap: () {
                  Get.back();
                  handleFileSelection();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.close,
                  color: LightThemeColors.primaryColor,
                ),
                title: const Text('Cancel'),
                onTap: () {
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /******************************
   * Handle File Selectioin
   */
  void handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      EasyLoading.show(status: "Uploading...");
      final name = result.files.single.name;
      final filePath = result.files.single.path!;
      final file = File(filePath);

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = PartialFile(
          mimeType: lookupMimeType(filePath),
          name: name,
          size: result.files.single.size,
          uri: uri,
        );

        MyChatCore.instance.sendMessage(message, room!.id);
        await updateChatRoom("📒 Shared a File");

        // SEND NOTIFICATION
        final me = authCtrl.chatUser;
        await this.sendNotification(
          room!,
          "${me?.firstName} ${me?.lastName}",
          "Sent you a media file...",
          avatar: me?.imageUrl != null
              ? '${Network.BASE_URL}${me!.imageUrl}'
              : null,
        );
        EasyLoading.dismiss();
      } catch (e) {
        EasyLoading.dismiss();
        CustomSnackBar.showCustomErrorSnackBar(
            title: 'Failed!', message: e.toString());
      } finally {
        EasyLoading.dismiss();
      }
    }
  }

  /*****************************
   * Handle Image Selection
   */
  void handleImageSelection(ImageSource source) async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: source,
    );

    if (result != null) {
      EasyLoading.show(status: "Uploading...");

      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.name;

      // Call detectNsfw to check for nsfw images
      // bool isNSFW = await ImageModeration.detectNsfw(file);

      try {
        final reference = FirebaseStorage.instance.ref(name);

        // If image is nsfw, blur the image before uploading it to Firebase storage
        // if (isNSFW) {
        // final blurredImage = await exchangeImage();

        // Overwrite the original bytes variable with the blurred image
        // var builder = BytesBuilder();
        // builder.add(blurredImage);
        // var newFile = File(Path.basename(result.path));
        // await newFile.writeAsBytes(builder.toBytes());

        // await reference.putFile(blurredImage);

        //   CustomSnackBar.showCustomErrorSnackBar(
        //       title: 'NSFW content Detected',
        //       message: "NSFW content is detected in your image!");
        // } else {
        await reference.putFile(file);

        final uri = await reference.getDownloadURL();

        final message = PartialImage(
          height: image.height.toDouble(),
          name: name,
          size: size,
          uri: uri,
          width: image.width.toDouble(),
        );

        MyChatCore.instance.sendMessage(message, room!.id);
        await updateChatRoom("📒 Shared an image");

        // final me = getCurrentUser(room: room);

        // // Send Notification
        final me = authCtrl.chatUser;
        await this.sendNotification(room!, "${me?.firstName} ${me?.lastName}",
            "📷 Sent you an image...",
            avatar: me?.imageUrl != null
                ? '${Network.BASE_URL}${me!.imageUrl}'
                : null);

        EasyLoading.dismiss();
      } catch (e) {
        EasyLoading.dismiss();

        CustomSnackBar.showCustomErrorSnackBar(
            title: 'Failed!', message: e.toString());
      } finally {
        EasyLoading.dismiss();
      }
    }
  }

  /**************************
   * Handle Message Tap
   */
  void handleMessageTap(Message message) async {
    if (message is FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              messages.indexWhere((element) => element.id == message.id);
          final updatedMessage = (messages[index] as FileMessage).copyWith(
            isLoading: true,
          );

          messages[index] = updatedMessage;
          update();
          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              messages.indexWhere((element) => element.id == message.id);
          final updatedMessage = (messages[index] as FileMessage).copyWith(
            isLoading: null,
          );

          messages[index] = updatedMessage;
          update();
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  /**************************
   * Handle Preview Data
   */
  void handlePreviewDataFetched(
    TextMessage message,
    PreviewData previewData,
  ) {
    final index = messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (messages[index] as TextMessage).copyWith(
      previewData: previewData,
    );

    messages[index] = updatedMessage;
    update();
  }

  /*********************************
   * Handle Send Message Button
   */
  void handleSendPressed(PartialText message) async {
    // final textMessage = TextMessage(
    //   author: authCtrl.chatUser!,
    //   createdAt: DateTime.now().millisecondsSinceEpoch,
    //   id: const Uuid().v4(),
    //   text: message.text,
    // );

    MyChatCore.instance.sendMessage(message, room!.id);
    await updateChatRoom(message.text);

    // SEND NOTIFICATION
    final me = authCtrl.chatUser;
    await this.sendNotification(
        room!, "${me?.firstName} ${me?.lastName}", "${message.text}",
        avatar:
            me?.imageUrl != null ? '${Network.BASE_URL}${me!.imageUrl}' : null);
  }

  /*******************************
   * Clear Unread Count
   */
  clearUnreadCount() async {
    if (room == null) return;
    // Update room for unread message
    final updateRoom = room!.copyWith();

    Map<String, dynamic>? metadata = updateRoom.metadata;
    if (metadata != null) {
      metadata["messageCount"] =
          metadata["messageCount"] - metadata[authCtrl.chatUser!.id];
      metadata[authCtrl.chatUser!.id] = 0;
    }
    final updateRoom1 = room!.copyWith(metadata: metadata);
    MyChatCore.instance.updateRoom(updateRoom1);
  }

  /*******************************
   * Update Chat Room
   */
  updateChatRoom(String newMsg) async {
    if (room == null) return;
    // Update room for unread message
    final updateRoom = room!.copyWith();

    Map<String, dynamic>? metadata = updateRoom.metadata;
    print(newMsg);
    if (metadata == null) {
      metadata = {
        "${authCtrl.chatUser!.id}": 1,
        "messageCount": 1,
        "lastMessage": newMsg,
      };
    } else {
      metadata[authCtrl.chatUser!.id] = metadata["messageCount"] + 1;
      metadata["messageCount"] = metadata["messageCount"] + 1;
      metadata["lastMessage"] = newMsg;
    }
    final updateRoom1 = room!.copyWith(metadata: metadata);
    MyChatCore.instance.updateRoom(updateRoom1);
  }

  /***********************************
   * On Call
   */
  onCall() async {
    if (room != null) {
      User? otherUser = getOtherUser(room: room!);
      // String channelName = DateTime.now().millisecondsSinceEpoch.toString();
      String channelName = 'criptacyvideocallroom';
      String? token = await getTokenFromServer(channelName);
      if (token != null) {
        Get.delete<CallPageController>();
        Get.toNamed(Routes.CALL_PAGE, arguments: {
          'user': otherUser,
          'token': token,
          'channelID': channelName,
          'role': 'publisher'
        });
      }
      // Navigator.push(
      //   Get.context!,
      //   MaterialPageRoute(builder: (context) => JoinChannelVideo()),
      // );
    }
  }

  /*****************
   * Get Call Token
   */
  Future<String?> getTokenFromServer(String channelName) async {
    try {
      final data = {
        'channelId': channelName,
        'uid': authCtrl.chatUser?.id ?? 0,
        'role': 'publisher'
      };

      final res = await AppRepository.getCallToken(data);
      Logger().i(res);
      if (res['statusCode'] == 200) {
        String token = res['data']['token'];
        Logger().i(token);
        return token;
      } else {
        CustomSnackBar.showCustomErrorSnackBar(
            title: "ERROR",
            message: res['message'] ?? Messages.SOMETHING_WENT_WRONG);
        return null;
      }
    } catch (e) {
      Logger().e(e.toString());
      CustomSnackBar.showCustomErrorSnackBar(
          title: "ERROR", message: Messages.SOMETHING_WENT_WRONG);
      return null;
    }
  }

  /*******************
   * Send Notification
   */
  sendNotification(Room room, String title, String message,
      {String? avatar, String? image}) async {
    User? toUser = getOtherUser(room: room);
    if (toUser != null &&
        toUser.metadata != null &&
        toUser.metadata!['fcm_token'] != null) {
      String fcmToken = toUser.metadata!['fcm_token'].toString();

      // Logger().i("Send Notification FCM", fcmToken);
      FcmHelper.sendPushNotification(
        fcmToken: fcmToken,
        title: title,
        message: message,
        largeIcon: avatar,
        bigImg: image,
        // largeIcon: otherUser.imageUrl,
      );
    }
  }

  /*****************************
   * Delete Chat Room
   */
  deleteRoom() async {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Chat Room'),
          content:
              const Text('Are you sure you want to delete this chat room?'),
          actions: [
            TextButton(
              onPressed: () {
                // Dismiss dialog
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  EasyLoading.show();
                  if (room == null) return;
                  final requestRef = FirebaseFirestore.instance
                      .collection(DatabaseConfig.CHAT_COLLECTION)
                      .doc(room!.id);
                  await requestRef.delete();
                  EasyLoading.dismiss();

                  Get.back();
                } catch (e) {
                  Logger().e(e);

                  EasyLoading.dismiss();
                  CustomSnackBar.showCustomErrorSnackBar(
                      title: "ERROR", message: e.toString());
                }
                // Dismiss dialog
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  /**************************
   * OnReportUser
   */
  onReportUser() {
    Get.defaultDialog(
      title: 'Report User',
      content: TextField(
        controller: reportController,
        maxLines: 5,
        minLines: 2,
        decoration: const InputDecoration(
          hintText: 'Enter report content',
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            // Submit report content
            await submitReport();
            // Close dialog box
            Get.back();
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }

  /***********************
   * Submit Report
   */
  Future<void> submitReport() async {
    if (room == null) return;
    try {
      EasyLoading.show();
      Get.back();

      User? otherUser = getOtherUser(room: room!);
      String content = reportController.text;

      await FirebaseFirestore.instance
          .collection(DatabaseConfig.REPORT_COLLECTION)
          .add({
        'fromUID': authCtrl.chatUser!.id.toString(),
        'reportUID': otherUser!.id.toString(),
        'content': content,
        'createdAt': FieldValue.serverTimestamp(),
      });
      reportController.text = "";
      EasyLoading.dismiss();
      await Future.delayed(const Duration(seconds: 1));

      CustomSnackBar.showCustomSnackBar(
          title: "SUCCESS", message: "Your report is submitted successfully!");
    } catch (e) {
      Logger().e(e);
      EasyLoading.dismiss();

      CustomSnackBar.showCustomErrorSnackBar(
          title: "ERROR", message: e.toString());
    }
  }

  final _isBlocked = false.obs;
  bool get isBlocked => _isBlocked.value;

  /********************
   * Block User
   */
  blockUser() async {
    if (room == null) return;
    User? user = getOtherUser(room: room!);
    if (user == null) return;
    EasyLoading.show();
    try {
      final CollectionReference usersRef =
          FirebaseFirestore.instance.collection(DatabaseConfig.USER_COLLECTION);

      User? reportUser = authCtrl.chatUser;
      if (reportUser != null) {
        Map<String, dynamic>? metadata = reportUser.metadata;
        if (metadata!['blockList'] == null) {
          metadata['blockList'] = [user.id];
        } else {
          metadata['blockList'].add(user.id);
        }

        usersRef.doc(authCtrl.chatUser!.id).update({"metadata": metadata});

        EasyLoading.dismiss();
        CustomSnackBar.showCustomSnackBar(
          title: 'Success',
          message: "This user is blocked!",
        );
        _isBlocked.value = true;
        update();
      }
    } catch (e) {
      EasyLoading.dismiss();
      CustomSnackBar.showCustomErrorSnackBar(
          title: 'Failed!', message: e.toString());
    }
  }

  /********************
   * Block User
   */
  unblockUser() async {
    if (room == null) return;
    User? user = getOtherUser(room: room!);
    if (user == null) return;
    EasyLoading.show();
    try {
      final CollectionReference usersRef =
          FirebaseFirestore.instance.collection(DatabaseConfig.USER_COLLECTION);

      User? reportUser = authCtrl.chatUser;
      if (reportUser != null) {
        Map<String, dynamic>? metadata = reportUser.metadata;
        if (metadata!['blockList'] == null) {
        } else {
          metadata['blockList'].remove(user.id);
        }

        usersRef.doc(authCtrl.chatUser!.id).update({"metadata": metadata});

        EasyLoading.dismiss();
        CustomSnackBar.showCustomSnackBar(
          title: 'Success',
          message: "This user is unblocked successfully!",
        );

        _isBlocked.value = false;

        update();
      }
    } catch (e) {
      EasyLoading.dismiss();
      CustomSnackBar.showCustomErrorSnackBar(
          title: 'Failed!', message: e.toString());
    }
  }

  /***********************
   * Check Block status
   */
  checkUserBlock(Room? room) async {
    User? myUser = authCtrl.chatUser;
    if (room == null || myUser == null) return;

    User? otherUser = getOtherUser(room: room);
    if (myUser.metadata!['blockList'] != null) {
      if (myUser.metadata!['blockList'] != null) {
        final blockList = myUser.metadata!['blockList'] as List;
        if (blockList.contains(otherUser!.id)) {
          _isBlocked.value = true;
          update();
        }
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
