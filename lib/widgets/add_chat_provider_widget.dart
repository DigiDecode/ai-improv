// lib/widgets/add_chat_provider_widget.dart
import 'package:flutter/material.dart';
import 'controllers/add_chat_provider_widget_controller.dart';

class AddChatProviderWidget extends StatefulWidget {
  final Function(bool) onComplete;

  const AddChatProviderWidget({super.key, required this.onComplete});

  @override
  State<AddChatProviderWidget> createState() => _AddChatProviderWidgetState();
}

class _AddChatProviderWidgetState extends State<AddChatProviderWidget>
    with SingleTickerProviderStateMixin {
  final AddChatProviderWidgetController _controller =
      AddChatProviderWidgetController();
  late AnimationController _animationController;
  late Animation<Offset> _pageOneAnimation;
  late Animation<Offset> _pageTwoAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _pageOneAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _pageTwoAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _controller.addListener(() {
      setState(() {});
      if (!_controller.isFirstPage &&
          _animationController.status != AnimationStatus.completed) {
        _animationController.forward();
      } else if (_controller.isFirstPage &&
          _animationController.status != AnimationStatus.dismissed) {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTitle(),
          const SizedBox(height: 16),
          Expanded(
            child: Stack(
              children: [
                SlideTransition(
                  position: _pageOneAnimation,
                  child: _buildProviderForm(),
                ),
                SlideTransition(
                  position: _pageTwoAnimation,
                  child: _buildModelsList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _controller.isFirstPage ? 'Add Chat Provider' : 'Select Model',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }

  Widget _buildProviderForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildQuickOptionButtons(),
        const SizedBox(height: 24),
        TextField(
          controller: _controller.providerNameController,
          decoration: const InputDecoration(
            labelText: 'Provider Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _controller.baseUrlController,
          decoration: const InputDecoration(
            labelText: 'Base URL',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _controller.apiKeyController,
          decoration: const InputDecoration(
            labelText: 'API Key',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        const Spacer(),
        Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton(
            onPressed: () {
              _controller.fetchModels();
            },
            child: const Text('Next'),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickOptionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: _controller.setOpenRouter,
          child: const Text('OpenRouter'),
        ),
        ElevatedButton(
          onPressed: _controller.setLMStudio,
          child: const Text('LM Studio'),
        ),
        ElevatedButton(
          onPressed: _controller.setOllama,
          child: const Text('Ollama'),
        ),
      ],
    );
  }

  Widget _buildModelsList() {
    if (_controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child:
              _controller.models.isEmpty
                  ? const Center(child: Text('No models found'))
                  : ListView.builder(
                    itemCount: _controller.models.length,
                    itemBuilder: (context, index) {
                      final model = _controller.models[index];
                      final isSelected =
                          _controller.selectedModel?.id == model.id;

                      return ListTile(
                        title: Text(model.id),
                        trailing:
                            isSelected
                                ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                                : null,
                        selected: isSelected,
                        onTap: () => _controller.selectModel(model),
                      );
                    },
                  ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                _controller.reset();
              },
              child: const Text('Back'),
            ),
            ElevatedButton(
              onPressed:
                  _controller.canAdd
                      ? () async {
                        final success = await _controller.saveProvider();
                        widget.onComplete(success);
                      }
                      : null,
              child: const Text('Add'),
            ),
          ],
        ),
      ],
    );
  }
}
