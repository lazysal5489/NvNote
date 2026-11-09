import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:nvnote/themes/code_theme.dart';

class FencedCodeBuilder extends MarkdownElementBuilder {
  @override
  bool isBlockElement() => true;

  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    final source = element.textContent;

    String? language;

    for (final child in element.children ?? <md.Node>[]) {
      if (child is md.Element && child.tag == 'code') {
        language = child.attributes['class'] ?? '';

        if (language.startsWith('language-')) {
          language = language.replaceFirst('language-', '');
        }
        break;
      }
    }

    final resolvedLanguage = switch (language?.toLowerCase()) {
      'js' || 'javascript' => 'javascript',
      'ts' || 'typescript' => 'typescript',
      'json' => 'json',
      'html' => 'xml',
      'css' => 'css',
      'go' => 'go',
      'cpp' || 'c++' => 'cpp',
      'c' => 'c',
      'dart' => 'dart',
      'python' || 'py' => 'python',
      'bash' || 'sh' => 'bash',
      _ => 'plaintext',
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      child: HighlightView(
        source,
        language: resolvedLanguage,
        theme: CodeTheme.syntaxHightlight,
        textStyle: const TextStyle(fontFamily: 'JetBrainMono', fontSize: 16),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

enum _ViewMode { edit, preview, split }

class LiveMarkdownEditor extends StatefulWidget {
  const LiveMarkdownEditor({super.key});

  @override
  State<LiveMarkdownEditor> createState() => _LiveMarkDownEditorState();
}

class _LiveMarkDownEditorState extends State<LiveMarkdownEditor> {
  final TextEditingController _controller = TextEditingController(text: '');
  _ViewMode _mode = _ViewMode.edit;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String _) => setState(() {});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer,
            border: Border(
              top: BorderSide(
                width: 1,
                color: theme.colorScheme.surfaceContainerHighest,
              ),
              bottom: BorderSide(
                width: 1,
                color: theme.colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  // TODO: replace this with note title in the future(file name);
                  child: Text('Note Title', style: theme.textTheme.labelMedium),
                ),
              ),
              SegmentedButton<_ViewMode>(
                segments: const [
                  ButtonSegment(
                    value: _ViewMode.edit,
                    label: Text('Edit'),
                    icon: Icon(Icons.edit_outlined, size: 12),
                  ),
                  ButtonSegment(
                    value: _ViewMode.split,
                    label: Text('Split'),
                    icon: Icon(Icons.visibility_outlined, size: 12),
                  ),
                  ButtonSegment(
                    value: _ViewMode.preview,
                    label: Text('Preview'),
                    icon: Icon(Icons.visibility_outlined, size: 12),
                  ),
                ],
                selected: {_mode},
                onSelectionChanged: (newSelection) {
                  setState(() => _mode = newSelection.first);
                },
                showSelectedIcon: false,
                style: SegmentedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  side: BorderSide.none,
                  backgroundColor: theme.colorScheme.surfaceContainerHigh,
                  selectedBackgroundColor:
                      theme.colorScheme.surfaceContainerHighest,
                  selectedForegroundColor: theme.colorScheme.onSurface,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  textStyle: const TextStyle(fontSize: 10),
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 650;

              return switch (_mode) {
                _ViewMode.edit => _buildEditorPane(),
                _ViewMode.preview => _buildPreviewPane(),
                _ViewMode.split =>
                  isWide
                      ? Row(
                          children: [
                            Expanded(child: _buildEditorPane()),
                            const VerticalDivider(width: 1),
                            Expanded(child: _buildPreviewPane()),
                          ],
                        )
                      : Column(
                          children: [
                            Expanded(child: _buildEditorPane()),
                            const Divider(height: 1),
                            Expanded(child: _buildPreviewPane()),
                          ],
                        ),
              };
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEditorPane() {
    return Container(
      padding: const EdgeInsets.all(0),
      child: TextField(
        controller: _controller,
        onChanged: _onChanged,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: const TextStyle(fontFamily: 'JetBrainMono', fontSize: 16),
        decoration: const InputDecoration(
          hoverColor: Colors.transparent,
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
      padding: const EdgeInsets.all(0),
      child: InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.all(16),
        ),
        child: SizedBox.expand(
          child: Container(
            color: theme.colorScheme.surfaceContainerLowest,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(2),
              child: Markdown(
                data: _controller.text,
                shrinkWrap: true,
                builders: <String, MarkdownElementBuilder>{
                  'pre': FencedCodeBuilder(),
                },
                physics: const NeverScrollableScrollPhysics(),
                selectable: true,
                styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                  h1: theme.textTheme.headlineLarge,
                  h2: theme.textTheme.headlineMedium,
                  h3: theme.textTheme.headlineSmall,
                  code: const TextStyle(
                    fontFamily: 'JetBrainMono',
                    fontSize: 16,
                    backgroundColor: Color(0x11FABD2F),
                  ),
                  codeblockDecoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  blockquotePadding: const EdgeInsets.all(16),
                  codeblockPadding: const EdgeInsets.all(16),
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
