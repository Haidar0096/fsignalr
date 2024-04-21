import 'package:flutter_test/flutter_test.dart';
import 'package:fsignalr/fsignalr.dart';
import 'package:fsignalr/fsignalr_platform_interface.dart';
import 'package:fsignalr/fsignalr_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFsignalrPlatform
    with MockPlatformInterfaceMixin
    implements FsignalrPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FsignalrPlatform initialPlatform = FsignalrPlatform.instance;

  test('$MethodChannelFsignalr is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFsignalr>());
  });

  test('getPlatformVersion', () async {
    Fsignalr fsignalrPlugin = Fsignalr();
    MockFsignalrPlatform fakePlatform = MockFsignalrPlatform();
    FsignalrPlatform.instance = fakePlatform;

    expect(await fsignalrPlugin.getPlatformVersion(), '42');
  });
}
