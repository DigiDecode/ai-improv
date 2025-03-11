import 'package:ai_improv/models/character_model.dart';
import 'package:ai_improv/pages/controllers/home_page_controller.dart';
import 'package:ai_improv/widgets/chat_widget.dart';
import 'package:ai_improv/widgets/select_character_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomePageController _controller;
  bool _isStarted = false; // Added state variable for toggle
  CharacterModel? _firstCharacter;
  CharacterModel? _secondCharacter;
  final TextEditingController _scenarioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = HomePageController();
    _controller.initializeVoice();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scenarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top row (70% of screen)
        Expanded(
          flex: 7,
          child: Row(
            children: [
              // First column (25%) - First character selection
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'First Character',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SelectCharacterWidget(
                        onCharacterSelected: (character) {
                          setState(() {
                            _firstCharacter = character;
                          });
                          if (_firstCharacter != null) {
                            _controller.updateFirstCharacter(_firstCharacter!);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // Second column (50%)
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0, top: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _controller.resetChat();
                          },
                          child: const Text('Reset chat'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ChatWidget(controller: _controller.chatController),
                    ),
                  ],
                ),
              ),
              // Third column (25%) - Second character selection
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Second Character',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SelectCharacterWidget(
                        onCharacterSelected: (character) {
                          setState(() {
                            _secondCharacter = character;
                          });
                          if (_secondCharacter != null) {
                            _controller.updateSecondCharacter(
                              _secondCharacter!,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Bottom row (30% of screen)
        Expanded(
          flex: 3,
          child: Row(
            children: [
              // First column (75%) - Updated with TextField
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Scenario Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: TextField(
                          controller: _scenarioController,
                          maxLines: null,
                          expands: true,
                          decoration: const InputDecoration(
                            hintText: 'Enter scenario details here...',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Color.fromARGB(10, 255, 255, 255),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed:
                              () => {
                                _controller.setScenario(
                                  _scenarioController.text,
                                ),
                              },
                          child: Text("Apply Scenario"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Second column (25%) - Modified section
              Expanded(
                flex: 1,
                child: Container(
                  child: Center(
                    child: ElevatedButton(
                      onPressed:
                          (_firstCharacter != null && _secondCharacter != null)
                              ? () {
                                setState(() {
                                  _isStarted = !_isStarted;
                                });
                                // Add controller interaction here when ready:
                                if (_isStarted) {
                                  _controller.dialogueService?.start();
                                } else {
                                  _controller.dialogueService?.stop();
                                }
                              }
                              : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      child: Text(_isStarted ? 'Stop' : 'Start'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
