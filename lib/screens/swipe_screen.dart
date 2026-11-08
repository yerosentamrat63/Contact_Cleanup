import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import '../models/contact_item.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../widgets/app_background.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_icons.dart';

class SwipeScreen extends StatefulWidget {
  final List<ContactItem> contacts;
  final int currentIndex;
  final List<bool> decisions;
  final Function(bool isDelete) onDecision;
  final VoidCallback onUndo;
  final VoidCallback onFinish;

  const SwipeScreen({
    super.key,
    required this.contacts,
    required this.currentIndex,
    required this.decisions,
    required this.onDecision,
    required this.onUndo,
    required this.onFinish,
  });

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _cardAnimController;
  Animation<double>? _cardPositionAnimation;

  double _dragDx = 0.0;
  bool _isAnimatingCommit = false;

  @override
  void initState() {
    super.initState();
    _cardAnimController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _cardAnimController.dispose();
    super.dispose();
  }

  double get _currentDx {
    if (_cardAnimController.isAnimating && _cardPositionAnimation != null) {
      return _cardPositionAnimation!.value;
    }
    return _dragDx;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (_isAnimatingCommit) return;
    setState(() {
      _dragDx += details.delta.dx;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_isAnimatingCommit) return;

    final velocity = details.primaryVelocity ?? 0.0;
    final isFlick = velocity.abs() > 700;
    final isCommitDistance = _dragDx.abs() > 110;

    final shouldCommit = isCommitDistance || isFlick;
    final isDelete = isFlick ? (velocity > 0) : (_dragDx > 0);

    if (shouldCommit) {
      _commitSwipe(isDelete: isDelete);
    } else {
      _cancelSwipe();
    }
  }

  void _commitSwipe({required bool isDelete}) {
    if (_isAnimatingCommit) return;
    _isAnimatingCommit = true;

    final startX = _dragDx;
    final targetX = isDelete ? 560.0 : -560.0;

    final bool reduceMotion = MediaQuery.of(context).disableAnimations;
    final duration = reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 260);

    _cardAnimController.duration = duration;

    _cardPositionAnimation = Tween<double>(
      begin: startX,
      end: targetX,
    ).animate(
      CurvedAnimation(
        parent: _cardAnimController,
        curve: const Cubic(0.4, 0.0, 1.0, 1.0),
      ),
    );

    _cardAnimController.forward(from: 0.0).then((_) {
      if (!mounted) return;
      final contact = widget.contacts[widget.currentIndex];
      HapticFeedback.lightImpact();
      SemanticsService.announce(
        isDelete
            ? 'Marked ${contact.displayName} for deletion'
            : 'Kept ${contact.displayName}',
        TextDirection.ltr,
      );

      setState(() {
        _dragDx = 0.0;
        _isAnimatingCommit = false;
        _cardPositionAnimation = null;
      });
      _cardAnimController.reset();

      widget.onDecision(isDelete);
    });
  }

  void _cancelSwipe() {
    final startX = _dragDx;
    final bool reduceMotion = MediaQuery.of(context).disableAnimations;
    final duration = reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 380);

    _cardAnimController.duration = duration;

