import 'dart:convert';

class ChatProviderModel {
  final String baseUrl;
  final String apiKey;
  final String? providerName;
  final String? modelName;
  final String? modelId;

  ChatProviderModel({
    required this.baseUrl,
    required this.apiKey,
    this.providerName,
    this.modelName,
    this.modelId,
  });

  factory ChatProviderModel.fromJson(Map<String, dynamic> json) {
    return ChatProviderModel(
      baseUrl: json['baseUrl'] ?? '',
      apiKey: json['apiKey'] ?? '',
      providerName: json['providerName'],
      modelName: json['modelName'],
      modelId: json['modelId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'baseUrl': baseUrl,
      'apiKey': apiKey,
      'providerName': providerName,
      'modelName': modelName,
      'modelId': modelId,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
