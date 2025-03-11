// lib/pages/chat_providers_page.dart
import 'package:flutter/material.dart';
import '../models/chat_provider_model.dart';
import '../model_services/chat_provider_model_service.dart';
import '../widgets/add_chat_provider_widget.dart';

class ChatProvidersPage extends StatefulWidget {
  const ChatProvidersPage({super.key});

  @override
  State<ChatProvidersPage> createState() => _ChatProvidersPageState();
}

class _ChatProvidersPageState extends State<ChatProvidersPage> {
  final ChatProviderModelService _modelService = ChatProviderModelService();
  List<ChatProviderModel> _providers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProviders();
  }

  Future<void> _loadProviders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final providers = await _modelService.getAllChatProviderModels();
      setState(() {
        _providers = providers;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading chat providers: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _providers.isEmpty
              ? _buildEmptyState()
              : _buildProvidersList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProviderDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No chat providers configured yet',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _showAddProviderDialog,
            child: const Text('Add Chat Provider'),
          ),
        ],
      ),
    );
  }

  Widget _buildProvidersList() {
    return ListView.builder(
      itemCount: _providers.length,
      itemBuilder: (context, index) {
        final provider = _providers[index];
        return ListTile(
          title: Text(provider.providerName ?? 'Unknown Provider'),
          subtitle: Text(provider.modelName ?? 'Unknown Model'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteProvider(index),
          ),
        );
      },
    );
  }

  Future<void> _deleteProvider(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Provider'),
            content: const Text(
              'Are you sure you want to delete this provider?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      await _modelService.deleteChatProviderModel(index);
      _loadProviders();
    }
  }

  void _showAddProviderDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: AddChatProviderWidget(
            onComplete: (success) {
              Navigator.pop(context);
              if (success) {
                _loadProviders();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chat provider added successfully'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to add chat provider')),
                );
              }
            },
          ),
        );
      },
    );
  }
}
