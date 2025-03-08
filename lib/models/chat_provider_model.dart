import 'dart:convert';

class ChatProviderModel {
  final String baseUrl;
  final String apiKey;

  ChatProviderModel({required this.baseUrl, required this.apiKey});

  factory ChatProviderModel.fromJson(Map<String, dynamic> json) {
    return ChatProviderModel(
      baseUrl: json['baseUrl'] ?? '',
      apiKey: json['apiKey'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'baseUrl': baseUrl, 'apiKey': apiKey};
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
