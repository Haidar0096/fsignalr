import 'package:fsignalr/src/pigeons/fsignalr_pigeons.g.dart';

import 'fsignalr_platform_interface.dart';

/// An implementation of [FsignalrPlatformInterface] that uses pigeons package.
class PigeonsFsignalrPlatform extends FsignalrPlatformInterface {
  final FsignalrApi _fsignalrApi = FsignalrApi();

  @override
  Future<void> createHubConnection({
    required String baseUrl,
    required TransportType transportType,
    Map<String, String>? headers,
    String Function()? accessTokenProvider,
    required int handleShakeResponseTimeoutInMilliseconds,
    required int keepAliveIntervalInMilliseconds,
    required int serverTimeoutInMilliseconds,
  }) =>
      _fsignalrApi.createHubConnection(
        baseUrl: baseUrl,
        transportType: transportType,
        headers: headers,
        accessTokenProviderResult: accessTokenProvider?.call(),
        handleShakeResponseTimeoutInMilliseconds:
            handleShakeResponseTimeoutInMilliseconds,
        keepAliveIntervalInMilliseconds: keepAliveIntervalInMilliseconds,
        serverTimeoutInMilliseconds: serverTimeoutInMilliseconds,
      );
}
