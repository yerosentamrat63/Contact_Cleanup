import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/contact_item.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../widgets/app_background.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_checkbox.dart';
import '../widgets/app_icons.dart';
import 'confirm_sheet.dart';

class ReviewScreen extends StatefulWidget {
  final List<ContactItem> markedContacts;
  final VoidCallback onBackToSwipe;
  final Function(List<ContactItem> toDelete) onConfirmDelete;

  const ReviewScreen({
    super.key,
    required this.markedContacts,
    required this.onBackToSwipe,
    required this.onConfirmDelete,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  // Set of unchecked contact IDs (by default, every marked row starts checked)
  final Set<String> _uncheckedIds = {};

  bool get _isAllChecked => _uncheckedIds.isEmpty;

  int get _selectedCount => widget.markedContacts.length - _uncheckedIds.length;

  void _toggleContact(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_uncheckedIds.contains(id)) {
        _uncheckedIds.remove(id);
      } else {
        _uncheckedIds.add(id);
      }
    });
  }

  void _toggleAll() {
    HapticFeedback.selectionClick();
    setState(() {
      if (_isAllChecked) {
        // Untick all
        _uncheckedIds.addAll(widget.markedContacts.map((c) => c.id));
      } else {
        // Tick all
        _uncheckedIds.clear();
      }
    });
  }

  void _onDeleteTapped() async {
    final selectedContacts = widget.markedContacts
        .where((c) => !_uncheckedIds.contains(c.id))
        .toList();

    if (selectedContacts.isEmpty) return;

    final confirmed = await ConfirmDeletionSheet.show(
      context,
      count: selectedContacts.length,
    );

    if (confirmed == true && mounted) {
      widget.onConfirmDelete(selectedContacts);
    }
  }

  @override
  Widget build(BuildContext context) {
    final markedCount = widget.markedContacts.length;
    final selectedCount = _selectedCount;
    final isDeleteEnabled = selectedCount > 0;
    final contactWord = selectedCount == 1 ? 'contact' : 'contacts';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Review', style: AppTypography.screenTitle()),
                    const SizedBox(height: 4),
                    Text(
                      'UNTICK ANY YOU WANT TO KEEP',
                      style: AppTypography.screenCaption(),
                    ),
                  ],
                ),
              ),

              // Live count & Tick all action row
              if (markedCount > 0)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$selectedCount OF $markedCount SELECTED',
                        style: AppTypography.reviewSelectedCount(),
                      ),
                      GestureDetector(
                        onTap: _toggleAll,
                        behavior: HitTestBehavior.opaque,
                        child: Text(
                          _isAllChecked ? 'Untick all' : 'Tick all',
                          style: AppTypography.reviewTickAll(),
                        ),
                      ),
                    ],
                  ),
                ),

              // Contact Rows List or Empty State
              Expanded(
                child: markedCount == 0
                    ? Center(
                        child: Text(
                          'NOTHING MARKED FOR DELETION',
                          style: AppTypography.counterTotal(
                            color: AppColors.oliveDrab,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: markedCount,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final contact = widget.markedContacts[index];
                          final isChecked = !_uncheckedIds.contains(contact.id);

                          return _buildContactRow(contact, isChecked);
                        },
                      ),
              ),

              // Bottom Bar (padding 12 / 20 / 32 / 20, 12 gap)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                child: Row(
                  children: [
                    // 56x56 outline back button (arrow left)
                    Semantics(
                      label: 'Back to swiping',
                      button: true,
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: Material(
                          color: AppColors.floralWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(
                              color: AppColors.outlineBorder,
                              width: 1.5,
                            ),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: widget.onBackToSwipe,
                            child: const Center(
                              child: ArrowLeftIcon(
                                size: 22,
                                color: AppColors.smokyBlack,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Flexible 56 tall terracotta button "Delete {n} contacts"
                    Expanded(
                      child: PrimaryButton(
                        label: 'Delete $selectedCount $contactWord',
                        backgroundColor: AppColors.terracotta,
                        isEnabled: isDeleteEnabled,
                        onTap: isDeleteEnabled ? _onDeleteTapped : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactRow(ContactItem contact, bool isChecked) {
    final firstPhone =
        contact.phones.isNotEmpty ? contact.phones.first : 'No phone';

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: isChecked ? 1.0 : 0.6,
      child: Material(
        color: AppColors.floralWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.cardBorder, width: 1.0),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _toggleContact(contact.id),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // 44 avatar circle
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.oliveDrab,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    contact.initial,
                    style: AppTypography.avatarInitial(fontSize: 18),
                  ),
                ),

                const SizedBox(width: 14),

                // Name and phone
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.displayName,
                        style: AppTypography.rowName(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        firstPhone,
                        style: AppTypography.rowPhone(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 14),

                // Custom Checkbox
                AppCheckbox(
                  isChecked: isChecked,
                  semanticLabel: 'Delete ${contact.displayName}',
                  onChanged: (val) => _toggleContact(contact.id),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

