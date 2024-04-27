import 'package:flutter/material.dart';
import 'package:fsignalr/fsignalr.dart';

import 'message.dart';
import 'messages_list_view.dart';
import 'send_message_text_field.dart';

class MultiTabChatView extends StatefulWidget {
  final List<MultiTabChatViewData> multiTabChatViewTabsData;

  const MultiTabChatView({
    super.key,
    required this.multiTabChatViewTabsData,
  });

  @override
  State<MultiTabChatView> createState() => _MultiTabChatViewState();
}

class _MultiTabChatViewState extends State<MultiTabChatView> {
  List<Widget> get _tabs => widget.multiTabChatViewTabsData
      .map(
        (tabData) => _buildTab(
          messages: tabData.messages,
          onSendMessagePressed: tabData.onSendMessagePressed,
          handledHubMethods: tabData.handledHubMethods,
          hintText: 'Enter a message for ${tabData.hubName}',
          hubName: tabData.hubName,
          loading: tabData.loading,
          connectionState: tabData.connectionState,
          onReloadIconPressed: tabData.onReloadIconPressed,
        ),
      )
      .toList();

  Widget _buildTab({
    required List<Message> messages,
    required Future<void> Function({
      required String hubMethodName,
      required String messageText,
    }) onSendMessagePressed,
    required List<HandledHubMethod> handledHubMethods,
    required String hintText,
    required String hubName,
    required bool loading,
    required HubConnectionState connectionState,
    void Function()? onReloadIconPressed,
  }) =>
      Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: MessagesListView(
                  hubName: hubName,
                  messages: messages,
                  backgroundColor: Colors.grey.shade400,
                  connectionState: connectionState,
                  onReloadIconPressed: onReloadIconPressed,
                ),
              ),
              SendMessageTextField(
                hintText: hintText,
                onSendMessagePressed: onSendMessagePressed,
                handledHubMethods: handledHubMethods,
              ),
            ],
          ),
          if (loading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: DefaultTabController(
          length: _tabs.length,
          initialIndex: 0,
          child: TabBarView(
            children: _tabs,
          ),
        ),
      );
}

class MultiTabChatViewData {
  final List<Message> messages;
  final Future<void> Function({
    required String hubMethodName,
    required String messageText,
  }) onSendMessagePressed;
  final List<HandledHubMethod> handledHubMethods;
  final String hubName;
  final HubConnectionState connectionState;
  final bool loading;
  final void Function()? onReloadIconPressed;

  const MultiTabChatViewData({
    required this.messages,
    required this.onSendMessagePressed,
    required this.handledHubMethods,
    required this.hubName,
    required this.connectionState,
    required this.loading,
    this.onReloadIconPressed,
  });
}
