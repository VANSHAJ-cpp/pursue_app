import 'package:get/get.dart';

class ScreenController extends GetxController {
  final screenButton = 0.obs;
  void onScreenBtnTap(int index) {
    screenButton.value = index;
  }
}
