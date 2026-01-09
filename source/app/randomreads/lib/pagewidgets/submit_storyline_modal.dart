import 'package:flutter/material.dart';

class SubmitStorylineModal extends StatefulWidget {
  const SubmitStorylineModal({super.key, required this.onSubmitted});
  final Function(String)? onSubmitted;

  @override
  State<SubmitStorylineModal> createState() => _SubmitStorylineModalState();

}

class _SubmitStorylineModalState extends State<SubmitStorylineModal> {
  final TextEditingController _controller = TextEditingController();
  static const int minchar = 100;
  static const int maxchar = 500;

  bool get isInputValid {
    final textLength = _controller.text.trim().length;
    return textLength >= minchar && textLength <= maxchar;
  }
  int get wordCount =>
      _controller.text.trim().isEmpty ? 0 : _controller.text.trim().length;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            Text(
              'Suggest a story idea',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              '100-500 characters',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _controller,
              autofocus: true,
              maxLines: 6,
              minLines: 4,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Write the story line you’d like to read…',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$wordCount / $maxchar characters',
                  style: theme.textTheme.bodySmall,
                ),
                TextButton(
                  onPressed: isInputValid ? _submit : null,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  void _submit() {
    final text = _controller.text.trim();

    // TODO: Send to backend / analytics / queue
    // submitReadSuggestion(text);
    widget.onSubmitted?.call(text);
    Navigator.pop(context); // close sheet
  }
}