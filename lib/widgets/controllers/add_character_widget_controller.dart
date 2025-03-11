// lib/widgets/controllers/add_character_widget_controller.dart
import 'package:ai_improv/model_services/character_model_service.dart';
import 'package:ai_improv/model_services/chat_provider_model_service.dart';
import 'package:ai_improv/model_services/tts_provider_model_service.dart';
import 'package:ai_improv/models/character_model.dart';
import 'package:ai_improv/models/chat_provider_model.dart';
import 'package:ai_improv/models/tts_provider_model.dart';
import 'package:flutter/material.dart';

enum Gender { male, female, other }

class AddCharacterWidgetController extends ChangeNotifier {
  final CharacterModelService _characterService = CharacterModelService();
  final TTSProviderModelService _ttsProviderService = TTSProviderModelService();
  final ChatProviderModelService _chatProviderService =
      ChatProviderModelService();

  // Editing mode
  final bool isEditing;
  final CharacterModel? initialCharacter;
  final int? index;

  // Form key
  final formKey = GlobalKey<FormState>();

  // Form fields
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final goalController = TextEditingController();
  final ageController = TextEditingController();

  // Selected values
  Gender? selectedGender;
  TTSProviderModel? selectedVoiceProvider;
  ChatProviderModel? selectedChatProvider;

  // Loading states
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingVoices = true;
  bool get isLoadingVoices => _isLoadingVoices;

  bool _isLoadingChatModels = true;
  bool get isLoadingChatModels => _isLoadingChatModels;

  // Data lists
  List<TTSProviderModel> _voiceProviders = [];
  List<TTSProviderModel> get voiceProviders => _voiceProviders;

  List<ChatProviderModel> _chatProviders = [];
  List<ChatProviderModel> get chatProviders => _chatProviders;

  AddCharacterWidgetController({
    this.isEditing = false,
    this.initialCharacter,
    this.index,
  }) {
    _initializeController();
  }

  Future<void> _initializeController() async {
    await Future.wait([loadVoiceProviders(), loadChatProviders()]);

    if (isEditing && initialCharacter != null) {
      _populateFormWithExistingData();
    }
  }

  void _populateFormWithExistingData() {
    final character = initialCharacter!;
    nameController.text = character.name;
    descriptionController.text = character.description;
    goalController.text = character.goal;

    if (character.age != null) {
      ageController.text = character.age!;
    }

    if (character.gender != null) {
      switch (character.gender) {
        case 'Male':
          selectedGender = Gender.male;
          break;
        case 'Female':
          selectedGender = Gender.female;
          break;
        case 'Other':
          selectedGender = Gender.other;
          break;
      }
    }

    // Find and set the matching voice provider
    if (_voiceProviders.isNotEmpty) {
      for (var provider in _voiceProviders) {
        if (provider.voiceId == character.voiceProvider.voiceId) {
          selectedVoiceProvider = provider;
          break;
        }
      }
    }

    // Find and set the matching chat provider
    if (_chatProviders.isNotEmpty) {
      for (var provider in _chatProviders) {
        if (provider.modelName == character.chatProvider.modelName) {
          selectedChatProvider = provider;
          break;
        }
      }
    }

    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    goalController.dispose();
    ageController.dispose();
    super.dispose();
  }

  // Load available voice providers
  Future<void> loadVoiceProviders() async {
    _isLoadingVoices = true;
    notifyListeners();

    try {
      _voiceProviders = await _ttsProviderService.getAllTTSProviderModels();
    } catch (e) {
      debugPrint('Error loading voice providers: $e');
    } finally {
      _isLoadingVoices = false;
      notifyListeners();
    }
  }

  // Load available chat providers
  Future<void> loadChatProviders() async {
    _isLoadingChatModels = true;
    notifyListeners();

    try {
      _chatProviders = await _chatProviderService.getAllChatProviderModels();
    } catch (e) {
      debugPrint('Error loading chat providers: $e');
    } finally {
      _isLoadingChatModels = false;
      notifyListeners();
    }
  }

  // Set selected gender
  void setGender(Gender gender) {
    selectedGender = gender;
    notifyListeners();
  }

  // Set selected voice provider
  void setVoiceProvider(TTSProviderModel provider) {
    selectedVoiceProvider = provider;
    notifyListeners();
  }

  // Set selected chat provider
  void setChatProvider(ChatProviderModel provider) {
    selectedChatProvider = provider;
    notifyListeners();
  }

  // Check if form is valid and can be submitted
  bool get canSubmit {
    return selectedVoiceProvider != null &&
        selectedChatProvider != null &&
        nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        goalController.text.isNotEmpty;
  }

  // Get gender string from enum
  String? get genderString {
    if (selectedGender == null) return null;
    switch (selectedGender) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.other:
        return 'Other';
      default:
        return null;
    }
  }

  // Save a new character
  Future<bool> saveCharacter() async {
    if (!canSubmit) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final character = CharacterModel(
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        goal: goalController.text.trim(),
        gender: genderString,
        age: ageController.text.isEmpty ? null : ageController.text.trim(),
        voiceProvider: selectedVoiceProvider!,
        chatProvider: selectedChatProvider!,
      );

      final result = await _characterService.saveCharacterModel(character);
      return result;
    } catch (e) {
      debugPrint('Error saving character: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update an existing character
  Future<bool> updateCharacter() async {
    if (!canSubmit || index == null || initialCharacter == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final updatedCharacter = CharacterModel(
        id: initialCharacter!.id, // Keep the same ID
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        goal: goalController.text.trim(),
        gender: genderString,
        age: ageController.text.isEmpty ? null : ageController.text.trim(),
        voiceProvider: selectedVoiceProvider!,
        chatProvider: selectedChatProvider!,
      );

      final result = await _characterService.updateCharacterModel(
        index!,
        updatedCharacter,
      );
      return result;
    } catch (e) {
      debugPrint('Error updating character: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
