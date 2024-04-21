import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'fsignalr_platform_interface.dart';

/// An implementation of [FsignalrPlatform] that uses method channels.
class MethodChannelFsignalr extends FsignalrPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('fsignalr');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
