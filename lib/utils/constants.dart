import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:flutter/material.dart';

class MyColors {
// Main Screen Background Color
  static const backgroundColor = Color(0xff000000);

// Header Box Background Color
  static const backgroundColor1 = Color(0xff1D2127);

// Inputbox Background Color
  static const backgroundColor2 = Color(0xff12110E);

  // Pink Button Color
  static const pinkButtonColor = Color.fromARGB(255, 255, 21, 21);
  static const primaryButtonColor = Color.fromARGB(255, 90, 211, 19);
  static const yellowButtonColor = Color.fromARGB(255, 226, 140, 11);
// Primary  Text Color
  static const textColor = Colors.white;

  static const white = Colors.white;
  static const red = Colors.red;

// Disabel text color
  static const textColor1 = Color(0xff555555);

// Border Color
  static const borderColor = Color(0xff262D1F);
  static const grey = Color(0xff707070);

// Selected Message Color
  static const selectedMsgColor = Color.fromARGB(255, 90, 90, 92);
}

enum LoginMethod {
  EMAIL,
  GOOGLE,
  APPLE,
  FACEBOOK,
  TWITTER,
  OTHER,
}

enum UserStatus {
  ONLINE,
  AWAY,
  OFFLINE,
}

class DatabaseConfig {
  static const String PROJECT_COLLECTION = "projects";
  static const String STORAGE_IMAGE_COLLECTION = "testimages";
  static const String PAPER_COLLECTION = "papers";
  static const String FEED_ROOM_NAME = "Feed";

  static const String USER_COLLECTION = "users";
  static const String CHAT_COLLECTION = "rooms";
  static const String CHAT_REQUEST_COLLECTION = "requests";

  static const String REPORT_COLLECTION = "reports";
  static const String FEED_ROOM_ID = "8ITdjr6jCtv1xJ9hpWk1";
  static const String LOGIN_LOG_COLLECTION = "loginlogs";
  static const String PAYMENTS_COLLECTION = "payments";
  static const String SUPPORT_COLLECTION = "supports";
  static const String BAD_MESSAGES_COLLECTION = "bad_messages";
  static const String CONTENTS_REPORTS_COLLECTION = "content_reports";
}

class Messages {
  static const String BLOCKED_MESSAGE =
      "Unfortunately, You can't send message to this user because you were blocked.";
  static const String BLOCK_MESSAGE =
      "Unfortunately, You can't send message to this user because you blocked this user.";
  static const String SOMETHING_WENT_WRONG = "Something went wrong!";
  static const String WARNING_UPLOAD_DOCUMENT = "Please upload documents!";
  // static const String SUCCESS_LOGIN = 'Sign'
}

class NotificationSettingKey {
  static const String COLLECTION = "notification";
  static const String PUSH_NOTIFICATION = "pushNotification";
  static const String LIKES = "likes";
  static const String COMMENTS = "comments";
  static const String LOCATION_SHARING = "locationSharing";
  static const String SUPPORT_MESSAGES = "supportMsg";
  static const String MESSAGE_FROM_FRIENDS = "msgFromFriends";
  static const String UPCOMING_EVENTS = "upcompingEvents";
  static const String MENTIONS_FROM_FRIENDS = "mentionFromFriends";
  static const String EVENT_VENUE_RATING = "eventVenueRating";
}

class PrivacySettingKey {
  static const String COLLECTION = "privacy";
  static const String PRIVATE_ACCOUNT = "privateAccount";
  static const String ALLOW_LIKES_FROM_FRIENDS = "allowLikesFromFriends";
  static const String ALLOW_COMMENTS_FROM_FRIENDS = "allowCommentsFromFriends";
  static const String ALLOW_NSFW_CONTENTS = "allowNSFWContents";
  static const String AGREE_TERMS = "agreeTerms";
}

class UserMetadataKey {
  static const String FRIEND_PENDING_LIST = "friendPendingList";
  static const String FRIEND_LIST = "friendList";
}

class SecuritySettingKey {
  static const String COLLECTION = "security";
  static const String TWO_FACTOR_AUTH = "twofactor";
}

class AboutUsLinks {
  static const String PRIVACY_POLICY =
      'https://www.privacypolicies.com/live/3c365298-ca3a-414e-a962-8562f688c930';
  static const String TERMS_CONDITION = 'https://jmp.sh/RBaN3hgu';
  static const String ABOUT_US =
      'https://allstarseatingnavigation.com/About.html';
  static const String REFUND_POLICY =
      'https://jumpshare.com/v/YJPIXmYFoRoKW06QbIuN';
}

class ArgoraConf {
  static const APPID = "852824acc30b414494607fab503ae55c";
  static const TOKEN = "0b25c933ddfb49298ebdca7a9fe5b04f";
}

class CryptoConf {
  // BITCOIN TESTNET
  // static const BITCOIN_NETWORK = Network.Testnet;
  // static const BITCOIN_PATH = "m/84'/1'/0'";
  // static const BITCOIN_PASSWORD = "password";
  static const BITCOIN_NETWORK = Network.Bitcoin;
  static const BITCOIN_PATH = "m/84'/0'/0'";
  static const BITCOIN_PASSWORD = "password";
  static const BITCOIN_MIN_AMOUNT = 0.00000001;
  static const BITCOIN_DIGIT = 100000000;
}
