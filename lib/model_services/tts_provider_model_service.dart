import 'dart:convert';
import 'package:ai_improv/models/tts_provider_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TTSProviderModelService {
  static const String _storageKey = 'tts_provider_models';

  /// Fetches all stored TTS provider models from persistent storage
  Future<List<TTSProviderModel>> getAllTTSProviderModels() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedData = prefs.getString(_storageKey);

    if (storedData == null || storedData.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> jsonList = jsonDecode(storedData);
      return jsonList.map((json) => TTSProviderModel.fromJson(json)).toList();
    } catch (e) {
      print('Error retrieving TTS provider models: $e');
      return [];
    }
  }

  /// Saves a new TTS provider model to persistent storage
  Future<bool> saveTTSProviderModel(TTSProviderModel model) async {
    try {
      final List<TTSProviderModel> existingModels =
          await getAllTTSProviderModels();
      existingModels.add(model);
      return await _saveAllModels(existingModels);
    } catch (e) {
      print('Error saving TTS provider model: $e');
      return false;
    }
  }

  /// Updates an existing TTS provider model at the specified index
  Future<bool> updateTTSProviderModel(int index, TTSProviderModel model) async {
    try {
      final List<TTSProviderModel> existingModels =
          await getAllTTSProviderModels();
      if (index >= 0 && index < existingModels.length) {
        existingModels[index] = model;
        return await _saveAllModels(existingModels);
      }
      return false;
    } catch (e) {
      print('Error updating TTS provider model: $e');
      return false;
    }
  }

  /// Removes a TTS provider model at the specified index
  Future<bool> deleteTTSProviderModel(int index) async {
    try {
      final List<TTSProviderModel> existingModels =
          await getAllTTSProviderModels();
      if (index >= 0 && index < existingModels.length) {
        existingModels.removeAt(index);
        return await _saveAllModels(existingModels);
      }
      return false;
    } catch (e) {
      print('Error deleting TTS provider model: $e');
      return false;
    }
  }

  /// Saves all models to persistent storage
  Future<bool> _saveAllModels(List<TTSProviderModel> models) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList =
        models.map((model) => model.toJson()).toList();
    return await prefs.setString(_storageKey, jsonEncode(jsonList));
  }

  /// Clears all TTS provider models from storage
  Future<bool> clearAllTTSProviderModels() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_storageKey);
    } catch (e) {
      print('Error clearing TTS provider models: $e');
      return false;
    }
  }

  /// Gets a specific TTS provider model by index
  Future<TTSProviderModel?> getTTSProviderModelByIndex(int index) async {
    final models = await getAllTTSProviderModels();
    if (index >= 0 && index < models.length) {
      return models[index];
    }
    return null;
  }
}
