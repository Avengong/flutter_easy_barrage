import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_easy_barrage_platform_interface.dart';

/// An implementation of [FlutterEasyBarragePlatform] that uses method channels.
class MethodChannelFlutterEasyBarrage extends FlutterEasyBarragePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_easy_barrage');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
