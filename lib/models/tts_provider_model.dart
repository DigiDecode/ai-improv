// lib/models/tts_provider_model.dart

enum TTSProvider { kokoroInBrowser, elevenLabs }

class TTSProviderModel {
  final TTSProvider provider;
  final String baseUrl;
  final String apiKey;
  final String? modelId;
  final String? voiceId;
  final String? providerName;
  final String? voiceName;

  TTSProviderModel({
    required this.provider,
    required this.baseUrl,
    required this.apiKey,
    this.modelId,
    this.voiceId,
    this.providerName,
    this.voiceName,
  });

  factory TTSProviderModel.fromJson(Map<String, dynamic> json) {
    return TTSProviderModel(
      // Convert string back to enum
      provider: _stringToTTSProvider(json['provider'] ?? ''),
      baseUrl: json['baseUrl'] ?? '',
      apiKey: json['apiKey'] ?? '',
      modelId: json['modelId'],
      voiceId: json['voiceId'],
      providerName: json['providerName'],
      voiceName: json['voiceName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // Convert enum to string
      'provider': provider.toString().split('.').last,
      'baseUrl': baseUrl,
      'apiKey': apiKey,
      'modelId': modelId,
      'voiceId': voiceId,
      'providerName': providerName,
      'voiceName': voiceName,
    };
  }

  // Helper method to convert string to TTSProvider enum
  static TTSProvider _stringToTTSProvider(String providerString) {
    switch (providerString) {
      case 'kokoroInBrowser':
        return TTSProvider.kokoroInBrowser;
      case 'elevenLabs':
        return TTSProvider.elevenLabs;
      default:
        // Default fallback
        return TTSProvider.kokoroInBrowser;
    }
  }
}
