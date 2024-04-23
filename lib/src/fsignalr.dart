import 'fsignalr_platform_interface.dart';
import 'pigeons/fsignalr_pigeons.g.dart';

/// A class that provides an API to manage signalr connections.
class Fsignalr {
  Future<void> createHubConnection({
    required String baseUrl,
    required TransportType transportType,
    Map<String, String>? headers,
    String Function()? accessTokenProvider,
    int handleShakeResponseTimeoutInMilliseconds = 10000,
    int keepAliveIntervalInMilliSeconds = 15000,
    int serverTimeoutInMilliSeconds = 30000,
  }) =>
      FsignalrPlatformInterface.instance.createHubConnection(
        baseUrl: baseUrl,
        transportType: transportType,
        headers: headers,
        accessTokenProvider: accessTokenProvider,
        handleShakeResponseTimeoutInMilliseconds:
            handleShakeResponseTimeoutInMilliseconds,
        keepAliveIntervalInMilliseconds: keepAliveIntervalInMilliSeconds,
        serverTimeoutInMilliseconds: serverTimeoutInMilliSeconds,
      );
}
