import 'package:get/get.dart';
import '../controllers/discovery_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DiscoveryController());
  }
}
