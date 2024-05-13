import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_easy_barrage/flutter_easy_barrage.dart';
import 'package:flutter_easy_barrage/flutter_easy_barrage_platform_interface.dart';
import 'package:flutter_easy_barrage/flutter_easy_barrage_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterEasyBarragePlatform
    with MockPlatformInterfaceMixin
    implements FlutterEasyBarragePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterEasyBarragePlatform initialPlatform = FlutterEasyBarragePlatform.instance;

  test('$MethodChannelFlutterEasyBarrage is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterEasyBarrage>());
  });

  test('getPlatformVersion', () async {
    FlutterEasyBarrage flutterEasyBarragePlugin = FlutterEasyBarrage();
    MockFlutterEasyBarragePlatform fakePlatform = MockFlutterEasyBarragePlatform();
    FlutterEasyBarragePlatform.instance = fakePlatform;

    expect(await flutterEasyBarragePlugin.getPlatformVersion(), '42');
  });
}
