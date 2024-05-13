
import 'flutter_easy_barrage_platform_interface.dart';

class FlutterEasyBarrage {
  Future<String?> getPlatformVersion() {
    return FlutterEasyBarragePlatform.instance.getPlatformVersion();
  }
}
