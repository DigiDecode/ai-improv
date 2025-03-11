import 'package:ai_improv/model_services/tts_provider_model_service.dart';
import 'package:ai_improv/models/tts_provider_model.dart';
import 'package:flutter/material.dart';

class TTSProvidersPageController {
  final TTSProviderModelService _ttsProviderModelService =
      TTSProviderModelService();

  // Stream controller to update the UI when TTS providers change
  final ValueNotifier<List<TTSProviderModel>> ttsProvidersNotifier =
      ValueNotifier<List<TTSProviderModel>>([]);

  // Method to fetch all saved TTS providers
  Future<void> loadTTSProviders() async {
    final providers = await _ttsProviderModelService.getAllTTSProviderModels();
    ttsProvidersNotifier.value = providers;
  }

  // Method to delete a TTS provider at a specific index
  Future<bool> deleteTTSProvider(int index) async {
    final result = await _ttsProviderModelService.deleteTTSProviderModel(index);
    if (result) {
      await loadTTSProviders();
    }
    return result;
  }

  // Method to get provider type as a displayable string
  String getProviderTypeString(TTSProvider provider) {
    switch (provider) {
      case TTSProvider.kokoroInBrowser:
        return 'Kokoro (In-Browser)';
      case TTSProvider.elevenLabs:
        return 'ElevenLabs';
      default:
        return 'Unknown';
    }
  }

  // Clean up resources when done
  void dispose() {
    ttsProvidersNotifier.dispose();
  }
}
