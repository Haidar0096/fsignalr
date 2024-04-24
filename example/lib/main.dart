import 'package:flutter/material.dart';
import 'package:fsignalr/fsignalr.dart';

import 'chat_view.dart';
import 'message.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Future? _processFuture;

  final List<Message> _messages = [];

  bool _loading = false;

  String _connectionState = 'Disconnected';

  @override
  void initState() {
    super.initState();
    _startProcess();
  }

  Future<void> _startProcess() async {
    _processFuture = Future.delayed(const Duration(seconds: 1));

    HubConnectionManager h1 = HubConnectionManager();
    await h1.createHubConnection(
      baseUrl: 'http://192.168.1.7:5094/chatHub',
      transportType: TransportType.all,
      headers: {'token': '123'},
      accessToken: '123',
      handleShakeResponseTimeoutInMilliseconds: 10000,
      keepAliveIntervalInMilliSeconds: 20000,
      serverTimeoutInMilliSeconds: 30000,
    );
    await h1.startConnection();

    HubConnectionManager h2 = HubConnectionManager();
    await h2.createHubConnection(
      baseUrl: 'http://192.168.1.7:5094/chatHub',
      transportType: TransportType.all,
      headers: {'token': '123'},
      accessToken: '123',
      handleShakeResponseTimeoutInMilliseconds: 10000,
      keepAliveIntervalInMilliSeconds: 20000,
      serverTimeoutInMilliSeconds: 30000,
    );
    await h2.startConnection();

    setState(() {
      _connectionState = 'Connected';
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: SafeArea(
          child: Scaffold(
            body: FutureBuilder(
              future: _processFuture,
              builder: (context, snapshot) {
                final Widget chatView = ChatView(
                  messages: _messages,
                  loading: _loading,
                  connectionState: _connectionState,
                  onSendMessagePressed: _onSendMessagePressed,
                );
                return switch (snapshot.connectionState) {
                  ConnectionState.none ||
                  ConnectionState.active ||
                  ConnectionState.waiting =>
                    chatView,
                  ConnectionState.done => snapshot.hasError
                      ? Center(child: Text('Error: ${snapshot.error}'))
                      : chatView,
                };
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _startProcess,
              child: const Icon(Icons.refresh),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerTop,
          ),
        ),
      );

  Future<void> _onSendMessagePressed(messageText) async {
    setState(() {
      _loading = true;

      Future.delayed(const Duration(seconds: 1)).then((_) {
        _messages.add(Message(text: messageText, user: 'Android'));

        _loading = false;

        setState(() {});
      });
    });
  }
}
