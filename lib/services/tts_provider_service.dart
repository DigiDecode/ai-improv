// lib/services/tts_provider_service.dart
import '../models/tts_provider_model.dart';
import '../services/elevenlab_service.dart';
import '../utils/api_exception.dart';

class TTSProviderService {
  late final Map<TTSProvider, dynamic> _providers;

  TTSProviderService() {
    _providers = {};
  }

  // Initialize a specific TTS provider
  void initializeProvider(TTSProviderModel providerModel) {
    switch (providerModel.provider) {
      case TTSProvider.elevenLabs:
        _providers[TTSProvider.elevenLabs] = ElevenLabsService(
          apiKey: providerModel.apiKey,
        );
        break;
      case TTSProvider.kokoroInBrowser:
        // Initialize Kokoro provider when implemented
        break;
      default:
        throw ArgumentError(
          'Unsupported TTS provider: ${providerModel.provider}',
        );
    }
  }

  // Get available voices for a provider
  Future<Map<String, dynamic>> getVoices(TTSProviderModel providerModel) async {
    _ensureProviderInitialized(providerModel.provider);

    switch (providerModel.provider) {
      case TTSProvider.elevenLabs:
        final elevenLabs =
            _providers[TTSProvider.elevenLabs] as ElevenLabsService;
        return await elevenLabs.getVoices();
      case TTSProvider.kokoroInBrowser:
        // Implement when Kokoro provider is added
        throw UnimplementedError('Kokoro provider not yet implemented');
      default:
        throw ArgumentError(
          'Unsupported TTS provider: ${providerModel.provider}',
        );
    }
  }

  // Text to speech conversion
  Future<String> textToSpeech({
    required TTSProviderModel providerModel,
    required String text,
    required String voiceId,
    Map<String, dynamic>? voiceSettings,
  }) async {
    _ensureProviderInitialized(providerModel.provider);

    switch (providerModel.provider) {
      case TTSProvider.elevenLabs:
        final elevenLabs =
            _providers[TTSProvider.elevenLabs] as ElevenLabsService;
        return await elevenLabs.textToSpeech(
          text: text,
          voiceId: voiceId,
          voiceSettings: voiceSettings,
        );
      case TTSProvider.kokoroInBrowser:
        // Implement when Kokoro provider is added
        throw UnimplementedError('Kokoro provider not yet implemented');
      default:
        throw ArgumentError(
          'Unsupported TTS provider: ${providerModel.provider}',
        );
    }
  }

  // Helper method to ensure provider is initialized
  void _ensureProviderInitialized(TTSProvider provider) {
    if (!_providers.containsKey(provider)) {
      throw ApiException(
        'TTS provider $provider not initialized. Call initializeProvider first.',
        500,
      );
    }
  }

  // Cleanup providers if needed
  void dispose() {
    _providers.clear();
  }
}
