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

  static const String baseUrl =
      'https:my_ip_address:my_port_number/my_hub_name';

  bool _isProcessing(Completer? c) => !(c?.isCompleted ?? true);

  HubConnectionState _m1ConnectionState = HubConnectionState.disconnected;
  HubConnectionState _m2ConnectionState = HubConnectionState.disconnected;

  late final List<HubMethodHandler> _m1HubMethodHandlers;
  late final List<HubMethodHandler> _m2HubMethodHandlers;

  Future<void> _m1NoArgsMethodHandler(List<Object?>? args) async {
    _m1Messages.add(
      Message(
        source: MessageSource.server,
        arg1: 'no arg1 (NoArgsMethod)',
        arg2: 'no arg2 (NoArgsMethod)',
      ),
    );
    setState(() {});
  }

  Future<void> _m1OneArgMethodHandler(List<Object?>? args) async {
    _m1Messages.add(
      Message(
        source: MessageSource.server,
        arg1: args![0] as String,
        arg2: 'no arg2 (OneArgMethod)',
      ),
    );
    setState(() {});
  }

  Future<void> _m1TwoArgsMethodHandler(List<Object?>? args) async {
    _m1Messages.add(
      Message(
        source: MessageSource.server,
        arg1: args![0] as String,
        arg2: args[1] as String,
      ),
    );
    setState(() {});
  }

  Future<void> _m2NoArgsMethodHandler(List<Object?>? args) async {
    _m2Messages.add(
      Message(
        source: MessageSource.server,
        arg1: 'no arg1 (NoArgsMethod)',
        arg2: 'no arg2 (NoArgsMethod)',
      ),
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _m1HubMethodHandlers = [
      HubMethodHandler(
        methodName: 'NoArgsEchoMethod',
        argsCount: 0,
        handler: _m1NoArgsMethodHandler,
      ),
      HubMethodHandler(
        methodName: 'OneArgEchoMethod',
        argsCount: 1,
        handler: _m1OneArgMethodHandler,
      ),
      HubMethodHandler(
        methodName: 'TwoArgsEchoMethod',
        argsCount: 2,
        handler: _m1TwoArgsMethodHandler,
      ),
    ];

    _m2HubMethodHandlers = [
      HubMethodHandler(
        methodName: 'NoArgsEchoMethod',
        argsCount: 0,
        handler: _m2NoArgsMethodHandler,
      )
    ];

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
        handledHubMethods: _m1HubMethodHandlers
            .map(
              (m1HubMethodHandler) => (
                methodName: m1HubMethodHandler.methodName,
                argCount: m1HubMethodHandler.argsCount,
              ),
            )
            .toList(),
      );
      _m1.onHubConnectionStateChangedCallback = (s) {
        _m1ConnectionState = s;
        setState(() {});
      };
      _m1.onMessageReceivedCallback = (methodName, args) {
        for (final hubMethodHandler in _m1HubMethodHandlers) {
          if (methodName == hubMethodHandler.methodName) {
            hubMethodHandler.handler(args);
          }
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
        handledHubMethods: _m2HubMethodHandlers
            .map(
              (m2HubMethodHandler) => (
                methodName: m2HubMethodHandler.methodName,
                argCount: m2HubMethodHandler.argsCount,
              ),
            )
            .toList(),
      );
      _m2.onHubConnectionStateChangedCallback = (s) {
        _m2ConnectionState = s;
        setState(() {});
      };
      _m2.onMessageReceivedCallback = (methodName, args) {
        for (final hubMethodHandler in _m2HubMethodHandlers) {
          if (methodName == hubMethodHandler.methodName) {
            hubMethodHandler.handler(args);
          }
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
                  handledHubMethodsNames: _m1HubMethodHandlers
                      .map((handler) => handler.methodName)
                      .toList(),
                  hubName: 'First Hub',
                  connectionState: _m1ConnectionState,
                  loading: _isProcessing(_m1ProcessingCompleter),
                  onReloadIconPressed: _restartFirstConnection,
                ),
                MultiTabChatViewData(
                  messages: _m2Messages,
                  onSendMessagePressed: _onM2SendMessagePressed,
                  handledHubMethodsNames: _m2HubMethodHandlers
                      .map((handler) => handler.methodName)
                      .toList(),
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

class HubMethodHandler {
  final String methodName;
  final int argsCount;
  final Future<void> Function(List<Object?>? arguments) handler;

  const HubMethodHandler({
    required this.methodName,
    required this.argsCount,
    required this.handler,
  });
}
