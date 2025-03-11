import 'dart:convert';
import 'package:ai_improv/models/chat_provider_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatProviderModelService {
  static const String _storageKey = 'chat_provider_models';

  /// Fetches all stored chat provider models from persistent storage
  Future<List<ChatProviderModel>> getAllChatProviderModels() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedData = prefs.getString(_storageKey);

    if (storedData == null || storedData.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> jsonList = jsonDecode(storedData);
      return jsonList.map((json) => ChatProviderModel.fromJson(json)).toList();
    } catch (e) {
      print('Error retrieving chat provider models: $e');
      return [];
    }
  }

  /// Saves a new chat provider model to persistent storage
  Future<bool> saveChatProviderModel(ChatProviderModel model) async {
    try {
      final List<ChatProviderModel> existingModels =
          await getAllChatProviderModels();
      existingModels.add(model);
      return await _saveAllModels(existingModels);
    } catch (e) {
      print('Error saving chat provider model: $e');
      return false;
    }
  }

  /// Updates an existing chat provider model at the specified index
  Future<bool> updateChatProviderModel(
    int index,
    ChatProviderModel model,
  ) async {
    try {
      final List<ChatProviderModel> existingModels =
          await getAllChatProviderModels();
      if (index >= 0 && index < existingModels.length) {
        existingModels[index] = model;
        return await _saveAllModels(existingModels);
      }
      return false;
    } catch (e) {
      print('Error updating chat provider model: $e');
      return false;
    }
  }

  /// Removes a chat provider model at the specified index
  Future<bool> deleteChatProviderModel(int index) async {
    try {
      final List<ChatProviderModel> existingModels =
          await getAllChatProviderModels();
      if (index >= 0 && index < existingModels.length) {
        existingModels.removeAt(index);
        return await _saveAllModels(existingModels);
      }
      return false;
    } catch (e) {
      print('Error deleting chat provider model: $e');
      return false;
    }
  }

  /// Saves all models to persistent storage
  Future<bool> _saveAllModels(List<ChatProviderModel> models) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList =
        models.map((model) => model.toJson()).toList();
    return await prefs.setString(_storageKey, jsonEncode(jsonList));
  }

  /// Clears all chat provider models from storage
  Future<bool> clearAllChatProviderModels() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_storageKey);
    } catch (e) {
      print('Error clearing chat provider models: $e');
      return false;
    }
  }

  /// Gets a specific chat provider model by index
  Future<ChatProviderModel?> getChatProviderModelByIndex(int index) async {
    final models = await getAllChatProviderModels();
    if (index >= 0 && index < models.length) {
      return models[index];
    }
    return null;
  }
}
