import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/pigeons/messages.g.dart',
    javaOut: 'android/src/main/java/com/perfektion/fsignalr/Messages.java',
    javaOptions: JavaOptions(
      package: 'com.perfektion.fsignalr',
      className: 'Messages',
    ),
  ),
)
// Below is the classes and contracts that define the communication between
// Dart and the native code.
// @HostApi() annotates a class that will be used to send messages to the native
// side.
// @FlutterApi() annotates a class that will be used to receive messages from the
// native side.

enum TransportTypeMessage {
  all,
  webSockets,
  longPolling,
}

class CreateHubConnectionManagerMessage {
  String baseUrl;
  TransportTypeMessage transportType;
  Map<String?, String?>? headers;
  String? accessToken;
  int handShakeResponseTimeoutInMilliseconds;
  int keepAliveIntervalInMilliseconds;
  int serverTimeoutInMilliseconds;

  CreateHubConnectionManagerMessage({
    required this.baseUrl,
    required this.transportType,
    this.headers,
    this.accessToken,
    required this.handShakeResponseTimeoutInMilliseconds,
    required this.keepAliveIntervalInMilliseconds,
    required this.serverTimeoutInMilliseconds,
  });
}

class HubConnectionManagerIdMessage {
  int hubConnectionManagerId;

  HubConnectionManagerIdMessage({
    /// The unique id of the hub connection manager.
    required this.hubConnectionManagerId,
  });
}

/// Used to manage hub connections managers on the native side.
@HostApi()
abstract class HubConnectionManagerApi {
  @async
  HubConnectionManagerIdMessage createHubConnectionManager(
    CreateHubConnectionManagerMessage msg,
  );

  @async
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  void startHubConnection(HubConnectionManagerIdMessage msg);

  @async
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  void stopHubConnection(HubConnectionManagerIdMessage msg);

  @async
  void disposeHubConnectionManager(HubConnectionManagerIdMessage msg);
}
