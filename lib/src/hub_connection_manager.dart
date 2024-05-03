import 'dart:async';

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
/// ```dart
/// import 'package:fsignalr/fsignalr.dart';
///
/// class HubMethodHandler {
///   final String methodName;
///   final int argsCount;
///   final void Function(String methodName, List<String?>? args)? handler;
///
///   const HubMethodHandler({
///     required this.methodName,
///     required this.argsCount,
///     required this.handler,
///   });
/// }
///
/// const appHubMethodHandlers = [
///   HubMethodHandler(
///     methodName: 'NoArgsEchoMethod',
///     argsCount: 0,
///     handler: noArgsMethodHandler,
///   ),
///   HubMethodHandler(
///     methodName: 'OneArgEchoMethod',
///     argsCount: 1,
///     handler: oneArgMethodHandler,
///   ),
///   HubMethodHandler(
///     methodName: 'TwoArgsEchoMethod',
///     argsCount: 2,
///     handler: twoArgsMethodHandler,
///   ),
/// ];
///
/// void noArgsMethodHandler(String methodName, List<String?>? args) {
///   print('NoArgsEchoMethod received, args: $args');
/// }
///
/// void oneArgMethodHandler(String methodName, List<String?>? args) {
///   print('OneArgEchoMethod received, args: $args');
/// }
///
/// void twoArgsMethodHandler(String methodName, List<String?>? args) {
///   print('TwoArgsEchoMethod received, args: $args');
/// }
///
/// Future<void> setUpConnection() async {
///   try {
///     // Create the hub connection manager
///     final HubConnectionManager manager = HubConnectionManager();
///
///     // Initialize the hub connection manager, this must be done
///     // before calling any other method on the manager
///     await manager.init(
///       baseUrl: 'https://myserver.com/hub',
///       transportType: TransportType.all,
///       headers: {'myHeaderKey': 'myHeaderValue'},
///       accessToken: 'myToken',
///       handShakeResponseTimeout: const Duration(seconds: 10),
///       keepAliveInterval: const Duration(seconds: 20),
///       serverTimeout: const Duration(seconds: 30),
///       handledHubMethods: appHubMethodHandlers
///           .map(
///             (appHubMethodHandler) =>
///         (
///         methodName: appHubMethodHandler.methodName,
///         argCount: appHubMethodHandler.argsCount,
///         ),
///       )
///           .toList(),
///     );
///
///     // Listen to the connection state
///     manager.onHubConnectionStateChangedCallback = (state) {
///       print('Connection state changed to: $state');
///     };
///
///     // listen to received messages from the server
///     // this listener will only be invoked for the hub methods with names that
///     // were registered in the handledHubMethods list
///     manager.onMessageReceivedCallback = (methodName, args) {
///       for (final appHubMethodHandler in appHubMethodHandlers) {
///         if (methodName == appHubMethodHandler.methodName) {
///           appHubMethodHandler.handler?.call(methodName, args);
///           break; // or you can not break if you want to call all
///           // the handlers that have the same method name
///         }
///       }
///     };
///
///     // listen to connection-closed callback
///     manager.onConnectionClosedCallback = (exception) {
///       print('Connection closed, exception: $exception');
///     };
///
///     // Start the connection
///     await manager.startConnection();
///
///     // invoke methods on the server
///     await manager.invoke(
///       methodName: 'MyServerMethodName',
///       args: ['myFirstArg', 'mySecondArg'],
///     );
///
///     // stop the connection
///     await manager.stopConnection();
///
///     // start the connection again, if you want :)
///     await manager.startConnection();
///
///     // dispose the hub connection manager when done (also stops the connection)
///     await manager.dispose();
///   } catch (e) {
///     print('Error has occurred: $e');
///   }
/// }
/// ```
class HubConnectionManager implements HubConnectionManagerFlutterApi {
  /// Represents a unique id for the hub connection managed by this instance.
  late final int _hubConnectionManagerId;

  /// Indicates if there is an ongoing initialization process.
  Completer<void>? _initializationCompleter;

  /// Indicates if this instance has been initialized.
  bool _initialized = false;

  HubConnectionManager();

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
  /// The callback is invoked only for the hub methods that were registered
  /// in the [init] method.x
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

  /// Initializes the [HubConnectionManager] with the given parameters.
  /// Calling this method  more than once does nothing.
  /// - [handledHubMethods] : A list of hub methods that this instance can
  /// handle when received from the server.
  /// It is not obligatory to provide a handler using [onMessageReceivedCallback],
  /// even if the method is in this list.
  /// The handler can always be provided or changed using
  /// the [onMessageReceivedCallback].
  Future<void> init({
    required String baseUrl,
    required TransportType transportType,
    Map<String, String>? headers,
    String? accessToken,
    Duration? handShakeResponseTimeout,
    Duration? keepAliveInterval,
    Duration? serverTimeout,
    List<HandledHubMethod>? handledHubMethods,
  }) async {
    if (_initialized) return;

    if (_initializationCompleter != null) {
      return _initializationCompleter!.future;
    }

    _initializationCompleter = Completer<void>();

    try {
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

      // register this instance to listen to messages from the native side
      // invoked on the channel of the `HubConnectionManagerFlutterApi` with
      // the suffix of the hubConnectionManagerId.
      HubConnectionManagerFlutterApi.setUp(
        this,
        messageChannelSuffix: hubConnectionManagerId.toString(),
      );

      _hubConnectionManagerId = hubConnectionManagerId;

      _initialized = true;
      _initializationCompleter!.complete();
    } catch (e) {
      _initializationCompleter!.completeError(e);
    }
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

  Future<void> setBaseUrl(String baseUrl) =>
      FsignalrPlatformInterface.instance.setBaseUrl(
        baseUrl: baseUrl,
        hubConnectionManagerId: _hubConnectionManagerId,
      );

  /// Disposes the hub connection manager. After calling this method, the
  /// instance of this class should not be used anymore.
  Future<void> dispose() =>
      FsignalrPlatformInterface.instance.disposeHubConnectionManager(
        hubConnectionManagerId: _hubConnectionManagerId,
      );
}
