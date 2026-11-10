import 'package:flutter/material.dart';
import 'package:nvnote/models/buffer.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:material_symbols_icons/symbols.dart';

class BufferTabBar extends StatelessWidget {
  final List<Buffer> buffers;
  final String activeId;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onClose;
  final VoidCallback? onToggleSidebar;
  final VoidCallback? onBack;
  final VoidCallback? onForward;

  const BufferTabBar({
    super.key,
    required this.buffers,
    required this.activeId,
    required this.onSelect,
    required this.onClose,
    this.onToggleSidebar,
    this.onBack,
    this.onForward,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 40,
      color: theme.colorScheme.surfaceContainer,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Symbols.dock_to_right, size: 18),
            onPressed: onToggleSidebar,
            splashRadius: 18,
          ),
          IconButton(
            icon: const Icon(Symbols.west, size: 18),
            onPressed: onBack,
            splashRadius: 18,
          ),
          IconButton(
            icon: const Icon(Symbols.east, size: 18),
            onPressed: onForward,
            splashRadius: 18,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: buffers.length,
              itemBuilder: (context, index) {
                final buffer = buffers[index];
                final isActive = buffer.id == activeId;

                return _BufferTab(
                  buffer: buffer,
                  isActive: isActive,
                  onTap: () => onSelect(buffer.id),
                  onClose: () => onClose(buffer.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BufferTab extends StatefulWidget {
  const _BufferTab({
    required this.buffer,
    required this.isActive,
    required this.onTap,
    required this.onClose,
  });

  final Buffer buffer;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onClose;

  @override
  State<_BufferTab> createState() => _BufferTabState();
}

class _BufferTabState extends State<_BufferTab> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: widget.isActive
                ? theme.colorScheme.surfaceContainerHigh
                : Colors.transparent,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  widget.buffer.title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'JetBrainMono',
                    fontSize: 13,
                    color: widget.isActive
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              if (widget.isActive || _hovering)
                GestureDetector(
                  onTap: widget.onClose,
                  child: Icon(
                    Symbols.close,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
              else
                const SizedBox(width: 14),
            ],
          ),
        ),
      ),
    );
  }
}
