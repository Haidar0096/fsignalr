import 'fsignalr_platform_interface.dart';
import 'pigeons/fsignalr_pigeons.g.dart';

/// An implementation of [FsignalrPlatformInterface] that uses pigeons package.
class PigeonsFsignalrPlatform extends FsignalrPlatformInterface {
  final HubConnectionManagerManager _hubConnectionManagerManager =
      HubConnectionManagerManager();

  final Map<int, HubConnectionManager> _hubConnectionManagers = {};

  //  Future<void> createHubConnectionManager({
  //     required int hubConnectionManagerId,
  //     required String baseUrl,
  //     required TransportType transportType,
  //     Map<String, String>? headers,
  //     String Function()? accessTokenProvider,
  //     required int handleShakeResponseTimeoutInMilliseconds,
  //     required int keepAliveIntervalInMilliseconds,
  //     required int serverTimeoutInMilliseconds,
  //   }) {
  //     throw UnimplementedError(
  //       'createHubConnectionManager() has not been implemented.',
  //     );
  //   }
  //
  //   Future<void> removeHubConnectionManager({required int hubId}) {
  //     throw UnimplementedError(
  //       'removeHubConnectionManager() has not been implemented.',
  //     );
  //   }
  //
  //   Future<void> startHubConnection({required int hubConnectionManagerId}) {
  //     throw UnimplementedError('startHubConnection() has not been implemented.');
  //   }
  //
  //   Future<void> stopHubConnection({required int hubConnectionManagerId}) {
  //     throw UnimplementedError('stopHubConnection() has not been implemented.');
  //   }
  //
  //   Future<void> disposeHubConnection({required int hubConnectionManagerId}) {
  //     throw UnimplementedError(
  //         'disposeHubConnection() has not been implemented.');
  //   }

  @override
  Future<void> createHubConnectionManager({
    required int hubConnectionManagerId,
    required String baseUrl,
    required TransportType transportType,
    Map<String, String>? headers,
    String? accessToken,
    required int handleShakeResponseTimeoutInMilliseconds,
    required int keepAliveIntervalInMilliseconds,
    required int serverTimeoutInMilliseconds,
  }) async {
    await _hubConnectionManagerManager.createHubConnectionManager(
      id: hubConnectionManagerId,
      baseUrl: baseUrl,
      transportType: transportType,
      headers: headers,
      accessToken: accessToken,
      handleShakeResponseTimeoutInMilliseconds:
          handleShakeResponseTimeoutInMilliseconds,
      keepAliveIntervalInMilliseconds: keepAliveIntervalInMilliseconds,
      serverTimeoutInMilliseconds: serverTimeoutInMilliseconds,
    );
    _hubConnectionManagers[hubConnectionManagerId] = HubConnectionManager(
        messageChannelSuffix:
            'com.perfektion.fsignalr.HubConnectionManager_$hubConnectionManagerId');
  }

  @override
  Future<void> removeHubConnectionManager({required int hubId}) async {
    await _hubConnectionManagerManager.removeHubConnectionManager(id: hubId);
    _hubConnectionManagers.remove(hubId);
  }

  @override
  Future<void> startHubConnection({required int hubConnectionManagerId}) =>
      _hubConnectionManagers[hubConnectionManagerId]!.startHubConnection();

  @override
  Future<void> stopHubConnection({required int hubConnectionManagerId}) =>
      _hubConnectionManagers[hubConnectionManagerId]!.stopHubConnection();

  @override
  Future<void> disposeHubConnection({required int hubConnectionManagerId}) =>
      _hubConnectionManagers[hubConnectionManagerId]!.dispose();
}
