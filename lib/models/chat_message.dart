class ChatWidgetMessage {
  final String name;
  final String text;
  final bool isMe;
  final DateTime timestamp;

  ChatWidgetMessage({
    required this.name,
    required this.text,
    required this.isMe,
    required this.timestamp,
  });
}
