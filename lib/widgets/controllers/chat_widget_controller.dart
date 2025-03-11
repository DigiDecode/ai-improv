import 'package:ai_improv/models/chat_message.dart';
import 'package:flutter/material.dart';

class ChatWidgetController extends ChangeNotifier {
  final List<ChatWidgetMessage> _messages = [];

  List<ChatWidgetMessage> get messages => _messages;

  void addMessage(ChatWidgetMessage message) {
    _messages.add(message);
    notifyListeners();
  }

  void resetChat() {
    _messages.clear();
    notifyListeners();
  }
}
