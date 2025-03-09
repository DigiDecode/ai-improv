import 'package:ai_improv/pages/controllers/home_controller.dart';
import 'package:ai_improv/widgets/chat_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController _controller;
  bool _isStarted = false; // Added state variable for toggle

  @override
  void initState() {
    super.initState();
    _controller = HomeController();
    _controller.initializeVoice();
  }

  @override
  void dispose() {
    _controller.dispose();
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
              // First column (25%)
              Expanded(
                flex: 1,
                child: Container(color: Colors.red.withOpacity(0.2)),
              ),
              // Second column (50%)
              Expanded(
                flex: 2,
                child: ChatWidget(controller: _controller.chatController),
              ),
              // Third column (25%)
              Expanded(
                flex: 1,
                child: Container(color: Colors.blue.withOpacity(0.2)),
              ),
            ],
          ),
        ),
        // Bottom row (30% of screen)
        Expanded(
          flex: 3,
          child: Row(
            children: [
              // First column (75%)
              Expanded(
                flex: 3,
                child: Container(color: Colors.yellow.withOpacity(0.2)),
              ),
              // Second column (25%) - Modified section
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.purple.withOpacity(0.2),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isStarted = !_isStarted;
                        });
                        // Add controller interaction here when ready:
                        if (_isStarted) {
                          _controller.dialogueService?.start();
                        } else {
                          _controller.dialogueService?.stop();
                        }
                      },
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
