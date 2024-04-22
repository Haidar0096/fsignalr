import 'fsignalr_platform_interface.dart';

class Fsignalr {
  Future<String?> getPlatformVersion() {
    return FsignalrPlatform.instance.getPlatformVersion();
  }
}
