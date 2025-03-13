// lib/widgets/controllers/add_chat_provider_widget_controller.dart
import 'package:flutter/material.dart';
import '../../models/chat_provider_model.dart';
import '../../services/chat_provider_service.dart';
import '../../model_services/chat_provider_model_service.dart';
import '../../utils/api_exception.dart';
import '../../utils/error_utils.dart'; // Import the error utils

class AddChatProviderWidgetController extends ChangeNotifier {
  final TextEditingController providerNameController = TextEditingController();
  final TextEditingController baseUrlController = TextEditingController();
  final TextEditingController apiKeyController = TextEditingController();
  final ChatProviderModelService _modelService = ChatProviderModelService();

  bool _isLoading = false;
  bool _isFirstPage = true;
  List<Model> _models = [];
  Model? _selectedModel;

  bool get isLoading => _isLoading;
  bool get isFirstPage => _isFirstPage;
  List<Model> get models => _models;
  Model? get selectedModel => _selectedModel;
  bool get canAdd => _selectedModel != null;

  void setOpenRouter() {
    providerNameController.text = 'OpenRouter';
    baseUrlController.text = 'https://openrouter.ai/api';
    apiKeyController.text = '';
    notifyListeners();
  }

  void setLMStudio() {
    providerNameController.text = 'LM Studio';
    baseUrlController.text = 'http://localhost:1234';
    apiKeyController.text = '';
    notifyListeners();
  }

  void setOllama() {
    providerNameController.text = 'Ollama';
    baseUrlController.text = 'http://localhost:11434';
    apiKeyController.text = '';
    notifyListeners();
  }

  void selectModel(Model model) {
    _selectedModel = model;
    notifyListeners();
  }

  Future<void> fetchModels(BuildContext context) async {
    if (providerNameController.text.isEmpty || baseUrlController.text.isEmpty) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final provider = ChatProviderModel(
        baseUrl: baseUrlController.text,
        apiKey: apiKeyController.text,
        providerName: providerNameController.text,
      );

      _models = await ChatProviderService.listModels(provider);
      _isFirstPage = false;
    } catch (e) {
      if (e is ApiException) {
        ErrorUtils.showErrorSnackbar(e, context);
      } else {
        ErrorUtils.showErrorSnackbar(
          ApiException('An unexpected error occurred.', 500, e.toString()),
          context,
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveProvider() async {
    if (providerNameController.text.isEmpty ||
        baseUrlController.text.isEmpty ||
        _selectedModel == null) {
      return false;
    }

    final provider = ChatProviderModel(
      baseUrl: baseUrlController.text,
      apiKey: apiKeyController.text,
      providerName: providerNameController.text,
      modelName: _selectedModel!.id,
      modelId: _selectedModel!.id,
    );

    return await _modelService.saveChatProviderModel(provider);
  }

  void reset() {
    _isFirstPage = true;
    _selectedModel = null;
    _models = [];
    notifyListeners();
  }

  @override
  void dispose() {
    providerNameController.dispose();
    baseUrlController.dispose();
    apiKeyController.dispose();
    super.dispose();
  }
}
