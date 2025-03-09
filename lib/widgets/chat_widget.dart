import 'package:ai_improv/widgets/controllers/chat_widget_controller.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatefulWidget {
  final ChatWidgetController controller;

  const ChatWidget({super.key, required this.controller});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleChange);
    if (widget.controller.messages.isEmpty) {
      widget.controller.initializeDummyData();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleChange);
    super.dispose();
  }

  void _handleChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: widget.controller.messages.length,
      itemBuilder: (context, index) {
        final message = widget.controller.messages[index];
        return Row(
          mainAxisAlignment:
              message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Flexible(
              // Wrap in Flexible to allow proper constraints
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                padding: const EdgeInsets.all(12),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                ),
                decoration: BoxDecoration(
                  color:
                      message.isMe
                          ? const Color.fromARGB(255, 16, 84, 141)
                          : const Color.fromARGB(255, 137, 73, 73),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message.text,
                  softWrap: true,
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.clip, // Changed from visible to clip
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
