import 'dart:convert';
import 'package:ai_improv/utils/constants.dart';
import 'package:http/http.dart' as http;

import '../utils/api_exception.dart';

class ElevenLabsService {
  final String apiKey;
  final String baseUrl = Constants.elevenLabsBaseUrl;

  ElevenLabsService({required this.apiKey});

  // Get available voices
  Future<Map<String, dynamic>> getVoices() async {
    final response = await http.get(
      Uri.parse('$baseUrl/voices'),
      headers: {'xi-api-key': apiKey, 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw ApiException(
        'Failed to load voices: ${response.body}',
        response.statusCode,
      );
    }
  }

  // Text to speech conversion
  Future<String> textToSpeech({
    required String text,
    required String voiceId,
    Map<String, dynamic>? voiceSettings,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/text-to-speech/$voiceId'),
      headers: {'xi-api-key': apiKey, 'Content-Type': 'application/json'},
      body: json.encode({'text': text, 'model_id': 'eleven_monolingual_v1'}),
    );

    if (response.statusCode == 200) {
      return base64Encode(response.bodyBytes);
    } else {
      throw ApiException(
        'Failed to convert text to speech: ${response.body}',
        response.statusCode,
      );
    }
  }
}
