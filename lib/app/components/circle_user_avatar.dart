// import 'package:edmonscan
// /utils/constants.dart';
// import 'package:flutter/material.dart';

// import 'package:logger/logger.dart';

// Widget CircleUserAvatar({
//   double radius = 26,
//   // types.User? user,
//   bool visibleStatus = true,
// }) {
//   UserStatus status = UserStatus.OFFLINE;
//   Color backgColor = backgroundColor2;
//   String? img;
//   String? name;
//   bool isPrivate = false;
//   if (user != null) {
//     // User Status
//     if (user.metadata != null) {
//       if (user.metadata!['status'] != null) {
//         status = getUserStatus(user.metadata!['status']);
//       }
//       isPrivate = user.metadata![PrivacySettingKey.COLLECTION]
//               ?[PrivacySettingKey.PRIVATE_ACCOUNT] ??
//           false;
//       // Logger().e("Is Private", isPrivate);
//     }

//     // Image
//     img = user.imageUrl;

//     // Name
//     name = user.firstName;

//     if (img == null) {
//       // Color
//       backgColor = getUserAvatarNameColor(user);
//     }
//   }

//   return Stack(
//     children: [
//       CircleAvatar(
//         radius: radius,
//         backgroundColor: backgColor,
//         backgroundImage: img != null ? NetworkImage(img) : null,
//         child: img != null
//             ? Container()
//             : Text(
//                 name != null ? name[0].toUpperCase() : "",
//                 style: const TextStyle(
//                   color: white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//       ),
//       Positioned(
//         top: 0,
//         right: 3,
//         child: Visibility(
//           visible: visibleStatus,
//           child: CircleAvatar(
//             backgroundColor: status == UserStatus.ONLINE
//                 ? Color(0xff6AFF64)
//                 : status == UserStatus.OFFLINE
//                     ? Colors.yellow
//                     : Colors.grey,
//             radius: 6,
//           ),
//         ),
//       ),
//       Positioned(
//         bottom: 0,
//         right: 0,
//         child: Visibility(
//           visible: isPrivate,
//           child: const Icon(
//             Icons.lock,
//             color: white,
//             size: 16,
//           ),
//         ),
//       ),
//     ],
//   );
// }
