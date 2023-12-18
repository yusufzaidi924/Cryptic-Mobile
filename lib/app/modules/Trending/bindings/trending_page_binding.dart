import 'package:edmonscan/app/modules/Trending/controllers/trending_page_controller.dart';
import 'package:get/get.dart';

class TrendingPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrendingPageController>(
      () => TrendingPageController(),
    );
  }
}
