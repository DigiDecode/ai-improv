import 'package:ai_improv/models/tts_provider_model.dart';
import 'package:ai_improv/pages/controllers/tts_providers_page_controller.dart';
import 'package:ai_improv/widgets/add_kokoro_provider_widget.dart';
import 'package:flutter/material.dart';

class TTSProvidersPage extends StatefulWidget {
  const TTSProvidersPage({super.key});

  @override
  State<TTSProvidersPage> createState() => _TTSProvidersPageState();
}

class _TTSProvidersPageState extends State<TTSProvidersPage> {
  final TTSProvidersPageController _controller = TTSProvidersPageController();

  @override
  void initState() {
    super.initState();
    _controller.loadTTSProviders();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<List<TTSProviderModel>>(
        valueListenable: _controller.ttsProvidersNotifier,
        builder: (context, providers, _) {
          if (providers.isEmpty) {
            return const Center(
              child: Text(
                'No TTS providers saved',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: providers.length,
            itemBuilder: (context, index) {
              final provider = providers[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _buildCardTitle(provider),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _showDeleteConfirmationDialog(context, index);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'Type',
                        _controller.getProviderTypeString(provider.provider),
                      ),
                      if (provider.baseUrl.isNotEmpty)
                        _buildInfoRow('Base URL', provider.baseUrl),
                      if (provider.modelId != null)
                        _buildInfoRow('Model ID', provider.modelId!),
                      if (provider.voiceId != null)
                        _buildInfoRow('Voice ID', provider.voiceId!),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the AddKokoroProviderWidget
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddKokoroProviderWidget(),
            ),
          ).then((_) {
            // Refresh the list when returning from the add page
            _controller.loadTTSProviders();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _buildCardTitle(TTSProviderModel provider) {
    final voiceName = provider.voiceName ?? 'Unnamed Voice';
    final providerName = provider.providerName ?? 'Unnamed Provider';
    return '$voiceName - $providerName';
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete TTS Provider'),
          content: const Text(
            'Are you sure you want to delete this TTS provider?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final result = await _controller.deleteTTSProvider(index);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        result
                            ? 'TTS provider deleted successfully'
                            : 'Failed to delete TTS provider',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
