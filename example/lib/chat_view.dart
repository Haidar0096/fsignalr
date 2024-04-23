import 'package:flutter/material.dart';

import 'message.dart';

class ChatView extends StatefulWidget {
  final List<Message> messages;
  final Future<void> Function(String messageText) onSendMessagePressed;
  final bool loading;
  final String connectionState;

  const ChatView({
    super.key,
    required this.messages,
    required this.onSendMessagePressed,
    required this.loading,
    required this.connectionState,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.connectionState,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: widget.messages.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(
                      _getMessageDisplayText(widget.messages[index].text),
                    ),
                    subtitle: Text(
                      widget.messages[index].user ?? '[Unknown user]',
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Enter a message',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        onTapOutside: (_) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      widget.onSendMessagePressed(_messageController.text);
                      _messageController.clear();
                    },
                  ),
                ],
              ),
            ],
          ),
          if (widget.loading)
            const Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
        ],
      );

  String _getMessageDisplayText(String? messageText) {
    if (messageText == null || messageText.isEmpty) {
      return '[Empty message]';
    }
    return messageText;
  }
}
