import 'fsignalr_platform_interface.dart';

const Duration _defaultHandShakeResponseTimeout = Duration(seconds: 10);
const Duration _defaultKeepAliveInterval = Duration(seconds: 15);
const Duration _defaultServerTimeout = Duration(seconds: 30);

/// A class that provides an API to manage signalr connections. Each instance
/// of this class manages a single hub connection.
/// # Usage
/// TODO: Add usage section.
class HubConnectionManager {
  /// Represents a unique id for the hub connection managed by this instance.
  final int _hubConnectionManagerId;

  const HubConnectionManager._(this._hubConnectionManagerId);

  static Future<HubConnectionManager> createHubConnection({
    required String baseUrl,
    required TransportType transportType,
    Map<String, String>? headers,
    String? accessToken,
    Duration? handShakeResponseTimeout,
    Duration? keepAliveInterval,
    Duration? serverTimeout,
  }) async {
    final int hubConnectionManagerId =
        await FsignalrPlatformInterface.instance.createHubConnectionManager(
      baseUrl: baseUrl,
      transportType: transportType,
      headers: headers,
      accessToken: accessToken,
      handShakeResponseTimeout:
          handShakeResponseTimeout ?? _defaultHandShakeResponseTimeout,
      keepAliveInterval: keepAliveInterval ?? _defaultKeepAliveInterval,
      serverTimeout: serverTimeout ?? _defaultServerTimeout,
    );
    return HubConnectionManager._(hubConnectionManagerId);
  }

  Future<void> startConnection() => FsignalrPlatformInterface.instance
      .startHubConnection(hubConnectionManagerId: _hubConnectionManagerId);

  Future<void> stopConnection() => FsignalrPlatformInterface.instance
      .stopHubConnection(hubConnectionManagerId: _hubConnectionManagerId);

  Future<void> dispose() =>
      FsignalrPlatformInterface.instance.disposeHubConnectionManager(
        hubConnectionManagerId: _hubConnectionManagerId,
      );
}
