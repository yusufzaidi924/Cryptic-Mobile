import 'package:edmonscan/app/services/api.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../controllers/create_chat_controller.dart';

class CreateChatView extends GetView<CreateChatController> {
  CreateChatView({Key? key}) : super(key: key);
  CreateChatController controller = Get.put(CreateChatController());
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return GetBuilder<CreateChatController>(
        // init: CreateChatController(),
        builder: (value) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Create Chat'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                size: 30,
              ),
            )
          ],
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            height: Get.height,
            width: Get.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // APP USERS
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.people_alt_outlined,
                            color: LightThemeColors.primaryColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "App Users",
                            style: TextStyle(
                              color: Color.fromARGB(255, 110, 110, 110),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    controller.users.length > 0
                        ? ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.users.length,
                            itemBuilder: (context, index) {
                              User user = controller.users[index];
                              return ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                // minVerticalPadding: 10,
                                leading: user.imageUrl != null
                                    ? CircleAvatar(
                                        backgroundColor: const Color.fromARGB(
                                            132, 217, 217, 217),
                                        backgroundImage: NetworkImage(
                                            '${Network.BASE_URL}${user.imageUrl}'),
                                        radius: 30,
                                      )
                                    : const CircleAvatar(
                                        backgroundColor: Colors.white,
                                        backgroundImage: AssetImage(
                                            'assets/images/default.png'),
                                        radius: 30,
                                      ),
                                title: Text(
                                  "${user.firstName ?? 'Criptacy'} ${user.lastName ?? 'User'}",
                                  style: const TextStyle(
                                    color: Color(0xFF421EB7),
                                    fontSize: 16,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    height: 1.1,
                                    letterSpacing: -0.32,
                                  ),
                                ),
                                subtitle:
                                    Text("${user.metadata?['phone'] ?? ''}"),
                                trailing: IconButton(
                                  onPressed: () async {
                                    // await controller.onCreateChatRoom(user);
                                    await controller.onTapChat(user);
                                  },
                                  icon: const Icon(
                                    Icons.chat_outlined,
                                    color: LightThemeColors.primaryColor,
                                    size: 30,
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Divider();
                            },
                          )
                        : const Center(
                            child: Text("No Users"),
                          ),
                  ],
                ),

                // CONTACT LIST USERS
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.contact_phone_outlined,
                        color: LightThemeColors.primaryColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Contacts',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 110, 110, 110),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                controller.isContactGrant
                    ? controller.contacts.isNotEmpty
                        ? Expanded(
                            child: ListView.separated(
                            itemCount: controller.contacts.length,
                            itemBuilder: (context, index) {
                              Contact contact = controller.contacts[index];
                              // Logger().d(contact.toJson());
                              return contact.phones.isNotEmpty
                                  ? ListTile(
                                      contentPadding: const EdgeInsets.all(0),
                                      // minVerticalPadding: 10,
                                      leading: (contact.photoFetched &&
                                                  contact.photo != null) ||
                                              (contact.thumbnailFetched &&
                                                  contact.thumbnail != null)
                                          ? CircleAvatar(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      132, 217, 217, 217),
                                              backgroundImage: MemoryImage(
                                                  contact.photoOrThumbnail!),
                                              radius: 30,
                                            )
                                          : const CircleAvatar(
                                              backgroundColor: Colors.white,
                                              backgroundImage: AssetImage(
                                                  'assets/images/default.png'),
                                              radius: 30,
                                            ),
                                      title: Text(
                                        "${contact.displayName}",
                                        style: const TextStyle(
                                          color: Color(0xFF421EB7),
                                          fontSize: 16,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w600,
                                          height: 1.1,
                                          letterSpacing: -0.32,
                                        ),
                                      ),
                                      subtitle:
                                          Text("${contact.phones[0].number}"),
                                      trailing: IconButton(
                                        onPressed: () async {
                                          // await controller.onCreateChatRoom(user);
                                          await controller.onCreateContactChat(
                                              "${contact.phones[0].number}");
                                        },
                                        icon: const Icon(
                                          Icons.chat_outlined,
                                          color: LightThemeColors.primaryColor,
                                          size: 30,
                                        ),
                                      ),
                                    )
                                  : Container();
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Divider();
                            },
                          ))
                        : Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Center(
                              child: Text("No Contacts"),
                            ),
                          )
                    : Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Center(
                          child: Text(
                            "Please grant permission to access to your contact",
                            style: TextStyle(
                                // fontStyle: FontStyle.italic,
                                // color: const Color.fromARGB(255, 143, 143, 143)),
                                ),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      );
    });
  }

  _rowUser(User user) {
    return Container(
        width: double.infinity,
        decoration: const ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignCenter,
              color: Color(0xFFEDF3FC),
            ),
          ),
        ),
        child: const CircleAvatar());
  }
}
