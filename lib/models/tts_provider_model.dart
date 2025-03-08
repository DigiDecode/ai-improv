import 'dart:convert';

enum TTSProvider { kokoroInBrowser, elevenLabs }

class TTSProviderModel {
  final TTSProvider provider;
  final String baseUrl;
  final String apiKey;

  TTSProviderModel({
    required this.provider,
    required this.baseUrl,
    required this.apiKey,
  });

  factory TTSProviderModel.fromJson(Map<String, dynamic> json) {
    return TTSProviderModel(
      provider: json['provider'] ?? '',
      baseUrl: json['baseUrl'] ?? '',
      apiKey: json['apiKey'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'provider': provider, 'baseUrl': baseUrl, 'apiKey': apiKey};
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
