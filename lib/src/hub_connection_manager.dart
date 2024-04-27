import 'fsignalr_platform_interface.dart';
import 'pigeons/messages.g.dart'
    show
        HubConnectionManagerFlutterApi,
        OnHubConnectionStateChangedMessage,
        OnMessageReceivedMessage,
        OnHubConnectionClosedMessage;

const Duration _defaultHandShakeResponseTimeout = Duration(seconds: 10);
const Duration _defaultKeepAliveInterval = Duration(seconds: 15);
const Duration _defaultServerTimeout = Duration(seconds: 30);

/// A class that provides an API to manage signalr connections. Each instance
/// of this class manages a single hub connection.
/// # Usage
/// TODO: Add usage section.
class HubConnectionManager implements HubConnectionManagerFlutterApi {
  /// Represents a unique id for the hub connection managed by this instance.
  final int _hubConnectionManagerId;

  HubConnectionManager._(this._hubConnectionManagerId) {
    // register this instance to listen to messages from the native side
    // invoked on the channel of the `HubConnectionManagerFlutterApi` with
    // the suffix of the hubConnectionManagerId.
    HubConnectionManagerFlutterApi.setUp(
      this,
      messageChannelSuffix: _hubConnectionManagerId.toString(),
    );
  }

  /// Callback that is invoked when the state of the hub connection changes.
  void Function(HubConnectionState connectionState)?
      onHubConnectionStateChangedCallback;

  /// This callback is invoked from the native side when the state of the hub
  /// connection changes. Do not call this method directly. Instead register
  /// your callback using [onHubConnectionStateChangedCallback].
  @override
  void onHubConnectionStateChanged(OnHubConnectionStateChangedMessage msg) =>
      onHubConnectionStateChangedCallback?.call(
        HubConnectionState.fromHubConnectionStateMessage(msg.state),
      );

  /// Callback that is invoked when a message is received from the server.
  /// Currently only supports string arguments, with a maximum of 2 arguments.
  void Function(String methodName, List<String?>? args)?
      onMessageReceivedCallback;

  /// This callback is invoked from the native side when a message is received
  /// from the server. Do not call this method directly. Instead register
  /// your callback using [onMessageReceivedCallback].
  @override
  void onMessageReceived(OnMessageReceivedMessage msg) =>
      onMessageReceivedCallback?.call(msg.methodName, msg.args);

  /// Callback that is invoked when the hub connection is closed.
  void Function(String exception)? onConnectionClosedCallback;

  /// This callback is invoked from the native side when the hub connection is
  /// closed. Do not call this method directly. Instead register your callback
  /// using [onConnectionClosedCallback].
  @override
  void onConnectionClosed(OnHubConnectionClosedMessage msg) =>
      onConnectionClosedCallback?.call(msg.exceptionMessage);

  /// Creates a new instance of [HubConnectionManager] with the given parameters.
  /// - [handledHubMethods] : A list of hub methods that this instance can
  /// handle when received from the server.
  /// It is not necessary to provide a handler even if the method is in this list.
  /// The handler can be provided later using
  /// the [onMessageReceivedCallback] property by switching on the method name
  /// that is passed to this callback.
  static Future<HubConnectionManager> createHubConnection({
    required String baseUrl,
    required TransportType transportType,
    Map<String, String>? headers,
    String? accessToken,
    Duration? handShakeResponseTimeout,
    Duration? keepAliveInterval,
    Duration? serverTimeout,
    List<HandledHubMethod>? handledHubMethods,
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
      handledHubMethods: handledHubMethods,
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
