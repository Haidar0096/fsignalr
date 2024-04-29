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

class HandledHubMethodMessage {
  String methodName;
  int argCount;

  HandledHubMethodMessage({
    required this.methodName,
    required this.argCount,
  });
}

class CreateHubConnectionManagerMessage {
  String baseUrl;
  TransportTypeMessage transportType;
  Map<String?, String?>? headers;
  String? accessToken;
  int handShakeResponseTimeoutInMilliseconds;
  int keepAliveIntervalInMilliseconds;
  int serverTimeoutInMilliseconds;
  List<HandledHubMethodMessage?>? handledHubMethods;

  CreateHubConnectionManagerMessage({
    required this.baseUrl,
    required this.transportType,
    required this.headers,
    required this.accessToken,
    required this.handShakeResponseTimeoutInMilliseconds,
    required this.keepAliveIntervalInMilliseconds,
    required this.serverTimeoutInMilliseconds,
    required this.handledHubMethods,
  });
}

class HubConnectionManagerIdMessage {
  int hubConnectionManagerId;

  HubConnectionManagerIdMessage({
    /// The unique id of the hub connection manager.
    required this.hubConnectionManagerId,
  });
}

class InvokeHubMethodMessage {
  String methodName;

  List<String?>? args;

  HubConnectionManagerIdMessage hubConnectionManagerIdMessage;

  InvokeHubMethodMessage({
    required this.methodName,
    required this.args,
    required this.hubConnectionManagerIdMessage,
  });
}

enum HubConnectionStateMessage {
  connected,
  connecting,
  disconnected,
}

class OnHubConnectionStateChangedMessage {
  HubConnectionStateMessage state;

  OnHubConnectionStateChangedMessage({required this.state});
}

class OnHubConnectionClosedMessage {
  String exceptionMessage;

  OnHubConnectionClosedMessage({
    required this.exceptionMessage,
  });
}

class OnMessageReceivedMessage {
  String methodName;
  List<String?>? args;

  OnMessageReceivedMessage({
    required this.methodName,
    required this.args,
  });
}

class SetBaseUrlMessage {
  String baseUrl;
  HubConnectionManagerIdMessage hubConnectionManagerIdMessage;

  SetBaseUrlMessage({
    required this.baseUrl,
    required this.hubConnectionManagerIdMessage,
  });
}

/// Used to communicate with hub connections managers on the native side.
@HostApi()
abstract class HubConnectionManagerNativeApi {
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
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  void invoke(InvokeHubMethodMessage msg);

  @async
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  void setBaseUrl(SetBaseUrlMessage msg);

  @async
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  void disposeHubConnectionManager(HubConnectionManagerIdMessage msg);
}

@FlutterApi()
abstract class HubConnectionManagerFlutterApi {
  void onHubConnectionStateChanged(OnHubConnectionStateChangedMessage msg);

  void onConnectionClosed(OnHubConnectionClosedMessage msg);

  void onMessageReceived(OnMessageReceivedMessage msg);
}
