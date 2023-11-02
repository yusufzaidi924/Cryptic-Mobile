import 'package:get/get.dart';

import '../data/models/ProjectModel.dart';
import '../modules/AccountSecurity/bindings/account_security_binding.dart';
import '../modules/AccountSecurity/views/account_security_view.dart';
import '../modules/AddNewBank/bindings/add_new_bank_binding.dart';
import '../modules/AddNewBank/views/add_new_bank_view.dart';
import '../modules/AddNewCard/bindings/add_new_card_binding.dart';
import '../modules/AddNewCard/views/add_new_card_view.dart';
import '../modules/AffiliatePage/bindings/affiliate_page_binding.dart';
import '../modules/AffiliatePage/views/affiliate_page_view.dart';
import '../modules/Auth/bindings/auth_binding.dart';
import '../modules/Auth/views/sign_in_view.dart';
import '../modules/Auth/views/sign_up_view.dart';
import '../modules/Auth/views/signup_detail_view.dart';
import '../modules/Auth/views/verify_result_view.dart';
import '../modules/Auth/views/verify_view.dart';
import '../modules/CallPage/bindings/call_page_binding.dart';
import '../modules/CallPage/views/call_page_view.dart';
import '../modules/ChatList/bindings/chat_list_binding.dart';
import '../modules/ChatList/bindings/chat_list_binding.dart';
import '../modules/ChatList/views/chat_list_view.dart';
import '../modules/ChatList/views/chat_list_view.dart';
import '../modules/ChatRoom/bindings/chat_room_binding.dart';
import '../modules/ChatRoom/views/chat_room_view.dart';
import '../modules/ConfirmPayment/bindings/confirm_payment_binding.dart';
import '../modules/ConfirmPayment/views/confirm_payment_view.dart';
import '../modules/CreateChat/bindings/create_chat_binding.dart';
import '../modules/CreateChat/views/create_chat_view.dart';
import '../modules/Friends/bindings/friends_binding.dart';
import '../modules/Friends/views/friends_view.dart';
import '../modules/Home/bindings/home_binding.dart';
import '../modules/Home/views/home_view.dart';
import '../modules/IncomingCall/bindings/incoming_call_binding.dart';
import '../modules/IncomingCall/views/incoming_call_view.dart';
import '../modules/MnemonicPage/bindings/mnemonic_page_binding.dart';
import '../modules/MnemonicPage/views/mnemonic_page_view.dart';
import '../modules/MyPMPage/bindings/my_p_m_page_binding.dart';
import '../modules/MyPMPage/views/my_p_m_page_view.dart';
import '../modules/MyProfile/bindings/my_profile_binding.dart';
import '../modules/MyProfile/views/my_profile_view.dart';
import '../modules/MyQR/bindings/my_q_r_binding.dart';
import '../modules/MyQR/views/my_q_r_view.dart';
import '../modules/OnBoard/bindings/on_board_binding.dart';
import '../modules/OnBoard/views/on_board_view.dart';
import '../modules/PaymentResultPage/bindings/payment_result_page_binding.dart';
import '../modules/PaymentResultPage/views/payment_result_page_view.dart';
import '../modules/PhotoPreview/bindings/photo_preview_binding.dart';
import '../modules/PhotoPreview/views/photo_preview_view.dart';
import '../modules/RequestPayment/bindings/request_payment_binding.dart';
import '../modules/RequestPayment/views/request_payment_view.dart';
import '../modules/SettingPage/bindings/setting_page_binding.dart';
import '../modules/SettingPage/views/setting_page_view.dart';
import '../modules/Splash/bindings/splash_binding.dart';
import '../modules/Splash/views/splash_view.dart';
import '../modules/TopUp/bindings/top_up_binding.dart';
import '../modules/TopUp/views/top_up_view.dart';
import '../modules/TransferPage/bindings/transfer_page_binding.dart';
import '../modules/TransferPage/views/transfer_page_view.dart';
import '../modules/UserProfile/bindings/user_profile_binding.dart';
import '../modules/UserProfile/views/user_profile_view.dart';
import '../modules/Welcome/bindings/welcome_binding.dart';
import '../modules/Welcome/views/welcome_view.dart';
import '../modules/WithdrawPage/bindings/withdraw_page_binding.dart';
import '../modules/WithdrawPage/views/withdraw_page_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SIGN_IN;
  static final routes = [
    GetPage(
      name: _Paths.PHOTO_PREVIEW,
      page: () => const PhotoPreviewView(),
      binding: PhotoPreviewBinding(),
    ),
    GetPage(
      name: _Paths.ON_BOARD,
      page: () => OnBoardView(),
      binding: OnBoardBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_IN,
      page: () => SignInView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_UP,
      page: () => SignUpView(),
      binding: AuthBinding(),
    ),

    GetPage(
      name: _Paths.VERIFY,
      page: () => VerifyView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP_DETAIL,
      page: () => SignupDetailView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.VERIFY_RESULT,
      page: () => VerifyResultView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.WELCOME,
      page: () => WelcomeView(),
      binding: AuthBinding(),
    ),

    // GetPage(
    //   name: _Paths.UPLOAD_PAGE,
    //   page: (ProjectModel projectModel) => UploadPageView(project: project),
    //   binding: UploadPageBinding(),
    // ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      children: [
        GetPage(
          name: _Paths.HOME,
          page: () => HomeView(),
          binding: HomeBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.TOP_UP,
      page: () => TopUpView(),
      binding: TopUpBinding(),
    ),
    GetPage(
      name: _Paths.MY_P_M_PAGE,
      page: () => MyPMPageView(),
      binding: MyPMPageBinding(),
    ),
    GetPage(
      name: _Paths.ADD_NEW_CARD,
      page: () => AddNewCardView(),
      binding: AddNewCardBinding(),
    ),
    GetPage(
      name: _Paths.WITHDRAW_PAGE,
      page: () => WithdrawPageView(),
      binding: WithdrawPageBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT_RESULT_PAGE,
      page: () => const PaymentResultPageView(),
      binding: PaymentResultPageBinding(),
    ),
    GetPage(
      name: _Paths.SETTING_PAGE,
      page: () => SettingPageView(),
      binding: SettingPageBinding(),
    ),
    GetPage(
      name: _Paths.USER_PROFILE,
      page: () => UserProfileView(),
      binding: UserProfileBinding(),
    ),
    GetPage(
      name: _Paths.TRANSFER_PAGE,
      page: () => TransferPageView(),
      binding: TransferPageBinding(),
    ),
    GetPage(
      name: _Paths.CONFIRM_PAYMENT,
      page: () => ConfirmPaymentView(),
      binding: ConfirmPaymentBinding(),
    ),
    GetPage(
      name: _Paths.REQUEST_PAYMENT,
      page: () => RequestPaymentView(),
      binding: RequestPaymentBinding(),
    ),
    GetPage(
      name: _Paths.MY_PROFILE,
      page: () => MyProfileView(),
      binding: MyProfileBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT_SECURITY,
      page: () => AccountSecurityView(),
      binding: AccountSecurityBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_LIST,
      page: () => ChatListView(),
      binding: ChatListBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_CHAT,
      page: () => CreateChatView(),
      binding: CreateChatBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_ROOM,
      page: () => ChatRoomView(),
      binding: ChatRoomBinding(),
    ),
    GetPage(
      name: _Paths.CALL_PAGE,
      page: () => CallPageView(),
      binding: CallPageBinding(),
    ),
    GetPage(
      name: _Paths.INCOMING_CALL,
      page: () => IncomingCallView(),
      binding: IncomingCallBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.MNEMONIC_PAGE,
      page: () => MnemonicPageView(),
      binding: MnemonicPageBinding(),
    ),
    GetPage(
      name: _Paths.MY_Q_R,
      page: () => MyQRView(),
      binding: MyQRBinding(),
    ),
    GetPage(
      name: _Paths.FRIENDS,
      page: () => FriendsView(),
      binding: FriendsBinding(),
    ),
    GetPage(
      name: _Paths.AFFILIATE_PAGE,
      page: () => AffiliatePageView(),
      binding: AffiliatePageBinding(),
    ),
    GetPage(
      name: _Paths.ADD_NEW_BANK,
      page: () => AddNewBankView(),
      binding: AddNewBankBinding(),
    ),
  ];
}
