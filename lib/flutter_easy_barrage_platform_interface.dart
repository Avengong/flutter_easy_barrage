import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_easy_barrage_method_channel.dart';

abstract class FlutterEasyBarragePlatform extends PlatformInterface {
  /// Constructs a FlutterEasyBarragePlatform.
  FlutterEasyBarragePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterEasyBarragePlatform _instance = MethodChannelFlutterEasyBarrage();

  /// The default instance of [FlutterEasyBarragePlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterEasyBarrage].
  static FlutterEasyBarragePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterEasyBarragePlatform] when
  /// they register themselves.
  static set instance(FlutterEasyBarragePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
