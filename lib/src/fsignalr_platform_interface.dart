import 'package:fsignalr/src/pigeons/messages.g.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'pigeons_fsignalr_platform_interface_impl.dart';

typedef HandledHubMethod = ({String methodName, int argCount});

/// Used to specify the transport the client will use.
enum TransportType {
  /// The client will use any available transport.
  all,

  /// The client will use WebSockets to communicate with the server.
  webSockets,

  /// The client will use Long Polling to communicate with the server.
  longPolling;
}

/// Represents the state of a hub connection.
enum HubConnectionState {
  connecting,
  connected,
  disconnected;

  static HubConnectionState fromHubConnectionStateMessage(
          HubConnectionStateMessage msg) =>
      switch (msg) {
        HubConnectionStateMessage.connected => HubConnectionState.connected,
        HubConnectionStateMessage.connecting => HubConnectionState.connecting,
        HubConnectionStateMessage.disconnected =>
          HubConnectionState.disconnected,
      };
}

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

  Future<int> createHubConnectionManager({
    required String baseUrl,
    required TransportType transportType,
    Map<String, String>? headers,
    String? accessToken,
    required Duration handShakeResponseTimeout,
    required Duration keepAliveInterval,
    required Duration serverTimeout,
    List<HandledHubMethod>? handledHubMethods,
  }) {
    throw UnimplementedError(
      'createHubConnectionManager() has not been implemented.',
    );
  }

  Future<void> startHubConnection({required int hubConnectionManagerId}) {
    throw UnimplementedError('startHubConnection() has not been implemented.');
  }

  Future<void> stopHubConnection({required int hubConnectionManagerId}) {
    throw UnimplementedError('stopHubConnection() has not been implemented.');
  }

  Future<void> invoke({
    required String methodName,
    List<String?>? args,
    required int hubConnectionManagerId,
  }) {
    throw UnimplementedError('invoke() has not been implemented.');
  }

  Future<void> disposeHubConnectionManager({
    required int hubConnectionManagerId,
  }) {
    throw UnimplementedError(
      'disposeHubConnectionManager() has not been implemented.',
    );
  }
}
