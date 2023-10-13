import 'package:permission_handler/permission_handler.dart';

Future<PermissionStatus> checkCameraPermission() async {
  return await Permission.camera.status;
}

Future<PermissionStatus> checkGalleryPermission() async {
  return await Permission.camera.status;
}

Future<PermissionStatusEnum> requestCameraPermission() async {
  // Check if camera permission is granted
  var status = await Permission.camera.status;

  if (status.isGranted) {
    // Permission is already granted
    return PermissionStatusEnum.GRANTED;
  } else {
    // Request camera permission
    if (await Permission.camera.request().isGranted) {
      // Permission granted by user
      return PermissionStatusEnum.GRANTED;
    } else {
      // Permission denied by user
      return PermissionStatusEnum.DENIED;
    }
  }
}

Future<PermissionStatusEnum> requestGalleryPermission() async {
  // Check if camera permission is granted
  var status = await Permission.photos.status;

  if (status.isGranted) {
    // Permission is already granted
    return PermissionStatusEnum.GRANTED;
  } else {
    // Request camera permission
    if (await Permission.camera.request().isGranted) {
      // Permission granted by user
      return PermissionStatusEnum.GRANTED;
    } else {
      // Permission denied by user
      return PermissionStatusEnum.DENIED;
    }
  }
}

enum PermissionStatusEnum {
  GRANTED,
  DENIED,
  FOREVER_DENIED,
}
