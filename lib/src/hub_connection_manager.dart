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

  /// Creates a new instance of [HubConnectionManager] with the given parameters.
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

  /// Starts the hub connection.
  Future<void> startConnection() => FsignalrPlatformInterface.instance
      .startHubConnection(hubConnectionManagerId: _hubConnectionManagerId);

  /// Stops the hub connection.
  Future<void> stopConnection() => FsignalrPlatformInterface.instance
      .stopHubConnection(hubConnectionManagerId: _hubConnectionManagerId);

  /// Invokes a method on the server with the given parameters.
  /// - [methodName] : The name of the method to invoke on the server.
  /// - [args] : Optional list of arguments to pass to the server method.
  /// Currently only supports string arguments.
  /// For passing complex objects, consider serializing them to JSON strings,
  /// then deserializing them on the server.
  Future<void> invoke({
    required String methodName,
    List<String?>? args,
  }) =>
      FsignalrPlatformInterface.instance.invoke(
        methodName: methodName,
        args: args,
        hubConnectionManagerId: _hubConnectionManagerId,
      );

  /// Disposes the hub connection manager. After calling this method, the
  /// instance of this class should not be used anymore.
  Future<void> dispose() =>
      FsignalrPlatformInterface.instance.disposeHubConnectionManager(
        hubConnectionManagerId: _hubConnectionManagerId,
      );
}
