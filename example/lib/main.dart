import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fsignalr/fsignalr.dart';
import 'package:fsignalr_example/error_view.dart';

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
  Completer? _processingCompleter;

  final List<Message> _m1Messages = [];
  final List<Message> _m2Messages = [];

  late final HubConnectionManager _m1;
  late final HubConnectionManager _m2;

  static const String baseUrl = 'http:192.168.1.7:5094/chatHub';

  bool get _isProcessing => !(_processingCompleter?.isCompleted ?? true);

  @override
  void initState() {
    super.initState();
    _setupConnections()
        .then((_) => _startConnections())
        .then((_) => _stopConnections())
        .then((_) => _startConnections());
  }

  @override
  void dispose() {
    _disposeConnections();
    super.dispose();
  }

  Future<void> _setupConnections() async {
    if (_isProcessing) await _processingCompleter?.future;

    _processingCompleter = Completer();

    _performSetupConnections();

    return _processingCompleter?.future;
  }

  Future<void> _performSetupConnections() async {
    try {
      _m1 = await HubConnectionManager.createHubConnection(
        baseUrl: baseUrl,
        transportType: TransportType.all,
        headers: {'hubName': 'm1'},
        accessToken: 'm1Token',
        handShakeResponseTimeout: const Duration(seconds: 10),
        keepAliveInterval: const Duration(seconds: 20),
        serverTimeout: const Duration(seconds: 30),
      );

      _m2 = await HubConnectionManager.createHubConnection(
        baseUrl: baseUrl,
        transportType: TransportType.all,
        headers: {'hubName': 'm2'},
        accessToken: 'm2Token',
        handShakeResponseTimeout: const Duration(seconds: 10),
        keepAliveInterval: const Duration(seconds: 20),
        serverTimeout: const Duration(seconds: 30),
      );

      _processingCompleter?.complete();
    } catch (e) {
      _processingCompleter?.completeError(e);
    }
  }

  Future<void> _startConnections() async {
    if (_isProcessing) await _processingCompleter?.future;

    _processingCompleter = Completer();

    _performStartConnections();

    setState(() {});

    return _processingCompleter?.future;
  }

  Future<void> _performStartConnections() async {
    try {
      await _m1.startConnection();
      await _m2.startConnection();

      _processingCompleter?.complete();
    } catch (e) {
      _processingCompleter?.completeError(e);
    }
  }

  Future<void> _stopConnections() async {
    if (_isProcessing) await _processingCompleter?.future;

    _processingCompleter = Completer();

    _performStopConnections();

    setState(() {});

    return _processingCompleter?.future;
  }

  Future<void> _performStopConnections() async {
    try {
      await _m1.stopConnection();
      await _m2.stopConnection();

      _processingCompleter?.complete();
    } catch (e) {
      _processingCompleter?.completeError(e);
    }
  }

  Future<void> _disposeConnections() async {
    if (_isProcessing) await _processingCompleter?.future;

    _processingCompleter = Completer();

    _performCloseConnections();

    setState(() {});

    return _processingCompleter?.future;
  }

  Future<void> _performCloseConnections() async {
    try {
      await _m1.dispose();
      await _m2.dispose();

      _processingCompleter?.complete();
    } catch (e) {
      _processingCompleter?.completeError(e);
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: FutureBuilder(
            future: _processingCompleter?.future,
            builder: (context, snapshot) {
              final Widget chatView = MultiTabChatView(
                multiTabChatViewTabsData: [
                  MultiTabChatViewData(
                    messages: _m1Messages,
                    onSendMessagePressed: _onM1SendMessagePressed,
                    hubName: 'First Hub',
                  ),
                  MultiTabChatViewData(
                    messages: _m2Messages,
                    onSendMessagePressed: _onM2SendMessagePressed,
                    hubName: 'Second Hub',
                  ),
                ],
                loading: _isProcessing,
              );
              return switch (snapshot.connectionState) {
                ConnectionState.none ||
                ConnectionState.active ||
                ConnectionState.waiting =>
                  chatView,
                ConnectionState.done => snapshot.hasError
                    ? ErrorView(errorMessage: snapshot.error.toString())
                    : chatView,
              };
            },
          ),
        ),
      );

  Future<void> _onM1SendMessagePressed(String messageText) async {
    if (_isProcessing) await _processingCompleter?.future;

    _processingCompleter = Completer();

    _performSendMessage(
      hubConnectionManager: _m1,
      methodName: 'SendMessage',
      args: ['First Hub', messageText],
      uiMessagesList: _m1Messages,
    );

    setState(() {});

    return _processingCompleter?.future;
  }

  Future<void> _onM2SendMessagePressed(String messageText) async {
    if (_isProcessing) await _processingCompleter?.future;

    _processingCompleter = Completer();

    _performSendMessage(
      hubConnectionManager: _m2,
      methodName: 'SendMessage',
      args: ['Second Hub', messageText],
      uiMessagesList: _m2Messages,
    );

    setState(() {});

    return _processingCompleter?.future;
  }

  Future<void> _performSendMessage({
    required HubConnectionManager hubConnectionManager,
    required String methodName,
    required List<String?>? args,
    required List<Message> uiMessagesList,
  }) async {
    try {
      await hubConnectionManager.invoke(
        methodName: methodName,
        args: args,
      );

      _processingCompleter?.complete();

      uiMessagesList.add(
        Message(
          user: args?.elementAtOrNull(0),
          text: args?.elementAtOrNull(1),
        ),
      );
      setState(() {});
    } catch (e) {
      _processingCompleter?.completeError(e);
    }
  }
}
