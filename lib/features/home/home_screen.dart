import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../core/responsive/responsive_layout.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../history/history_screen.dart';
import '../inventory/inventory_screen.dart';
import '../medicine/add_medicine_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _selectTab(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      CareDoseDashboardTab(
        onInventoryTap: () => _selectTab(1),
        onAddMedicineTap: () => _selectTab(2),
        onHistoryTap: () => _selectTab(3),
      ),
      const InventoryScreen(),
      const AddMedicineScreen(),
      const HistoryScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _selectedIndex, children: tabs),
      bottomNavigationBar: _CareDoseBottomNav(
        selectedIndex: _selectedIndex,
        onTabSelected: _selectTab,
      ),
    );
  }
}

class CareDoseDashboardTab extends StatelessWidget {
  const CareDoseDashboardTab({
    required this.onInventoryTap,
    required this.onAddMedicineTap,
    required this.onHistoryTap,
    super.key,
  });

  final VoidCallback onInventoryTap;
  final VoidCallback onAddMedicineTap;
  final VoidCallback onHistoryTap;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = Responsive.horizontalPadding(context);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: Responsive.clampedTextScaler(context),
      ),
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableHeight = constraints.maxHeight;
            final distribution = Responsive.calculateVerticalDistribution(
              context,
              availableHeight,
            );

            // Full clearance offset so floating bottom nav bar never obscures bottom-most card when scrolled
            final double bottomNavClearance = MediaQuery.of(context).padding.bottom + 90.0;
            final isPhoneLandscape = Responsive.isPhoneLandscape(context);

            if (isPhoneLandscape) {
              // Phone Landscape: Full-width Header with aligned 2-Column Baseline & Left-Column Scroll Fallback
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full-Width Header spanning across both columns
                    const _HomeHeader(),
                    SizedBox(height: distribution.verticalGap),

                    // 2-Column Row starting at identical top baseline
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Column: Next Dose Hero Card with scroll fallback for ultra-short devices (e.g. SE)
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const ClampingScrollPhysics(),
                              child: _NextDoseCard(cardPadding: distribution.cardPadding),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Right Column: Progress Card + At a Glance + Health Tip Card (Independently scrollable)
                          Expanded(
                            child: Stack(
                              children: [
                                SingleChildScrollView(
                                  physics: const ClampingScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _TodayProgressCard(cardPadding: distribution.cardPadding),
                                      SizedBox(height: distribution.verticalGap),
                                      _AtAGlanceSection(
                                        distribution: distribution,
                                        onMedicinesTap: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('12 Active medicines are currently tracked.'),
                                              behavior: SnackBarBehavior.floating,
                                            ),
                                          );
                                        },
                                        onLowStockTap: onInventoryTap,
                                        onUpcomingTap: onHistoryTap,
                                      ),
                                      SizedBox(height: distribution.verticalGap),
                                      _HealthTipCard(distribution: distribution),
                                      SizedBox(height: bottomNavClearance),
                                    ],
                                  ),
                                ),
                                // Soft gradient indicator at bottom edge when content extends below
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  height: 24,
                                  child: IgnorePointer(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            AppColors.background.withValues(alpha: 0.0),
                                            AppColors.background.withValues(alpha: 0.85),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            // Standard Phone Portrait Single-Column Stack
            Widget dashboardContent = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const _HomeHeader(),
                SizedBox(height: distribution.verticalGap),
                _NextDoseCard(cardPadding: distribution.cardPadding),
                SizedBox(height: distribution.verticalGap),
                _TodayProgressCard(cardPadding: distribution.cardPadding),
                SizedBox(height: distribution.verticalGap),
                _AtAGlanceSection(
                  distribution: distribution,
                  onMedicinesTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('12 Active medicines are currently tracked.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  onLowStockTap: onInventoryTap,
                  onUpcomingTap: onHistoryTap,
                ),
                SizedBox(height: distribution.verticalGap),
                _HealthTipCard(distribution: distribution),
                SizedBox(height: bottomNavClearance),
              ],
            );

            Widget scrollableBody = SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 12.0,
              ),
              child: dashboardContent,
            );

            // Tablet cap: Center 500dp container horizontally across wide tablet viewports
            if (Responsive.isTabletWidth(context) && !isPhoneLandscape) {
              return Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: AppBreakpoints.maxContentWidth),
                  child: scrollableBody,
                ),
              );
            }

            return scrollableBody;
          },
        ),
      ),
    );
  }
}

