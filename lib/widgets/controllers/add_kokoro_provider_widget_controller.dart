import 'package:ai_improv/model_services/tts_provider_model_service.dart';
import 'package:ai_improv/models/tts_provider_model.dart';
import 'package:ai_improv/utils/kokoro_voice.dart';
import 'package:ai_improv/utils/kokoro_voices.dart';
import 'package:flutter/material.dart';

class AddKokoroProviderWidgetController extends ChangeNotifier {
  final TTSProviderModelService _ttsProviderModelService =
      TTSProviderModelService();

  // List of all available voices
  final List<KokoroVoice> availableVoices = KokoroVoices.voices;

  // Currently selected voice
  KokoroVoice? _selectedVoice;
  KokoroVoice? get selectedVoice => _selectedVoice;

  // Filter options
  String _language = 'all';
  String get language => _language;

  String _gender = 'all';
  String get gender => _gender;

  // Helper getters
  bool get isVoiceSelected => _selectedVoice != null;

  // Get filtered voices based on current filters
  List<KokoroVoice> get filteredVoices {
    List<KokoroVoice> result = availableVoices;

    if (_language != 'all') {
      result = result.where((voice) => voice.language == _language).toList();
    }

    if (_gender != 'all') {
      result = result.where((voice) => voice.gender == _gender).toList();
    }

    return result;
  }

  // Set language filter
  void setLanguage(String language) {
    _language = language;
    notifyListeners();
  }

  // Set gender filter
  void setGender(String gender) {
    _gender = gender;
    notifyListeners();
  }

  // Select a voice
  void selectVoice(KokoroVoice voice) {
    _selectedVoice = voice;
    notifyListeners();
  }

  // Clear selected voice
  void clearSelection() {
    _selectedVoice = null;
    notifyListeners();
  }

  // Add the selected voice as a TTS provider
  Future<bool> addSelectedVoice() async {
    if (_selectedVoice == null) {
      return false;
    }

    // Create a new TTS provider model
    final model = TTSProviderModel(
      provider: TTSProvider.kokoroInBrowser,
      baseUrl: '', // No base URL needed for Kokoro in-browser
      apiKey: '', // No API key needed for Kokoro in-browser
      voiceId: _selectedVoice!.voiceId,
      providerName: 'Kokoro',
      voiceName: selectedVoice?.name,
    );

    // Save the model
    final result = await _ttsProviderModelService.saveTTSProviderModel(model);

    if (result) {
      // Clear selection after successful save
      clearSelection();
    }

    return result;
  }

  // Get available languages from the voices list
  List<String> get availableLanguages {
    final Set<String> languages = {'all'};
    for (var voice in availableVoices) {
      languages.add(voice.language);
    }
    return languages.toList()..sort();
  }

  // Get available genders from the voices list
  List<String> get availableGenders {
    final Set<String> genders = {'all'};
    for (var voice in availableVoices) {
      genders.add(voice.gender);
    }
    return genders.toList()..sort();
  }
}
