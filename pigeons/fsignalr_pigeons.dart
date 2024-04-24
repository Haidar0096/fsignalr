import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/pigeons/fsignalr_pigeons.g.dart',
    javaOut:
        'android/src/main/java/com/perfektion/fsignalr/FsignalrPigeons.java',
    javaOptions: JavaOptions(
      package: 'com.perfektion.fsignalr',
      className: 'FsignalrPigeons',
    ),
  ),
)
// Below is the classes and contracts that define the communication between
// Dart and the native code.

/// Used to specify the transport the client will use.
enum TransportType {
  /// The client will use any available transport.
  all,

  /// The client will use WebSockets to communicate with the server.
  webSockets,

  /// The client will use Long Polling to communicate with the server.
  longPolling,
}

@HostApi()
abstract class HubConnectionManagerManager {
  @async
  void createHubConnectionManager({
    /// The unique id of the hub connection manager to be created.
    required int id,
    required String baseUrl,
    required TransportType transportType,
    Map<String, String>? headers,
    String? accessToken,
    required int handleShakeResponseTimeoutInMilliseconds,
    required int keepAliveIntervalInMilliseconds,
    required int serverTimeoutInMilliseconds,
  });

  @async
  void removeHubConnectionManager({
    /// The unique id of the hub connection manager to be removed.
    required int id,
  });
}

@HostApi()
abstract class HubConnectionManager {
  @async
  void startHubConnection();

  @async
  void stopHubConnection();

  /// Used when done with using the manager.
  @async
  void dispose();
}
