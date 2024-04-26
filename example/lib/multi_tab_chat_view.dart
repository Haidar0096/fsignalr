import 'package:flutter/material.dart';

import 'message.dart';
import 'messages_list_view.dart';
import 'send_message_text_field.dart';

class MultiTabChatView extends StatefulWidget {
  final List<MultiTabChatViewData> multiTabChatViewTabsData;
  final bool loading;

  const MultiTabChatView({
    super.key,
    required this.multiTabChatViewTabsData,
    required this.loading,
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
          hintText: 'Enter a message for ${tabData.hubName}',
          hubName: tabData.hubName,
          loading: widget.loading,
        ),
      )
      .toList();

  Widget _buildTab({
    required List<Message> messages,
    required Future<void> Function(String messageText) onSendMessagePressed,
    required String hintText,
    required String hubName,
    required bool loading,
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
                ),
              ),
              SendMessageTextField(
                hintText: hintText,
                onSendMessagePressed: onSendMessagePressed,
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
  final Future<void> Function(String messageText) onSendMessagePressed;
  final String hubName;

  const MultiTabChatViewData({
    required this.messages,
    required this.onSendMessagePressed,
    required this.hubName,
  });
}
