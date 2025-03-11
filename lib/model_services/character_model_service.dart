import 'dart:convert';
import 'package:ai_improv/models/character_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CharacterModelService {
  static const String _storageKey = 'character_models';

  /// Fetches all stored character models from persistent storage
  Future<List<CharacterModel>> getAllCharacterModels() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedData = prefs.getString(_storageKey);

    if (storedData == null || storedData.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> jsonList = jsonDecode(storedData);
      return jsonList.map((json) => CharacterModel.fromJson(json)).toList();
    } catch (e) {
      print('Error retrieving character models: $e');
      return [];
    }
  }

  /// Saves a new character model to persistent storage
  Future<bool> saveCharacterModel(CharacterModel model) async {
    try {
      final List<CharacterModel> existingModels = await getAllCharacterModels();
      existingModels.add(model);
      return await _saveAllModels(existingModels);
    } catch (e) {
      print('Error saving character model: $e');
      return false;
    }
  }

  /// Updates an existing character model at the specified index
  Future<bool> updateCharacterModel(int index, CharacterModel model) async {
    try {
      final List<CharacterModel> existingModels = await getAllCharacterModels();
      if (index >= 0 && index < existingModels.length) {
        existingModels[index] = model;
        return await _saveAllModels(existingModels);
      }
      return false;
    } catch (e) {
      print('Error updating character model: $e');
      return false;
    }
  }

  /// Removes a character model at the specified index
  Future<bool> deleteCharacterModel(int index) async {
    try {
      final List<CharacterModel> existingModels = await getAllCharacterModels();
      if (index >= 0 && index < existingModels.length) {
        existingModels.removeAt(index);
        return await _saveAllModels(existingModels);
      }
      return false;
    } catch (e) {
      print('Error deleting character model: $e');
      return false;
    }
  }

  /// Saves all models to persistent storage
  Future<bool> _saveAllModels(List<CharacterModel> models) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList =
        models.map((model) => model.toJson()).toList();
    return await prefs.setString(_storageKey, jsonEncode(jsonList));
  }

  /// Clears all character models from storage
  Future<bool> clearAllCharacterModels() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_storageKey);
    } catch (e) {
      print('Error clearing character models: $e');
      return false;
    }
  }

  /// Gets a specific character model by index
  Future<CharacterModel?> getCharacterModelByIndex(int index) async {
    final models = await getAllCharacterModels();
    if (index >= 0 && index < models.length) {
      return models[index];
    }
    return null;
  }

  /// Gets a specific character model by name
  Future<CharacterModel?> getCharacterModelByName(String name) async {
    final models = await getAllCharacterModels();
    try {
      return models.firstWhere((model) => model.name == name);
    } catch (e) {
      return null;
    }
  }
}
