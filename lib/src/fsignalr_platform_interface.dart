import 'package:fsignalr/src/pigeons_fsignalr_platform_interface_impl.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class FsignalrPlatform extends PlatformInterface {
  /// Constructs a FsignalrPlatform.
  FsignalrPlatform() : super(token: _token);

  static final Object _token = Object();

  static FsignalrPlatform _instance = PigeonsFsignalrPlatform();

  /// The default instance of [FsignalrPlatform] to use.
  ///
  /// Defaults to [MethodChannelFsignalrImpl].
  static FsignalrPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FsignalrPlatform] when
  /// they register themselves.
  static set instance(FsignalrPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