    _cardPositionAnimation = Tween<double>(
      begin: startX,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _cardAnimController,
        curve: const Cubic(0.34, 1.56, 0.64, 1.0),
      ),
    );

    _cardAnimController.forward(from: 0.0).then((_) {
      if (!mounted) return;
      setState(() {
        _dragDx = 0.0;
        _cardPositionAnimation = null;
      });
      _cardAnimController.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currentIndex >= widget.contacts.length) {
      return const SizedBox.shrink();
    }

    final currentContact = widget.contacts[widget.currentIndex];
    final bool hasNext = widget.currentIndex + 1 < widget.contacts.length;
    final nextContact = hasNext ? widget.contacts[widget.currentIndex + 1] : null;

    final totalCount = widget.contacts.length;
    final decidedCount = widget.decisions.length;
    final progressFraction = totalCount > 0 ? (decidedCount / totalCount) : 0.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Header: Counter & Undo button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${widget.currentIndex + 1}',
                          style: AppTypography.counterBig(),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'OF $totalCount',
                          style: AppTypography.counterTotal(),
                        ),
                      ],
                    ),
                    CircleIconButton(
                      semanticLabel: 'Undo last swipe',
                      isEnabled: widget.decisions.isNotEmpty && !_isAnimatingCommit,
                      icon: const UndoIcon(size: 22),
                      onTap: () {
                        if (widget.decisions.isNotEmpty && !_isAnimatingCommit) {
                          widget.onUndo();
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Animated Progress Bar (height: 6, radius: 3)
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Container(
                    height: 6,
                    color: AppColors.progressTrack,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AnimatedFractionallySizedBox(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        widthFactor: progressFraction.clamp(0.0, 1.0),
                        child: Container(color: AppColors.oliveDrab),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Card Stack Area (flex: 1)
                Expanded(
                  child: AnimatedBuilder(
                    animation: _cardAnimController,
                    builder: (context, child) {
                      final dx = _currentDx;
                      final absDx = dx.abs();

                      // Stamp & tint opacity = min(|dx| / 90, 1)
                      final stampTintOpacity = (absDx / 90.0).clamp(0.0, 1.0);

                      // Next card growth: p = min(|dx| / 140, 1)
                      final p = (absDx / 140.0).clamp(0.0, 1.0);
                      final nextScale = 0.92 + 0.08 * p;
                      final nextOffsetY = 16.0 * (1.0 - p);

                      // Rotation angle = (0.06° * dx) clamped to ±20°
                      final angleDegrees = (0.06 * dx).clamp(-20.0, 20.0);
                      final angleRadians = angleDegrees * (pi / 180.0);

                      return Stack(
                        clipBehavior: Clip.none,
                        fit: StackFit.expand,
                        children: [
                          // Next Card (behind)
                          if (hasNext && nextContact != null)
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 0,
                              bottom: 8,
                              child: Transform(
                                alignment: Alignment.bottomCenter,
                                transform: Matrix4.translationValues(0.0, nextOffsetY, 0.0)
                                  ..scaleByDouble(nextScale, nextScale, 1.0, 1.0),
                                child: _buildNextCard(nextContact),
                              ),
                            ),

                          // Front Card
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 8,
                            child: GestureDetector(
                              onHorizontalDragUpdate: _onHorizontalDragUpdate,
                              onHorizontalDragEnd: _onHorizontalDragEnd,
                              child: Transform(
                                alignment: const Alignment(0.0, 1.4), // 50% across, 120% down
                                transform: Matrix4.translationValues(dx, 0.0, 0.0)
                                  ..rotateZ(angleRadians),
                                child: _buildFrontCard(
                                  currentContact,
                                  dx: dx,
                                  stampTintOpacity: stampTintOpacity,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Action Row (Keep and Delete buttons)
                AnimatedBuilder(
                  animation: _cardAnimController,
                  builder: (context, child) {
                    final dx = _currentDx;
                    final keepProgress = dx < 0 ? (-dx / 90.0).clamp(0.0, 1.0) : 0.0;
                    final deleteProgress = dx > 0 ? (dx / 90.0).clamp(0.0, 1.0) : 0.0;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // KEEP button (Sage)
                          ActionChoiceButton(
                            semanticLabel: 'Keep contact',
                            label: 'Keep',
                            activeTint: AppColors.sageTint,
                            borderColor: AppColors.sageInk,
                            highlightProgress: keepProgress,
                            icon: const CheckIcon(
                              size: 30,
                              color: AppColors.sageInk,
                              strokeWidth: 2.4,
                            ),
                            onTap: _isAnimatingCommit
                                ? null
                                : () => _commitSwipe(isDelete: false),
                          ),

                          // DELETE button (Terracotta)
                          ActionChoiceButton(
                            semanticLabel: 'Mark contact for deletion',
                            label: 'Delete',
                            activeTint: AppColors.terracottaTint,
                            borderColor: AppColors.terracotta,
                            highlightProgress: deleteProgress,
                            icon: const TrashIcon(
                              size: 28,
                              color: AppColors.terracotta,
                              strokeWidth: 2.2,
                            ),
                            onTap: _isAnimatingCommit
                                ? null
                                : () => _commitSwipe(isDelete: true),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNextCard(ContactItem contact) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.stackedCard,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.cardBorder, width: 1.0),
      ),
      padding: const EdgeInsets.all(28),
      child: Center(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 112,
                height: 112,
                decoration: const BoxDecoration(
                  color: AppColors.oliveDrab,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  contact.initial,
                  style: AppTypography.avatarInitial(fontSize: 52),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                contact.displayName,
                style: AppTypography.contactCardName(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFrontCard(
    ContactItem contact, {
    required double dx,
    required double stampTintOpacity,
  }) {
    final bool isDragging = dx.abs() > 0.5;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.floralWhite,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.cardBorder, width: 1.0),
        boxShadow: [
          if (isDragging)
            const BoxShadow(
              color: Color.fromRGBO(17, 18, 13, 0.22),
              blurRadius: 44,
              offset: Offset(0, 22),
            )
          else
            const BoxShadow(
              color: Color.fromRGBO(17, 18, 13, 0.16),
              blurRadius: 36,
              offset: Offset(0, 16),
            ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Card Content
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Center(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar (112 circle)
                    Container(
                      width: 112,
                      height: 112,
                      decoration: const BoxDecoration(
                        color: AppColors.oliveDrab,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        contact.initial,
                        style: AppTypography.avatarInitial(fontSize: 52),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Name
                    Text(
                      contact.displayName,
                      style: AppTypography.contactCardName(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 22),

                    // Phone Numbers
                    if (contact.phones.isNotEmpty)
                      ...contact.phones.map(
                        (phone) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            phone,
                            style: AppTypography.contactCardPhone(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    else
                      Text(
                        'No phone number',
                        style: AppTypography.cardEmail(),
                      ),

                    // Email (if present)
                    if (contact.emails.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        contact.emails.first,
                        style: AppTypography.cardEmail(),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Terracotta Tint Overlay (right drag / delete)
          if (dx > 0 && stampTintOpacity > 0)
            Positioned.fill(
              child: Container(
                color: Color.fromRGBO(
                  178,
                  58,
                  46,
                  0.16 * stampTintOpacity,
                ),
              ),
            ),

          // Sage Tint Overlay (left drag / keep)
          if (dx < 0 && stampTintOpacity > 0)
            Positioned.fill(
              child: Container(
                color: Color.fromRGBO(
                  63,
                  90,
                  43,
                  0.16 * stampTintOpacity,
                ),
              ),
            ),

          // DELETE Stamp (top-left, rotated -12°)
          if (dx > 0 && stampTintOpacity > 0)
            Positioned(
              left: 22,
              top: 26,
              child: Opacity(
                opacity: stampTintOpacity,
                child: Transform.rotate(
                  angle: -12 * (pi / 180.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.floralWhite,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.terracotta,
                        width: 3.0,
                      ),
                    ),
                    child: Text(
                      'DELETE',
                      style: AppTypography.stamp(color: AppColors.terracotta),
                    ),
                  ),
                ),
              ),
            ),

          // KEEP Stamp (top-right, rotated +12°)
          if (dx < 0 && stampTintOpacity > 0)
            Positioned(
              right: 22,
              top: 26,
              child: Opacity(
                opacity: stampTintOpacity,
                child: Transform.rotate(
                  angle: 12 * (pi / 180.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.floralWhite,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.sageInk,
                        width: 3.0,
                      ),
                    ),
                    child: Text(
                      'KEEP',
                      style: AppTypography.stamp(color: AppColors.sageInk),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
