import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'pigeons/fsignalr_pigeons.g.dart';
import 'pigeons_fsignalr_platform_interface_impl.dart';

abstract class FsignalrPlatformInterface extends PlatformInterface {
  /// Constructs a FsignalrPlatform.
  FsignalrPlatformInterface() : super(token: _token);

  static final Object _token = Object();

  static FsignalrPlatformInterface _instance = PigeonsFsignalrPlatform();

  /// The default instance of [FsignalrPlatformInterface] to use.
  ///
  /// Defaults to [MethodChannelFsignalrImpl].
  static FsignalrPlatformInterface get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FsignalrPlatformInterface] when
  /// they register themselves.
  static set instance(FsignalrPlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> createHubConnection({
    required String baseUrl,
    required TransportType transportType,
    Map<String, String>? headers,
    String Function()? accessTokenProvider,
    required int handleShakeResponseTimeoutInMilliseconds,
    required int keepAliveIntervalInMilliseconds,
    required int serverTimeoutInMilliseconds,
  }) {
    throw UnimplementedError('createHubConnection() has not been implemented.');
  }
}
