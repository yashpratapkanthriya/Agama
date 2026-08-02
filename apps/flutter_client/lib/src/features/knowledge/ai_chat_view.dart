import 'package:flutter/material.dart';
import '../../core/app_tokens.dart';

class AiChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  AiChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class AiChatView extends StatefulWidget {
  const AiChatView({super.key});

  @override
  State<AiChatView> createState() => _AiChatViewState();
}

class _AiChatViewState extends State<AiChatView> {
  final List<AiChatMessage> _messages = [
    AiChatMessage(
      text: 'Ask me anything about your loaded document.',
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ];

  final TextEditingController _inputController = TextEditingController();

  void _sendMessage() {
    final query = _inputController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _messages.add(AiChatMessage(
        text: query,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _inputController.clear();
    });

    // Simulated RAG local AI response
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        _messages.add(AiChatMessage(
          text: 'Based on semantic vector search of your document: "$query" relates to local-first zero-backend execution with 384-dimensional embeddings.',
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('AI Document Assistant')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppTokens.spaceMd),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Card(
                    color: msg.isUser
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.surfaceContainerHighest,
                    child: Padding(
                      padding: const EdgeInsets.all(AppTokens.spaceSm),
                      child: Text(
                        msg.text,
                        style: TextStyle(
                          color: msg.isUser
                              ? theme.colorScheme.onPrimaryContainer
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppTokens.spaceSm),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: const InputDecoration(
                      hintText: 'Ask a question...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: AppTokens.spaceSm),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
