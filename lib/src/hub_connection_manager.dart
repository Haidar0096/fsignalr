import 'fsignalr_platform_interface.dart';
import 'pigeons/fsignalr_pigeons.g.dart';

/// Internally represents an id for a [HubConnectionManager] instance.
int _hubConnectionManagerCreationId = 0;

/// A class that provides an API to manage signalr connections. Each instance
/// of this class manages a single hub connection.
/// # Usage
/// TODO: Add usage section.
class HubConnectionManager {
  /// Represents a unique id for the hub connection managed by this instance.
  final int _hubConnectionManagerId = _hubConnectionManagerCreationId++;

  Future<void> createHubConnection({
    required String baseUrl,
    required TransportType transportType,
    Map<String, String>? headers,
    String? accessToken,
    int handleShakeResponseTimeoutInMilliseconds = 10000,
    int keepAliveIntervalInMilliSeconds = 15000,
    int serverTimeoutInMilliSeconds = 30000,
  }) =>
      FsignalrPlatformInterface.instance.createHubConnectionManager(
        hubConnectionManagerId: _hubConnectionManagerId,
        baseUrl: baseUrl,
        transportType: transportType,
        headers: headers,
        accessToken: accessToken,
        handleShakeResponseTimeoutInMilliseconds:
            handleShakeResponseTimeoutInMilliseconds,
        keepAliveIntervalInMilliseconds: keepAliveIntervalInMilliSeconds,
        serverTimeoutInMilliseconds: serverTimeoutInMilliSeconds,
      );

  Future<void> startConnection() => FsignalrPlatformInterface.instance
      .startHubConnection(hubConnectionManagerId: _hubConnectionManagerId);

  Future<void> stopConnection() => FsignalrPlatformInterface.instance
      .stopHubConnection(hubConnectionManagerId: _hubConnectionManagerId);

  Future<void> dispose() => FsignalrPlatformInterface.instance
      .disposeHubConnection(hubConnectionManagerId: _hubConnectionManagerId);
}
