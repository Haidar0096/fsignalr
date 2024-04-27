import 'fsignalr_platform_interface.dart';
import 'pigeons/messages.g.dart';

/// An implementation of [FsignalrPlatformInterface] that uses pigeons package.
class PigeonsFsignalrPlatform extends FsignalrPlatformInterface {
  /// Used to communicate with the native side of the plugin.
  final HubConnectionManagerNativeApi _hubConnectionManagerNativeApi =
      HubConnectionManagerNativeApi();

  @override
  Future<int> createHubConnectionManager({
    required String baseUrl,
    required TransportType transportType,
    Map<String, String>? headers,
    String? accessToken,
    required Duration handShakeResponseTimeout,
    required Duration keepAliveInterval,
    required Duration serverTimeout,
    List<HandledHubMethod>? handledHubMethods,
  }) async {
    final HubConnectionManagerIdMessage hubConnectionManagerIdMessage =
        await _hubConnectionManagerNativeApi.createHubConnectionManager(
      CreateHubConnectionManagerMessage(
        baseUrl: baseUrl,
        transportType: transportType.toTransportTypeMessage(),
        headers: headers,
        accessToken: accessToken,
        handShakeResponseTimeoutInMilliseconds:
            handShakeResponseTimeout.inMilliseconds,
        keepAliveIntervalInMilliseconds: keepAliveInterval.inMilliseconds,
        serverTimeoutInMilliseconds: serverTimeout.inMilliseconds,
        handledHubMethods: handledHubMethods
            ?.map(
              (HandledHubMethod handledHubMethod) => HandledHubMethodMessage(
                methodName: handledHubMethod.methodName,
                argCount: handledHubMethod.argCount,
              ),
            )
            .toList(),
      ),
    );
    return hubConnectionManagerIdMessage.hubConnectionManagerId;
  }

  @override
  Future<void> startHubConnection({
    required int hubConnectionManagerId,
  }) =>
      _hubConnectionManagerNativeApi.startHubConnection(
        HubConnectionManagerIdMessage(
          hubConnectionManagerId: hubConnectionManagerId,
        ),
      );

  @override
  Future<void> stopHubConnection({
    required int hubConnectionManagerId,
  }) =>
      _hubConnectionManagerNativeApi.stopHubConnection(
        HubConnectionManagerIdMessage(
          hubConnectionManagerId: hubConnectionManagerId,
        ),
      );

  @override
  Future<void> invoke({
    required String methodName,
    List<String?>? args,
    required int hubConnectionManagerId,
  }) =>
      _hubConnectionManagerNativeApi.invoke(
        InvokeHubMethodMessage(
          methodName: methodName,
          args: args,
          hubConnectionManagerIdMessage: HubConnectionManagerIdMessage(
            hubConnectionManagerId: hubConnectionManagerId,
          ),
        ),
      );

  @override
  Future<void> disposeHubConnectionManager({
    required int hubConnectionManagerId,
  }) =>
      _hubConnectionManagerNativeApi.disposeHubConnectionManager(
        HubConnectionManagerIdMessage(
          hubConnectionManagerId: hubConnectionManagerId,
        ),
      );
}

extension TransportTypeExtension on TransportType {
  TransportTypeMessage toTransportTypeMessage() => switch (this) {
        TransportType.all => TransportTypeMessage.all,
        TransportType.webSockets => TransportTypeMessage.webSockets,
        TransportType.longPolling => TransportTypeMessage.longPolling
      };
}
