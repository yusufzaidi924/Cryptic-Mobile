import 'dart:io';

import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/modules/CallPage/controllers/call_page_controller.dart';
import 'package:edmonscan/app/modules/CallPage/views/testCall.dart';
import 'package:edmonscan/app/routes/app_pages.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:edmonscan/utils/chatUtil/chat_core.dart';
import 'package:edmonscan/utils/chatUtil/chat_util.dart';
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
    update();
  }

  /*************************************
   * Init Room
   */
  initRoom(Room? room) async {
    if (room == null) return _messages.bindStream(Stream.empty());

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
                leading: Icon(
                  Icons.camera_alt_outlined,
                  color: LightThemeColors.primaryColor,
                ),
                title: Text('Take a Photo'),
                onTap: () {
                  Get.back();
                  handleImageSelection(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library_sharp,
                  color: LightThemeColors.primaryColor,
                ),
                title: Text('From Gallery'),
                onTap: () {
                  Get.back();
                  handleImageSelection(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.folder_open_outlined,
                  color: LightThemeColors.primaryColor,
                ),
                title: Text('File'),
                onTap: () {
                  Get.back();
                  handleFileSelection();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.close,
                  color: LightThemeColors.primaryColor,
                ),
                title: Text('Cancel'),
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
        // final me = getCurrentUser(room: room);

        // // Send Notification
        // await controller.sendNotification(
        //   room,
        //   "${me?.firstName} ${me?.lastName}",
        //   "Sent you a media file...",
        //   avatar: FirebaseAuth.instance.currentUser!.photoURL,
        // );
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
        // await controller.sendNotification(
        //   room,
        //   "${me?.firstName} ${me?.lastName}",
        //   "Sent you an image...",
        //   avatar: FirebaseAuth.instance.currentUser!.photoURL,
        //   image: uri,
        // );
        // }

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
      int time = DateTime.now().millisecondsSinceEpoch;
      User? otherUser = getOtherUser(room: room!);
      Get.delete<CallPageController>();
      Get.toNamed(Routes.CALL_PAGE,
          arguments: {'user': otherUser, 'roomID': "${room!.id}${time}"});
      // Navigator.push(
      //   Get.context!,
      //   MaterialPageRoute(builder: (context) => JoinChannelVideo()),
      // );
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
