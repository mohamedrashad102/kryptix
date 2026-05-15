import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/saved_service.dart';
import 'bento_card.dart';

/// An input field for the service name with autocomplete history
/// and version controls.
class ServiceInput extends StatelessWidget {
  /// Creates a [ServiceInput].
  const ServiceInput({
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
    required this.recentServices,
    required this.version,
    required this.onIncrementVersion,
    required this.onDecrementVersion,
    super.key,
    this.onChanged,
    this.onDeleteService,
    this.onClearAll,
    this.onServiceSelected,
  });

  /// Controller for the text field.
  final TextEditingController controller;

  /// Focus node for keyboard management.
  final FocusNode focusNode;

  /// Callback when the user submits the field.
  final VoidCallback onSubmitted;

  /// Optional callback when the text changes.
  final ValueChanged<String>? onChanged;

  /// List of recently used services for autocomplete.
  final List<SavedService> recentServices;

  /// Callback when a service is selected from history.
  final ValueSetter<SavedService>? onServiceSelected;

  /// Callback to delete a specific service from history.
  final void Function(String)? onDeleteService;

  /// Callback to clear all service history.
  final VoidCallback? onClearAll;

  /// The current rotation version.
  final int version;

  /// Callback to increment the version.
  final VoidCallback onIncrementVersion;

  /// Callback to decrement the version.
  final VoidCallback onDecrementVersion;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return BentoCard(
      title: l10n.serviceName,
      icon: Icons.language_rounded,
      child: Row(
        children: [
          Expanded(
            child: RawAutocomplete<SavedService>(
              key: ValueKey(
                'autocomplete_${recentServices.length}_'
                '${recentServices.hashCode}',
              ),
              textEditingController: controller,
              focusNode: focusNode,
              displayStringForOption: (option) => option.name,
              optionsBuilder: (textEditingValue) {
                final query = textEditingValue.text.toLowerCase();
                return recentServices.where((option) {
                  return option.name.toLowerCase().contains(query);
                });
              },
              onSelected: (selection) {
                controller.text = selection.name;
                onServiceSelected?.call(selection);
              },
              fieldViewBuilder: (ctx, fCtrl, fNode, onSub) {
                return TextField(
                  controller: fCtrl,
                  focusNode: fNode,
                  onSubmitted: (value) {
                    onSubmitted();
                    onSub();
                  },
                  onChanged: onChanged,
                  autofillHints: const [AutofillHints.url],
                  decoration: InputDecoration(
                    hintText: l10n.serviceExample,
                    filled: true,
                    fillColor: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.03),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _CompactVersionButton(
                            icon: Icons.remove_rounded,
                            onPressed: version > 1 ? onDecrementVersion : null,
                            isDark: isDark,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'V$version',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                          _CompactVersionButton(
                            icon: Icons.add_rounded,
                            onPressed: onIncrementVersion,
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(16),
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 250,
                        maxWidth: 260,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: options.length,
                              itemBuilder: (context, index) {
                                final option = options.elementAt(index);
                                return _AutocompleteItem(
                                  index: index,
                                  option: option,
                                  onSelected: onSelected,
                                  onDelete: onDeleteService,
                                  isDark: isDark,
                                );
                              },
                            ),
                          ),
                          if (onClearAll != null && recentServices.isNotEmpty)
                            Column(
                              children: [
                                const Divider(height: 1),
                                InkWell(
                                  onTap: () {
                                    onClearAll?.call();
                                    focusNode.unfocus();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.delete_sweep_rounded,
                                          size: 14,
                                          color: isDark
                                              ? Colors.redAccent.withValues(
                                                  alpha: 0.7,
                                                )
                                              : Colors.redAccent,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          l10n.clearAllHistory,
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1,
                                            color: isDark
                                                ? Colors.redAccent.withValues(
                                                    alpha: 0.7,
                                                  )
                                                : Colors.redAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactVersionButton extends StatelessWidget {
  const _CompactVersionButton({
    required this.icon,
    required this.isDark,
    this.onPressed,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDisabled = onPressed == null;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        child: Icon(
          icon,
          size: 18,
          color: isDisabled
              ? colorScheme.onSurface.withValues(alpha: 0.1)
              : colorScheme.primary.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}

class _AutocompleteItem extends StatelessWidget {
  const _AutocompleteItem({
    required this.index,
    required this.option,
    required this.onSelected,
    required this.isDark,
    this.onDelete,
  });

  final int index;
  final SavedService option;
  final ValueSetter<SavedService> onSelected;
  final void Function(String)? onDelete;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final highlightedIndex = AutocompleteHighlightedOption.of(context);
    final isHighlighted = highlightedIndex == index;
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: () => onSelected(option),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isHighlighted
              ? (isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.05))
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    option.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isHighlighted
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isHighlighted
                          ? (isDark ? Colors.white : Colors.black)
                          : (isDark ? Colors.white70 : Colors.black87),
                    ),
                  ),
                  Text(
                    '${l10n.version} ${option.version}',
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? Colors.white30 : Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 14),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashRadius: 16,
                color: isDark ? Colors.white30 : Colors.black26,
                onPressed: () => onDelete?.call(option.name),
              ),
          ],
        ),
      ),
    );
  }
}
