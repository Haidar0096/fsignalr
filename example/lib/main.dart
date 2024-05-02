import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fsignalr/fsignalr.dart';

import 'message.dart';
import 'multi_tab_chat_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Completer? _m1ProcessingCompleter;
  Completer? _m2ProcessingCompleter;

  final List<Message> _m1Messages = [];
  final List<Message> _m2Messages = [];

  late final HubConnectionManager _m1;
  late final HubConnectionManager _m2;

  static const String baseUrl = 'http:192.168.1.2:5094/chatHub';

  bool _isProcessing(Completer? c) => !(c?.isCompleted ?? true);

  HubConnectionState _m1ConnectionState = HubConnectionState.disconnected;
  HubConnectionState _m2ConnectionState = HubConnectionState.disconnected;

  final List<HandledHubMethod> _m1HandledHubMethods = [
    (
      methodName: HandledMethods.noArgsEchoMethod.methodName,
      argCount: HandledMethods.noArgsEchoMethod.argsCount,
    ),
    (
      methodName: HandledMethods.oneArgEchoMethod.methodName,
      argCount: HandledMethods.oneArgEchoMethod.argsCount,
    ),
    (
      methodName: HandledMethods.twoArgsEchoMethod.methodName,
      argCount: HandledMethods.twoArgsEchoMethod.argsCount,
    )
  ];

  final List<HandledHubMethod> _m2HandledHubMethods = [
    (
      methodName: HandledMethods.noArgsEchoMethod.methodName,
      argCount: HandledMethods.noArgsEchoMethod.argsCount,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupConnections()
        .then((_) => _stopConnections())
        .then((_) => _startConnections())
        .then((_) => _startConnections());
  }

  @override
  void dispose() {
    _disposeConnections();
    super.dispose();
  }

  Future<void> _setupConnections() async {
    if (_isProcessing(_m1ProcessingCompleter)) {
      await _m1ProcessingCompleter?.future;
    }
    if (_isProcessing(_m2ProcessingCompleter)) {
      await _m2ProcessingCompleter?.future;
    }

    _m1ProcessingCompleter = Completer();
    _m2ProcessingCompleter = Completer();

    _performSetupConnections();

    return Future.wait<dynamic>(
      [
        if (_m1ProcessingCompleter != null) _m1ProcessingCompleter!.future,
        if (_m2ProcessingCompleter != null) _m2ProcessingCompleter!.future,
      ],
    ).then((_) => null);
  }

  Future<void> _performSetupConnections() async {
    try {
      _m1 = HubConnectionManager();
      await _m1.init(
        baseUrl: baseUrl,
        transportType: TransportType.all,
        headers: {'hubName': 'm1'},
        accessToken: 'm1Token',
        handShakeResponseTimeout: const Duration(seconds: 10),
        keepAliveInterval: const Duration(seconds: 20),
        serverTimeout: const Duration(seconds: 30),
        handledHubMethods: _m1HandledHubMethods,
      );
      _m1.onHubConnectionStateChangedCallback = (s) {
        _m1ConnectionState = s;
        setState(() {});
      };
      _m1.onMessageReceivedCallback = (methodName, args) {
        if (methodName == HandledMethods.noArgsEchoMethod.methodName) {
          _m1Messages.add(
            Message(
              source: MessageSource.server,
              arg1: 'no arg1 (NoArgsMethod)',
              arg2: 'no arg2 (NoArgsMethod)',
            ),
          );
          setState(() {});
        } else if (methodName == HandledMethods.oneArgEchoMethod.methodName) {
          _m1Messages.add(
            Message(
              source: MessageSource.server,
              arg1: args![0],
              arg2: 'no arg2 (OneArgMethod)',
            ),
          );
          setState(() {});
        } else if (methodName == HandledMethods.twoArgsEchoMethod.methodName) {
          _m1Messages.add(
            Message(
              source: MessageSource.server,
              arg1: args![0],
              arg2: args[1],
            ),
          );
          setState(() {});
        }
      };
      _m1.onConnectionClosedCallback = (exception) {
        debugPrint('m1: Connection closed. Exception: $exception');
      };
      _m1ProcessingCompleter?.complete();
    } catch (e) {
      _m1ProcessingCompleter?.completeError(e);
    }

    try {
      _m2 = HubConnectionManager();
      await _m2.init(
        baseUrl: baseUrl,
        transportType: TransportType.all,
        headers: {'hubName': 'm2'},
        accessToken: 'm2Token',
        handShakeResponseTimeout: const Duration(seconds: 10),
        keepAliveInterval: const Duration(seconds: 20),
        serverTimeout: const Duration(seconds: 30),
        handledHubMethods: _m2HandledHubMethods,
      );
      _m2.onHubConnectionStateChangedCallback = (s) {
        _m2ConnectionState = s;
        setState(() {});
      };
      _m2.onMessageReceivedCallback = (methodName, args) {
        if (methodName == HandledMethods.noArgsEchoMethod.methodName) {
          _m2Messages.add(
            Message(
              source: MessageSource.server,
              arg1: 'no arg1 (NoArgsMethod)',
              arg2: 'no arg2 (NoArgsMethod)',
            ),
          );
          setState(() {});
        }
      };
      _m2.onConnectionClosedCallback = (exception) {
        debugPrint('m2: Connection closed. Exception: $exception');
      };
      _m2ProcessingCompleter?.complete();
    } catch (e) {
      _m2ProcessingCompleter?.completeError(e);
    }
  }

  Future<void> _startConnections() async {
    if (_isProcessing(_m1ProcessingCompleter)) {
      await _m1ProcessingCompleter?.future;
    }
    if (_isProcessing(_m2ProcessingCompleter)) {
      await _m2ProcessingCompleter?.future;
    }

    _m1ProcessingCompleter = Completer();
    _m2ProcessingCompleter = Completer();

    _performStartConnections();

    setState(() {});

    return Future.wait<dynamic>(
      [
        if (_m1ProcessingCompleter != null) _m1ProcessingCompleter!.future,
        if (_m2ProcessingCompleter != null) _m2ProcessingCompleter!.future,
      ],
    ).then((_) => null);
  }

  Future<void> _performStartConnections() async {
    try {
      await _m1.startConnection();
      _m1ProcessingCompleter?.complete();
    } catch (e) {
      _m1ProcessingCompleter?.completeError(e);
    }

    try {
      await _m2.startConnection();
      _m2ProcessingCompleter?.complete();
    } catch (e) {
      _m2ProcessingCompleter?.completeError(e);
    }
  }

  Future<void> _stopConnections() async {
    if (_isProcessing(_m1ProcessingCompleter)) {
      await _m1ProcessingCompleter?.future;
    }
    if (_isProcessing(_m2ProcessingCompleter)) {
      await _m2ProcessingCompleter?.future;
    }

    _m1ProcessingCompleter = Completer();
    _m2ProcessingCompleter = Completer();

    _performStopConnections();

    setState(() {});

    return Future.wait<dynamic>(
      [
        if (_m1ProcessingCompleter != null) _m1ProcessingCompleter!.future,
        if (_m2ProcessingCompleter != null) _m2ProcessingCompleter!.future,
      ],
    ).then((_) => null);
  }

  Future<void> _performStopConnections() async {
    try {
      await _m1.stopConnection();
      _m1ProcessingCompleter?.complete();
    } catch (e) {
      _m1ProcessingCompleter?.completeError(e);
    }

    try {
      await _m2.stopConnection();
      _m2ProcessingCompleter?.complete();
    } catch (e) {
      _m2ProcessingCompleter?.completeError(e);
    }
  }

  Future<void> _disposeConnections() async {
    if (_isProcessing(_m1ProcessingCompleter)) {
      await _m1ProcessingCompleter?.future;
    }
    if (_isProcessing(_m2ProcessingCompleter)) {
      await _m2ProcessingCompleter?.future;
    }

    _m1ProcessingCompleter = Completer();
    _m2ProcessingCompleter = Completer();

    _performCloseConnections();

    setState(() {});

    return Future.wait<dynamic>(
      [
        if (_m1ProcessingCompleter != null) _m1ProcessingCompleter!.future,
        if (_m2ProcessingCompleter != null) _m2ProcessingCompleter!.future,
      ],
    ).then((_) => null);
  }

  Future<void> _performCloseConnections() async {
    try {
      await _m1.dispose();
      _m1ProcessingCompleter?.complete();

      await _m2.dispose();
      _m2ProcessingCompleter?.complete();
    } catch (e) {
      _m1ProcessingCompleter?.completeError(e);
      _m2ProcessingCompleter?.completeError(e);
    }
  }

  Future<void> _restartFirstConnection() async {
    if (_isProcessing(_m1ProcessingCompleter)) {
      await _m1ProcessingCompleter?.future;
    }

    _m1ProcessingCompleter = Completer();

    _performRestartConnection(
      hubConnectionManager: _m1,
      completer: _m1ProcessingCompleter!,
    );

    setState(() {});

    return _m1ProcessingCompleter?.future;
  }

  Future<void> _restartSecondConnection() async {
    if (_isProcessing(_m2ProcessingCompleter)) {
      await _m2ProcessingCompleter?.future;
    }

    _m2ProcessingCompleter = Completer();

    _performRestartConnection(
      hubConnectionManager: _m2,
      completer: _m2ProcessingCompleter!,
    );

    setState(() {});

    return _m2ProcessingCompleter?.future;
  }

  Future<void> _performRestartConnection({
    required HubConnectionManager hubConnectionManager,
    required Completer completer,
  }) async {
    try {
      await hubConnectionManager.startConnection();
      completer.complete();
    } catch (e) {
      completer.completeError(e);
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: FutureBuilder(
            future: Future.wait<dynamic>(
              [
                if (_m1ProcessingCompleter != null)
                  _m1ProcessingCompleter!.future,
                if (_m2ProcessingCompleter != null)
                  _m2ProcessingCompleter!.future,
              ],
            ),
            builder: (context, snapshot) => MultiTabChatView(
              multiTabChatViewTabsData: [
                MultiTabChatViewData(
                  messages: _m1Messages,
                  onSendMessagePressed: _onM1SendMessagePressed,
                  handledHubMethods: _m1HandledHubMethods,
                  hubName: 'First Hub',
                  connectionState: _m1ConnectionState,
                  loading: _isProcessing(_m1ProcessingCompleter),
                  onReloadIconPressed: _restartFirstConnection,
                ),
                MultiTabChatViewData(
                  messages: _m2Messages,
                  onSendMessagePressed: _onM2SendMessagePressed,
                  handledHubMethods: _m2HandledHubMethods,
                  hubName: 'Second Hub',
                  connectionState: _m2ConnectionState,
                  loading: _isProcessing(_m2ProcessingCompleter),
                  onReloadIconPressed: _restartSecondConnection,
                ),
              ],
            ),
          ),
        ),
      );

  Future<void> _onM1SendMessagePressed({
    required String hubMethodName,
    required String messageText,
  }) async {
    if (_isProcessing(_m1ProcessingCompleter)) {
      await _m1ProcessingCompleter?.future;
    }

    _m1ProcessingCompleter = Completer();

    _performSendMessage(
      completer: _m1ProcessingCompleter,
      hubConnectionManager: _m1,
      methodName: hubMethodName,
      args: _parseArgsFromTextFieldText(messageText),
      uiMessagesList: _m1Messages,
    );

    setState(() {});

    return _m1ProcessingCompleter?.future;
  }

  Future<void> _onM2SendMessagePressed({
    required String hubMethodName,
    required String messageText,
  }) async {
    if (_isProcessing(_m2ProcessingCompleter)) {
      await _m2ProcessingCompleter?.future;
    }

    _m2ProcessingCompleter = Completer();

    _performSendMessage(
      completer: _m2ProcessingCompleter,
      hubConnectionManager: _m2,
      methodName: hubMethodName,
      args: _parseArgsFromTextFieldText(messageText),
      uiMessagesList: _m2Messages,
    );

    setState(() {});

    return _m2ProcessingCompleter?.future;
  }

  /// Parses the message text to a list of arguments.
  /// Arguments are separated by a '|' character.
  List<String?>? _parseArgsFromTextFieldText(String message) {
    if (message.isEmpty) {
      return null;
    }
    final List<String> args = message.split('|');
    return args.map((arg) => arg.trim()).toList();
  }

  Future<void> _performSendMessage({
    required Completer? completer,
    required HubConnectionManager hubConnectionManager,
    required String methodName,
    required List<String?>? args,
    required List<Message> uiMessagesList,
  }) async {
    try {
      uiMessagesList.add(
        Message(
          source: MessageSource.client,
          arg1: args?.elementAtOrNull(0),
          arg2: args?.elementAtOrNull(1),
        ),
      );

      await hubConnectionManager.invoke(
        methodName: methodName,
        args: args,
      );

      completer?.complete();

      setState(() {});
    } catch (e) {
      completer?.completeError(e);
    }
  }
}

enum HandledMethods {
  noArgsEchoMethod._('NoArgsEchoMethod', 0),
  oneArgEchoMethod._('OneArgEchoMethod', 1),
  twoArgsEchoMethod._('TwoArgsEchoMethod', 2);

  final String methodName;
  final int argsCount;

  const HandledMethods._(this.methodName, this.argsCount);
}
