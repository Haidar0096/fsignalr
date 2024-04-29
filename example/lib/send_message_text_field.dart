import 'package:flutter/material.dart';
import 'package:fsignalr/fsignalr.dart';

class SendMessageTextField extends StatefulWidget {
  final Future<void> Function({
    required String hubMethodName,
    required String messageText,
  }) onSendMessagePressed;
  final String hintText;
  final List<HandledHubMethod> handledHubMethods;

  const SendMessageTextField({
    super.key,
    required this.onSendMessagePressed,
    required this.hintText,
    required this.handledHubMethods,
  });

  @override
  State<SendMessageTextField> createState() => _SendMessageTextFieldState();
}

class _SendMessageTextFieldState extends State<SendMessageTextField> {
  final TextEditingController _messageController = TextEditingController();
  late HandledHubMethod _selectedHandledHubMethod;

  @override
  void initState() {
    super.initState();
    _selectedHandledHubMethod = widget.handledHubMethods.first;
  }

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
              child: Row(
                children: [
                  Expanded(
                    flex: 80,
                    child: _buildTextField(),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    flex: 20,
                    child: _buildDropdownButton(),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              widget.onSendMessagePressed(
                messageText: _messageController.text,
                hubMethodName: _selectedHandledHubMethod.methodName,
              );
            },
          ),
        ],
      );

  Widget _buildDropdownButton() => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: DropdownButton<HandledHubMethod>(
          value: _selectedHandledHubMethod,
          onChanged: (HandledHubMethod? value) {
            if (value != null) {
              setState(() => _selectedHandledHubMethod = value);
            }
          },
          underline: Container(),
          items: widget.handledHubMethods
              .map(
                (HandledHubMethod handledHubMethod) =>
                    DropdownMenuItem<HandledHubMethod>(
                  value: handledHubMethod,
                  child: Center(child: Text(handledHubMethod.methodName)),
                ),
              )
              .toList(),
          isExpanded: true,
        ),
      );

  Widget _buildTextField() => TextField(
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
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      );
}
