import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/pigeons/fsignalr_pigeons.g.dart',
    javaOut:
        'android/src/main/java/com/perfektion/fsignalr/FsignalrPigeons.java',
    javaOptions: JavaOptions(
      package: 'com.perfektion.fsignalr',
      className: 'FsignalrPigeons',
    ),
  ),
)
class PlatformVersionResult {
  final String platformVersion;

  PlatformVersionResult({required this.platformVersion});
}

@HostApi()
abstract class FsignalrApi {
  @async
  PlatformVersionResult? getPlatformVersion();
}
