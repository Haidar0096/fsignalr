import 'fsignalr_platform_interface.dart';
import 'pigeons/messages.g.dart';

/// An implementation of [FsignalrPlatformInterface] that uses pigeons package.
class PigeonsFsignalrPlatform extends FsignalrPlatformInterface {
  /// Used to communicate with the native side of the plugin.
  final HubConnectionManagerApi _hubConnectionManagerApi =
      HubConnectionManagerApi();

  @override
  Future<int> createHubConnectionManager({
    required String baseUrl,
    required TransportType transportType,
    Map<String, String>? headers,
    String? accessToken,
    required Duration handShakeResponseTimeout,
    required Duration keepAliveInterval,
    required Duration serverTimeout,
  }) async {
    final HubConnectionManagerIdMessage hubConnectionManagerIdMessage =
        await _hubConnectionManagerApi.createHubConnectionManager(
      CreateHubConnectionManagerMessage(
        baseUrl: baseUrl,
        transportType: transportType.toTransportTypeMessage(),
        headers: headers,
        accessToken: accessToken,
        handShakeResponseTimeoutInMilliseconds:
            handShakeResponseTimeout.inMilliseconds,
        keepAliveIntervalInMilliseconds: keepAliveInterval.inMilliseconds,
        serverTimeoutInMilliseconds: serverTimeout.inMilliseconds,
      ),
    );
    return hubConnectionManagerIdMessage.hubConnectionManagerId;
  }

  @override
  Future<void> startHubConnection({required int hubConnectionManagerId}) =>
      _hubConnectionManagerApi.startHubConnection(
        HubConnectionManagerIdMessage(
          hubConnectionManagerId: hubConnectionManagerId,
        ),
      );

  @override
  Future<void> stopHubConnection({required int hubConnectionManagerId}) =>
      _hubConnectionManagerApi.stopHubConnection(
        HubConnectionManagerIdMessage(
          hubConnectionManagerId: hubConnectionManagerId,
        ),
      );

  @override
  Future<void> disposeHubConnectionManager(
          {required int hubConnectionManagerId}) =>
      _hubConnectionManagerApi.disposeHubConnectionManager(
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
