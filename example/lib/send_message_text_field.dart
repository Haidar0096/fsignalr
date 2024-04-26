import 'package:flutter/material.dart';

class SendMessageTextField extends StatefulWidget {
  final void Function(String messageText) onSendMessagePressed;
  final String hintText;

  const SendMessageTextField({
    super.key,
    required this.onSendMessagePressed,
    required this.hintText,
  });

  @override
  State<SendMessageTextField> createState() => _SendMessageTextFieldState();
}

class _SendMessageTextFieldState extends State<SendMessageTextField> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  border: const OutlineInputBorder(
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
      );
}
