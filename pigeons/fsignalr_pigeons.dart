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
abstract class FsignalrApi {
  @async
  void createHubConnection({
    required String baseUrl,
    required TransportType transportType,
    Map<String, String>? headers,
    String? accessTokenProviderResult,
    required int handleShakeResponseTimeoutInMilliseconds,
    required int keepAliveIntervalInMilliseconds,
    required int serverTimeoutInMilliseconds,
  });
}
