import 'package:edmonscan/app/services/api.dart';
import 'package:edmonscan/config/theme/light_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';

import 'package:get/get.dart';

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
            icon: Icon(Icons.arrow_back_ios),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                size: 30,
              ),
            )
          ],
          elevation: 0,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          child: controller.users.length > 0
              ? ListView.separated(
                  itemCount: controller.users.length,
                  itemBuilder: (context, index) {
                    User user = controller.users[index];
                    return ListTile(
                      contentPadding: EdgeInsets.all(0),
                      // minVerticalPadding: 10,
                      leading: CircleAvatar(
                        backgroundColor: Color.fromARGB(132, 217, 217, 217),
                        backgroundImage:
                            NetworkImage('${Network.BASE_URL}${user.imageUrl}'),
                        radius: 30,
                      ),
                      title: Text(
                        "${user.firstName} ${user.lastName}",
                        style: TextStyle(
                          color: Color(0xFF421EB7),
                          fontSize: 16,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                          letterSpacing: -0.32,
                        ),
                      ),
                      subtitle: Text("${user.metadata?['phone'] ?? ''}"),
                      trailing: IconButton(
                        onPressed: () async {
                          await controller.onCreateChatRoom(user);
                        },
                        icon: Icon(
                          Icons.chat_outlined,
                          color: LightThemeColors.primaryColor,
                          size: 30,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                )
              : Center(
                  child: Text("No Users"),
                ),
        ),
      );
    });
  }

  _rowUser(User user) {
    return Container(
        width: double.infinity,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignCenter,
              color: Color(0xFFEDF3FC),
            ),
          ),
        ),
        child: CircleAvatar());
  }
}
