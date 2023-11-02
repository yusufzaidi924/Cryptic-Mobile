import 'package:edmonscan/app/components/custom_snackbar.dart';
import 'package:edmonscan/app/data/models/UserModel.dart';
import 'package:edmonscan/app/modules/Auth/controllers/auth_controller.dart';
import 'package:edmonscan/app/repositories/user_repository.dart';
import 'package:edmonscan/utils/constants.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class FriendsController extends GetxController {
  //TODO: Implement FriendsController

  final count = 0.obs;
  final authCtrl = Get.find<AuthController>();
  final _userList = Rx<List<UserModel>>([]);
  List<UserModel> get userList => _userList.value;

  final _groupedUsers = Rx<Map<String, List<UserModel>>>({});
  Map<String, List<UserModel>> get groupedUsers => _groupedUsers.value;

  final isEdit = false.obs;
  final isAddNew = false.obs;

  onEdit(bool value) {
    isEdit.value = value;
    update();
  }

  onAddNew(bool value) async {
    isAddNew.value = value;
    await groupByFirstCharactor();
    update();
  }

  final _friendList = [].obs;
  List get friendList => _friendList.value;

  /************
   * Get All Users
   */
  onGetAllUsers() async {
    try {
      EasyLoading.show();
      _userList.value = await authCtrl.getUsers();
      await groupByFirstCharactor();
      EasyLoading.dismiss();

      update();
    } catch (e) {
      EasyLoading.dismiss();

      CustomSnackBar.showCustomErrorSnackBar(
          title: "ERROR", message: e.toString());
    }
  }

  /*******************************
   * Group User by first charactor
   */
  groupByFirstCharactor() async {
    _friendList.value = [];
    _friendList.value = List.from(authCtrl.authUser!.friends);

    // List<UserModel> users = _userList.value;
    List<UserModel> users =
        List.from(_userList.value); // Create a copy of _userList.value
    users.removeWhere((user) {
      bool isContain = authCtrl.authUser!.friends.contains("${user.id}");
      Logger().d(isContain);

      if (user.id == authCtrl.authUser!.id) // MINE
      {
        return true;
      } else if (isContain) {
        return false;
      } else {
        return !isAddNew.value;
      }
      // return (user.id == authCtrl.authUser!.id || !isContain);
    });
    users.sort((a, b) => a.firstName[0].compareTo(b.firstName[0]));
    _groupedUsers.value = {};
    users.forEach((user) {
      String firstChar = user.firstName[0].toUpperCase();
      if (!_groupedUsers.value.containsKey(firstChar)) {
        _groupedUsers.value[firstChar] = [];
      }
      _groupedUsers.value[firstChar]!.add(user);
    });
  }

  /******************************
   * onAddOne
   */
  onAddOne(int id, bool isAdd) {
    if (isAdd) {
      _friendList.value.add("${id}");
    } else {
      _friendList.value.remove("${id}");
    }
    update();
  }

  /***************************
   * On Save
   */
  onSave() async {
    String friendsData = friendList.join(",");
    Logger().d(friendsData);

    try {
      EasyLoading.show();

      final data = {
        'friends': friendsData,
      };

      final res = await UserRepository.updateUser(authCtrl.authUser!.id, data);

      Logger().i(res);
      if (res['statusCode'] == 200) {
        UserModel newUser = authCtrl.authUser!;
        newUser.friends = friendList;
        authCtrl.updateAuthUser(newUser);

        onAddNew(false);

        EasyLoading.dismiss();
        CustomSnackBar.showCustomSnackBar(
            title: "SUCCESS", message: "Your profile is updated successfully!");
      } else {
        EasyLoading.dismiss();

        CustomSnackBar.showCustomErrorSnackBar(
            title: "ERROR",
            message: res['message'] ?? Messages.SOMETHING_WENT_WRONG);
      }
    } catch (e) {
      EasyLoading.dismiss();

      Logger().e(e.toString());
      CustomSnackBar.showCustomErrorSnackBar(
          title: "ERROR", message: Messages.SOMETHING_WENT_WRONG);
    }
  }

  @override
  void onInit() {
    super.onInit();
    onGetAllUsers();
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
