import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class LiveMarkdownEditor extends StatefulWidget {
  const LiveMarkdownEditor({super.key});

  @override
  State<LiveMarkdownEditor> createState() => _LiveMarkDownEditorState();
}

class _LiveMarkDownEditorState extends State<LiveMarkdownEditor> {
  final TextEditingController _controller = TextEditingController(text: '');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String _) => setState(() {});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) {
        final isWide = constraints.maxWidth > 700;
        final editor = _buildEditorPane();
        final preview = _buildPreviewPane();
        return isWide
            ? Row(
                children: [
                  Expanded(child: editor),
                  Expanded(child: preview),
                ],
              )
            : Column(
                children: [
                  Expanded(child: editor),
                  Expanded(child: preview),
                ],
              );
      }),
    );
  }

  Widget _buildEditorPane() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: _controller,
        onChanged: _onChanged,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: const TextStyle(fontFamily: 'JetBrainMono', fontSize: 16),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Type Markdown here...',
          alignLabelWithHint: true,
        ),
      ),
    );
  }

  Widget _buildPreviewPane() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      child: InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.all(12),
        ),
        child: SizedBox.expand(
          child: Container(
            color: theme.colorScheme.surfaceContainerLow,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(4),
              child: Markdown(
                data: _controller.text,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                selectable: true,
                styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                  code: const TextStyle(
                    fontFamily: 'JetBrainMono',
                    fontSize: 16,
                    backgroundColor: Color(0x26FABD2F),
                  ),
                  codeblockDecoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  blockquotePadding: const EdgeInsets.all(12),
                ),
                onTapLink: (text, href, title) {
                  if (href != null) {
                    launchUrl(Uri.http(href));
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
