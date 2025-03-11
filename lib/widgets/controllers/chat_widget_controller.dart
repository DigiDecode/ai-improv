import 'package:ai_improv/models/chat_message.dart';
import 'package:flutter/material.dart';

class ChatWidgetController extends ChangeNotifier {
  final List<ChatWidgetMessage> _messages = [];

  List<ChatWidgetMessage> get messages => _messages;

  void addMessage(ChatWidgetMessage message) {
    _messages.add(message);
    notifyListeners();
  }

  void initializeDummyData() {
    // _messages.addAll([
    //   ChatWidgetMessage(
    //     text: 'Hello! How are you?',
    //     isMe: false,
    //     timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    //   ),
    //   ChatWidgetMessage(
    //     text: 'I\'m good, thanks!',
    //     isMe: true,
    //     timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
    //   ),
    //   ChatWidgetMessage(
    //     text: 'What are you up to?',
    //     isMe: false,
    //     timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
    //   ),
    // ]);
    notifyListeners();
  }

  void resetChat() {
    _messages.clear();
    notifyListeners();
  }
}
