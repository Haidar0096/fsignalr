// Autogenerated from Pigeon (v18.0.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name, unnecessary_import, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;

import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';

PlatformException _createConnectionError(String channelName) {
  return PlatformException(
    code: 'channel-error',
    message: 'Unable to establish connection on channel: "$channelName".',
  );
}

enum TransportTypeMessage {
  all,
  webSockets,
  longPolling,
}

class CreateHubConnectionManagerMessage {
  CreateHubConnectionManagerMessage({
    required this.baseUrl,
    required this.transportType,
    this.headers,
    this.accessToken,
    required this.handShakeResponseTimeoutInMilliseconds,
    required this.keepAliveIntervalInMilliseconds,
    required this.serverTimeoutInMilliseconds,
  });

  String baseUrl;

  TransportTypeMessage transportType;

  Map<String?, String?>? headers;

  String? accessToken;

  int handShakeResponseTimeoutInMilliseconds;

  int keepAliveIntervalInMilliseconds;

  int serverTimeoutInMilliseconds;

  Object encode() {
    return <Object?>[
      baseUrl,
      transportType.index,
      headers,
      accessToken,
      handShakeResponseTimeoutInMilliseconds,
      keepAliveIntervalInMilliseconds,
      serverTimeoutInMilliseconds,
    ];
  }

  static CreateHubConnectionManagerMessage decode(Object result) {
    result as List<Object?>;
    return CreateHubConnectionManagerMessage(
      baseUrl: result[0]! as String,
      transportType: TransportTypeMessage.values[result[1]! as int],
      headers: (result[2] as Map<Object?, Object?>?)?.cast<String?, String?>(),
      accessToken: result[3] as String?,
      handShakeResponseTimeoutInMilliseconds: result[4]! as int,
      keepAliveIntervalInMilliseconds: result[5]! as int,
      serverTimeoutInMilliseconds: result[6]! as int,
    );
  }
}

class HubConnectionManagerIdMessage {
  HubConnectionManagerIdMessage({
    required this.hubConnectionManagerId,
  });

  int hubConnectionManagerId;

  Object encode() {
    return <Object?>[
      hubConnectionManagerId,
    ];
  }

  static HubConnectionManagerIdMessage decode(Object result) {
    result as List<Object?>;
    return HubConnectionManagerIdMessage(
      hubConnectionManagerId: result[0]! as int,
    );
  }
}

class InvokeMessage {
  InvokeMessage({
    required this.methodName,
    this.args,
    required this.hubConnectionManagerIdMessage,
  });

  String methodName;

  List<String?>? args;

  HubConnectionManagerIdMessage hubConnectionManagerIdMessage;

  Object encode() {
    return <Object?>[
      methodName,
      args,
      hubConnectionManagerIdMessage.encode(),
    ];
  }

  static InvokeMessage decode(Object result) {
    result as List<Object?>;
    return InvokeMessage(
      methodName: result[0]! as String,
      args: (result[1] as List<Object?>?)?.cast<String?>(),
      hubConnectionManagerIdMessage: HubConnectionManagerIdMessage.decode(result[2]! as List<Object?>),
    );
  }
}

class _HubConnectionManagerApiCodec extends StandardMessageCodec {
  const _HubConnectionManagerApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is CreateHubConnectionManagerMessage) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is HubConnectionManagerIdMessage) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is InvokeMessage) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128: 
        return CreateHubConnectionManagerMessage.decode(readValue(buffer)!);
      case 129: 
        return HubConnectionManagerIdMessage.decode(readValue(buffer)!);
      case 130: 
        return InvokeMessage.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

/// Used to manage hub connections managers on the native side.
class HubConnectionManagerApi {
  /// Constructor for [HubConnectionManagerApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  HubConnectionManagerApi({BinaryMessenger? binaryMessenger, String messageChannelSuffix = ''})
      : __pigeon_binaryMessenger = binaryMessenger,
        __pigeon_messageChannelSuffix = messageChannelSuffix.isNotEmpty ? '.$messageChannelSuffix' : '';
  final BinaryMessenger? __pigeon_binaryMessenger;

  static const MessageCodec<Object?> pigeonChannelCodec = _HubConnectionManagerApiCodec();

  final String __pigeon_messageChannelSuffix;

  Future<HubConnectionManagerIdMessage> createHubConnectionManager(CreateHubConnectionManagerMessage msg) async {
    final String __pigeon_channelName = 'dev.flutter.pigeon.fsignalr.HubConnectionManagerApi.createHubConnectionManager$__pigeon_messageChannelSuffix';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[msg]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else if (__pigeon_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (__pigeon_replyList[0] as HubConnectionManagerIdMessage?)!;
    }
  }

  Future<void> startHubConnection(HubConnectionManagerIdMessage msg) async {
    final String __pigeon_channelName = 'dev.flutter.pigeon.fsignalr.HubConnectionManagerApi.startHubConnection$__pigeon_messageChannelSuffix';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[msg]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> stopHubConnection(HubConnectionManagerIdMessage msg) async {
    final String __pigeon_channelName = 'dev.flutter.pigeon.fsignalr.HubConnectionManagerApi.stopHubConnection$__pigeon_messageChannelSuffix';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[msg]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> invoke(InvokeMessage msg) async {
    final String __pigeon_channelName = 'dev.flutter.pigeon.fsignalr.HubConnectionManagerApi.invoke$__pigeon_messageChannelSuffix';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[msg]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> disposeHubConnectionManager(HubConnectionManagerIdMessage msg) async {
    final String __pigeon_channelName = 'dev.flutter.pigeon.fsignalr.HubConnectionManagerApi.disposeHubConnectionManager$__pigeon_messageChannelSuffix';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[msg]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return;
    }
  }
}
