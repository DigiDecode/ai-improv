import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/api_exception.dart';
import '../models/chat_provider_model.dart';

enum ChatRole {
  system,
  user,
  assistant;

  String get name => toString().split('.').last;
}

class ChatProviderService {
  static const String _modelsPath = '/v1/models';
  static const String _chatCompletionPath = '/v1/chat/completions';
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  ChatProviderService();

  static Future<List<Model>> listModels(ChatProviderModel model) async {
    final response = await http.get(
      Uri.parse('${model.baseUrl}$_modelsPath'),
      headers: {..._headers, 'Authorization': 'Bearer ${model.apiKey}'},
    );

    if (response.statusCode != 200) {
      throw ApiException(
        'Failed to fetch models: ${response.statusCode}',
        response.statusCode,
      );
    }

    final data = jsonDecode(response.body);
    return (data['data'] as List)
        .map((model) => Model.fromJson(model))
        .toList();
  }

  // In lib/services/chat_provider_service.dart
  static Future<ChatCompletion> getChatCompletion({
    required ChatProviderModel chatProvider,
    required List<ChatMessage> messages,
    required String model,
    double temperature = 0.6,
    int maxTokens = 2000,
  }) async {
    final payload = jsonEncode({
      'model': model,
      'messages': messages.map((msg) => msg.toJson()).toList(),
      'temperature': temperature,
      'max_tokens': maxTokens,
    });

    final response = await http.post(
      Uri.parse('${chatProvider.baseUrl}$_chatCompletionPath'),
      headers: {..._headers, 'Authorization': 'Bearer ${chatProvider.apiKey}'},
      body: payload,
    );

    if (response.statusCode != 200) {
      throw ApiException(
        'Chat completion failed: ${response.statusCode}',
        response.statusCode,
      );
    }

    // Ensure proper UTF-8 decoding of the response body
    final decodedBody = utf8.decode(response.bodyBytes);
    print(decodedBody);

    return ChatCompletion.fromJson(jsonDecode(decodedBody));
  }
}

class Model {
  final String id;

  Model({required this.id});

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(id: json['id']);
  }
}

class ChatMessage {
  final ChatRole role;
  final String content;

  ChatMessage({required this.role, required this.content});

  Map<String, dynamic> toJson() => {'role': role.name, 'content': content};
}

class ChatCompletion {
  final String id;
  final String messageContent;

  ChatCompletion({required this.id, required this.messageContent});

  factory ChatCompletion.fromJson(Map<String, dynamic> json) {
    return ChatCompletion(
      id: json['id'],
      messageContent: json['choices'][0]['message']['content'],
    );
  }
}
