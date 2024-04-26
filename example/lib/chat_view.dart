import 'package:flutter/material.dart';

import 'message.dart';
import 'messages_list_view.dart';
import 'send_message_text_field.dart';

class ChatView extends StatelessWidget {
  final List<Message> m1Messages;
  final List<Message> m2Messages;
  final Future<void> Function(String messageText) onM1SendMessagePressed;
  final Future<void> Function(String messageText) onM2SendMessagePressed;
  final bool loading;
  final String connectionState;

  const ChatView({
    super.key,
    required this.m1Messages,
    required this.m2Messages,
    required this.onM1SendMessagePressed,
    required this.onM2SendMessagePressed,
    required this.loading,
    required this.connectionState,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(connectionState),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: MessagesListView(
                          messages: m1Messages,
                          backgroundColor: Colors.grey.shade400,
                        ),
                      ),
                      Expanded(
                        child: MessagesListView(
                          messages: m2Messages,
                          backgroundColor: Colors.grey.shade300,
                        ),
                      ),
                    ],
                  ),
                ),
                SendMessageTextField(
                  hintText: 'Enter a message for first hub',
                  onSendMessagePressed: onM1SendMessagePressed,
                ),
                SendMessageTextField(
                  hintText: 'Enter a message for second hub',
                  onSendMessagePressed: onM2SendMessagePressed,
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
        ),
      );
}