class _HomeHeader extends StatefulWidget {
  const _HomeHeader();

  @override
  State<_HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<_HomeHeader> {
  bool _hasNotification = true;

  @override
  Widget build(BuildContext context) {
    final avatarSize = Responsive.valueByWidth<double>(
      context,
      compact: 40.0,
      normal: 46.0,
      large: 50.0,
    );

    final nameFontSize = Responsive.valueByWidth<double>(
      context,
      compact: 22.0,
      normal: 24.0,
      large: 26.0,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Good Morning,',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFonts.inter,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Mr. Patel 👋',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: nameFontSize,
                  fontWeight: FontWeight.w800,
                  fontFamily: AppFonts.inter,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                'Take care, stay healthy.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  fontFamily: AppFonts.inter,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Notification circular button
            GestureDetector(
              onTap: () {
                setState(() => _hasNotification = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notifications: 1 morning dose logged.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.02),
                    width: 1.2,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.textPrimary,
                      size: avatarSize * 0.55,
                    ),
                    if (_hasNotification)
                      Positioned(
                        right: avatarSize * 0.22,
                        top: avatarSize * 0.22,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: AppColors.danger,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Profile avatar with soft green background
            Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Center(
                    child: ClipOval(
                      child: SizedBox(
                        width: avatarSize - 3,
                        height: avatarSize - 3,
                        child: Transform.scale(
                          scale: 1.65,
                          origin: const Offset(0, 1.5),
                          child: Image.asset(
                            'assets/images/mascot/shark_doc_home.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -1,
                    bottom: -1,
                    child: Container(
                      width: avatarSize * 0.24,
                      height: avatarSize * 0.24,
                      decoration: BoxDecoration(
                        color: AppColors.warning,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _NextDoseCard extends StatefulWidget {
  const _NextDoseCard({required this.cardPadding});

  final double cardPadding;

  @override
  State<_NextDoseCard> createState() => _NextDoseCardState();
}

class _NextDoseCardState extends State<_NextDoseCard> {
  bool _isTaken = false;

  static const double _cardRadius = 24.0;
  static const double _buttonRadius = 12.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32), // CareDose primary deep green
        borderRadius: BorderRadius.circular(_cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Controlled yellow glow from top corner
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.warning.withValues(alpha: 0.25),
                    AppColors.secondary.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(widget.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bolt_rounded,
                            color: AppColors.warning,
                            size: 13,
                          ),
                          SizedBox(width: 2),
                          Text(
                            'NEXT DOSE',
                            style: TextStyle(
                              color: Color(0xFFFFF9C4),
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              fontFamily: AppFonts.inter,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        '8:00 AM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          fontFamily: AppFonts.inter,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Medicine Information Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.warning.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.medication_rounded,
                        color: AppColors.warning,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Aspirin 75mg',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              fontFamily: AppFonts.inter,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '1 Tablet • After Breakfast',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xFFE5EDE8),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppFonts.inter,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Action Buttons (Content-driven minimum height)
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 250),
                  crossFadeState: _isTaken
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TappableScale(
                          onTap: () {
                            setState(() => _isTaken = true);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Aspirin 75mg logged successfully!'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 42),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.warning,
                              borderRadius: BorderRadius.circular(_buttonRadius),
                            ),
                            child: const Center(
                              child: Text(
                                'Take Now',
                                style: TextStyle(
                                  color: Color(0xFF2E7D32),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: AppFonts.inter,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: TappableScale(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Dose snoozed for 15 minutes.'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 42),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(_buttonRadius),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.25),
                                width: 1,
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Snooze',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: AppFonts.inter,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  secondChild: Container(
                    constraints: const BoxConstraints(minHeight: 42),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(_buttonRadius),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.warning,
                          size: 20,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Logged as Taken today',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.inter,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayProgressCard extends StatelessWidget {
  const _TodayProgressCard({required this.cardPadding});

  final double cardPadding;

  @override
  Widget build(BuildContext context) {
    final ringSize = Responsive.valueByWidth<double>(
      context,
      compact: 76.0,
      normal: 86.0,
      large: 96.0,
    );

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.02),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: ringSize,
            height: ringSize,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 0.85),
              duration: const Duration(milliseconds: 1400),
              curve: Curves.easeInOutCubic,
              builder: (context, value, child) {
                return CustomPaint(
                  painter: _CircularProgressPainter(
                    progress: value,
                    trackColor: const Color(0xFFF1F5F2),
                    progressColors: const [
                      AppColors.primary,
                      AppColors.secondary,
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${(value * 100).toInt()}%',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: ringSize * 0.28,
                            fontWeight: FontWeight.w800,
                            fontFamily: AppFonts.inter,
                            height: 0.9,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Today',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: ringSize * 0.11,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.inter,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '4 of 5 doses taken',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    fontFamily: AppFonts.inter,
                    height: 1.1,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Great! You\'re doing well.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    fontFamily: AppFonts.inter,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Almost done with today\'s schedule.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: AppFonts.inter,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  _CircularProgressPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColors,
  });

  final double progress;
  final Color trackColor;
  final List<Color> progressColors;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - 8) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0) return;

    final glowPaint = Paint()
      ..color = progressColors.first.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 11
      ..strokeCap = StrokeCap.round;
    glowPaint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);

    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * progress.clamp(0, 1),
      false,
      glowPaint,
    );

    final progressPaint = Paint()
      ..shader = SweepGradient(
        colors: [...progressColors, progressColors.first],
        stops: const [0.0, 0.7, 1.0],
        transform: const GradientRotation(-math.pi / 2),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * progress.clamp(0, 1),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _AtAGlanceSection extends StatelessWidget {
  const _AtAGlanceSection({
    required this.distribution,
    required this.onMedicinesTap,
    required this.onLowStockTap,
    required this.onUpcomingTap,
  });

  final VerticalDistribution distribution;
  final VoidCallback onMedicinesTap;
  final VoidCallback onLowStockTap;
  final VoidCallback onUpcomingTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'At a Glance',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              fontFamily: AppFonts.inter,
            ),
          ),
        ),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _GlanceCard(
                  minHeight: distribution.glanceMinHeight,
                  cardPadding: distribution.cardPadding,
                  icon: Icons.medication_rounded,
                  iconColor: AppColors.primary,
                  iconBgColor: AppColors.primary.withValues(alpha: 0.1),
                  value: '12',
                  label: 'Medicines',
                  sublabel: 'In Stock',
                  onTap: onMedicinesTap,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _GlanceCard(
                  minHeight: distribution.glanceMinHeight,
                  cardPadding: distribution.cardPadding,
                  icon: Icons.warning_amber_rounded,
                  iconColor: AppColors.danger,
                  iconBgColor: AppColors.danger.withValues(alpha: 0.1),
                  value: '2',
                  label: 'Low Stock',
                  sublabel: 'Need Refill',
                  valueColor: AppColors.danger,
                  onTap: onLowStockTap,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _GlanceCard(
                  minHeight: distribution.glanceMinHeight,
                  cardPadding: distribution.cardPadding,
                  icon: Icons.calendar_month_rounded,
                  iconColor: const Color(0xFF0D9EF5),
                  iconBgColor: const Color(0xFF0D9EF5).withValues(alpha: 0.1),
                  value: '1',
                  label: 'Upcoming',
                  sublabel: 'Appointment',
                  onTap: onUpcomingTap,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GlanceCard extends StatelessWidget {
  const _GlanceCard({
    required this.minHeight,
    required this.cardPadding,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.value,
    required this.label,
    required this.sublabel,
    required this.onTap,
    this.valueColor,
  });

  final double minHeight;
  final double cardPadding;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String value;
  final String label;
  final String sublabel;
  final VoidCallback onTap;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final isCompact = Responsive.isCompactWidth(context);
    final valueFontSize = isCompact ? 22.0 : 26.0;
    final labelFontSize = isCompact ? 11.0 : 12.0;
    final sublabelFontSize = isCompact ? 9.5 : 10.0;

    return TappableScale(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.02),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 16,
              ),
            ),
            const SizedBox(height: 8),

            // Information group
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: valueColor ?? AppColors.textPrimary,
                    fontSize: valueFontSize,
                    fontWeight: FontWeight.w800,
                    fontFamily: AppFonts.inter,
                    height: 1.0,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.w700,
                    fontFamily: AppFonts.inter,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sublabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                    fontSize: sublabelFontSize,
                    fontWeight: FontWeight.w400,
                    fontFamily: AppFonts.inter,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HealthTipCard extends StatelessWidget {
  const _HealthTipCard({required this.distribution});

  final VerticalDistribution distribution;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: distribution.healthTipMinHeight),
      padding: EdgeInsets.symmetric(
        horizontal: distribution.cardPadding + 2,
        vertical: distribution.cardPadding,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF9EB),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.22),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SHARK DOC Mascot
          SizedBox(
            width: 72,
            height: 72,
            child: Image.asset(
              'assets/images/mascot/shark_doc_tip.png',
              fit: BoxFit.contain,
              alignment: Alignment.center,
            ),
          ),
          const SizedBox(width: 12),

          // TIP CONTENT
          const Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Health Tip',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    fontFamily: AppFonts.inter,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Drink a glass of water with your morning '
                  'medicines to stay hydrated.',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.inter,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CareDoseBottomNav extends StatelessWidget {
  const _CareDoseBottomNav({
    required this.selectedIndex,
    required this.onTabSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final navHeight = 64.0 + bottomInset;

    return SizedBox(
      height: navHeight + 16,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: navHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, -6),
                ),
              ],
              border: Border(
                top: BorderSide(
                  color: Colors.black.withValues(alpha: 0.02),
                  width: 1.5,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: _NavIconButton(
                      icon: Icons.home_outlined,
                      activeIcon: Icons.home_rounded,
                      label: 'Home',
                      isSelected: selectedIndex == 0,
                      onPressed: () => onTabSelected(0),
                    ),
                  ),
                  Expanded(
                    child: _NavIconButton(
                      icon: Icons.inventory_2_outlined,
                      activeIcon: Icons.inventory_2_rounded,
                      label: 'Inventory',
                      isSelected: selectedIndex == 1,
                      onPressed: () => onTabSelected(1),
                    ),
                  ),
                  const SizedBox(width: 58),
                  Expanded(
                    child: _NavIconButton(
                      icon: Icons.history_rounded,
                      activeIcon: Icons.history_rounded,
                      label: 'History',
                      isSelected: selectedIndex == 3,
                      onPressed: () => onTabSelected(3),
                    ),
                  ),
                  Expanded(
                    child: _NavIconButton(
                      icon: Icons.person_outline_rounded,
                      activeIcon: Icons.person_rounded,
                      label: 'Profile',
                      isSelected: selectedIndex == 4,
                      onPressed: () => onTabSelected(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: _PrimaryNavButton(
              isSelected: selectedIndex == 2,
              onPressed: () => onTabSelected(2),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavIconButton extends StatelessWidget {
  const _NavIconButton({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final iconColor = isSelected ? AppColors.primary : AppColors.textSecondary;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: TappableScale(
        onTap: onPressed,
        child: Container(
          color: Colors.transparent,
          height: 54,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                color: iconColor,
                size: 26,
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: isSelected ? 5 : 0,
                height: isSelected ? 5 : 0,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrimaryNavButton extends StatefulWidget {
  const _PrimaryNavButton({
    required this.isSelected,
    required this.onPressed,
  });

  final bool isSelected;
  final VoidCallback onPressed;

  @override
  State<_PrimaryNavButton> createState() => _PrimaryNavButtonState();
}

class _PrimaryNavButtonState extends State<_PrimaryNavButton> {
  @override
  Widget build(BuildContext context) {
    return TappableScale(
      onTap: widget.onPressed,
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: const Color(0xFF212121),
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.isSelected ? AppColors.warning : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
            if (widget.isSelected)
              BoxShadow(
                color: AppColors.warning.withValues(alpha: 0.4),
                blurRadius: 10,
                offset: const Offset(0, 0),
              ),
          ],
        ),
        child: Icon(
          Icons.add_rounded,
          color: widget.isSelected ? AppColors.warning : Colors.white,
          size: 32,
        ),
      ),
    );
  }
}

class TappableScale extends StatefulWidget {
  const TappableScale({
    required this.child,
    required this.onTap,
    super.key,
  });

  final Widget child;
  final VoidCallback onTap;

  @override
  State<TappableScale> createState() => _TappableScaleState();
}

class _TappableScaleState extends State<TappableScale> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapCancel: () => setState(() => _isPressed = false),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 80),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
