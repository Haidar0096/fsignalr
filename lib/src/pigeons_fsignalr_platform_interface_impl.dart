import 'package:fsignalr/src/pigeons/fsignalr_pigeons.g.dart';

import 'fsignalr_platform_interface.dart';

/// An implementation of [FsignalrPlatform] that uses pigeons package.
class PigeonsFsignalrPlatform extends FsignalrPlatform {
  final FsignalrApi _fsignalrApi = FsignalrApi();

  @override
  Future<String?> getPlatformVersion() async =>
      _fsignalrApi.getPlatformVersion().then((pvr) => pvr?.platformVersion);
}
