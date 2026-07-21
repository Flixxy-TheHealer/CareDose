import 'dart:math' as math;
import 'package:flutter/material.dart';

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
    return SafeArea(
      bottom: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          final config = _LayoutConfig.fromHeight(height);

          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Section 1: Header
                _HomeHeader(config: config),
                SizedBox(height: config.verticalGap),

                // Section 2: Next Dose Card
                _NextDoseCard(config: config),
                SizedBox(height: config.verticalGap),

                // Section 3: Progress Card
                _TodayProgressCard(config: config),
                SizedBox(height: config.verticalGap),

                // Section 4: At a Glance Section
                _AtAGlanceSection(
                  config: config,
                  onMedicinesTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('12 Active medicines are currently tracked.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  onLowStockTap: onInventoryTap,
                  onUpcomingTap: onHistoryTap,
                ),
                SizedBox(height: config.verticalGap),

                // Section 5: Health Tip Card
                _HealthTipCard(config: config),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LayoutConfig {
  final double verticalGap;
  final double avatarSize;
  final double heroPadding;
  final double heroContentHeight;
  final double heroButtonHeight;
  final double progressPadding;
  final double progressRingSize;
  final double glanceCardHeight;
  final double glancePadding;
  final double glanceValueSize;
  final double glanceIconSize;
  final double glanceLabelSize;
  final double glanceSublabelSize;
  final double healthTipHeight;
  final double healthTipMascotSize;
  final double fontSizeName;
  final double fontSizeMedicine;

  _LayoutConfig({
    required this.verticalGap,
    required this.avatarSize,
    required this.heroPadding,
    required this.heroContentHeight,
    required this.heroButtonHeight,
    required this.progressPadding,
    required this.progressRingSize,
    required this.glanceCardHeight,
    required this.glancePadding,
    required this.glanceValueSize,
    required this.glanceIconSize,
    required this.glanceLabelSize,
    required this.glanceSublabelSize,
    required this.healthTipHeight,
    required this.healthTipMascotSize,
    required this.fontSizeName,
    required this.fontSizeMedicine,
  });

  factory _LayoutConfig.fromHeight(double height) {
    // Clamp height to normal range [500, 850] and get scaling factor
    final double factor = ((height - 500) / 350).clamp(0.0, 1.0);

    return _LayoutConfig(
      verticalGap: 7.0 + (9.0 * factor), // 8 to 20
      avatarSize: 38.0 + (14.0 * factor), // 38 to 52
      heroPadding: 12.0 + (8.0 * factor), // 12 to 20
      heroContentHeight: 46.0 + (18.0 * factor), // 46 to 64
      heroButtonHeight: 38.0 + (10.0 * factor), // 38 to 48
      progressPadding: 8.0 + (6.0 * factor), // 8 to 16
      progressRingSize: 82.0 + (28.0 * factor), // 82 to 100
      glanceCardHeight: 105.0 + (18.0 * factor), // 116 to 146
      glancePadding: 8.0, // Fixed padding for consistency
      glanceValueSize: 22.0 + (5.0 * factor), // 28 to 38
      glanceIconSize: 27.0 + (4.0 * factor), // 30 to 38
      glanceLabelSize: 11.5 + (1.5 * factor), // 12 to 14
      glanceSublabelSize: 9.5 + (1.5 * factor), // 10 to 12
      healthTipHeight: 80.0 + (40.0 * factor), // 80 to 120
      healthTipMascotSize: 90.0 + (40.0 * factor), // 90 to 130
      fontSizeName: 20.0 + (10.0 * factor), // 20 to 30
      fontSizeMedicine: 18.0 + (6.0 * factor), // 18 to 24
    );
  }
}

class _HomeHeader extends StatefulWidget {
  const _HomeHeader({required this.config});

  final _LayoutConfig config;

  @override
  State<_HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<_HomeHeader> {
  bool _hasNotification = true;

  @override
  Widget build(BuildContext context) {
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
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFonts.inter,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Mr. Patel 👋',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: widget.config.fontSizeName,
                  fontWeight: FontWeight.w800,
                  fontFamily: AppFonts.inter,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 4),
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
                width: widget.config.avatarSize,
                height: widget.config.avatarSize,
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
                      color: Colors.black.withValues(alpha: 0.02), width: 1.2),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.textPrimary,
                      size: widget.config.avatarSize * 0.55,
                    ),
                    if (_hasNotification)
                      Positioned(
                        right: widget.config.avatarSize * 0.22,
                        top: widget.config.avatarSize * 0.22,
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
            // Profile avatar with soft green background and dynamic layout
            Container(
              width: widget.config.avatarSize,
              height: widget.config.avatarSize,
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
                        width: widget.config.avatarSize - 3,
                        height: widget.config.avatarSize - 3,
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
                      width: widget.config.avatarSize * 0.24,
                      height: widget.config.avatarSize * 0.24,
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
  const _NextDoseCard({required this.config});

  final _LayoutConfig config;

  @override
  State<_NextDoseCard> createState() => _NextDoseCardState();
}

class _NextDoseCardState extends State<_NextDoseCard> {
  bool _isTaken = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32), // CareDose primary deep green
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D32).withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.warning.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(4, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
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
              padding: EdgeInsets.all(widget.config.heroPadding),
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
                          borderRadius: BorderRadius.circular(8),
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
                          borderRadius: BorderRadius.circular(10),
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
                  SizedBox(height: widget.config.verticalGap * 0.8),
                  SizedBox(
                    height: widget.config.heroContentHeight,
                    child: Row(
                      children: [
                        Container(
                          width: widget.config.heroContentHeight,
                          height: widget.config.heroContentHeight,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.warning.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            Icons.medication_rounded,
                            color: AppColors.warning,
                            size: widget.config.heroContentHeight * 0.55,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Aspirin 75mg',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: widget.config.fontSizeMedicine,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: AppFonts.inter,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                '1 Tablet • After Breakfast',
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
                  ),
                  SizedBox(height: widget.config.verticalGap * 0.8),
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 250),
                    crossFadeState: _isTaken
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: SizedBox(
                      height: widget.config.heroButtonHeight,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TappableScale(
                              onTap: () {
                                setState(() => _isTaken = true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Aspirin 75mg logged successfully!'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.warning,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.warning
                                          .withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    )
                                  ],
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
                                    content:
                                        Text('Dose snoozed for 15 minutes.'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
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
                    ),
                    secondChild: Container(
                      height: widget.config.heroButtonHeight,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(12),
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
      ),
    );
  }
}

class _TodayProgressCard extends StatelessWidget {
  const _TodayProgressCard({required this.config});

  final _LayoutConfig config;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(config.progressPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: Colors.black.withValues(alpha: 0.02), width: 1.2),
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
            width: config.progressRingSize,
            height: config.progressRingSize,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 0.85),
              duration: const Duration(milliseconds: 1400),
              curve: Curves.easeInOutCubic,
              builder: (context, value, child) {
                return CustomPaint(
                  painter: _CircularProgressPainter(
                    progress: value,
                    trackColor: const Color(0xFFF1F5F2),
                    progressColors: [
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
                            fontSize: config.progressRingSize * 0.29,
                            fontWeight: FontWeight.w800,
                            fontFamily: AppFonts.inter,
                            height: 0.88,
                            letterSpacing: -1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Today',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: config.progressRingSize * 0.105,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.inter,
                            height: 1.0,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                // PRIMARY — today's adherence summary
                Text(
                  '4 of 5 doses taken',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    fontFamily: AppFonts.inter,
                    height: 1.1,
                    letterSpacing: -0.3,
                  ),
                ),

                const SizedBox(height: 10),

                // SECONDARY — positive feedback
                Text(
                  'Great! You\'re doing well.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.success,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: AppFonts.inter,
                    height: 1.1,
                  ),
                ),

                const SizedBox(height: 8),

                // TERTIARY — supporting context
                Text(
                  'Almost done with today\'s schedule.',
                  maxLines: 2,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: AppFonts.inter,
                    height: 1.35,
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
    required this.config,
    required this.onMedicinesTap,
    required this.onLowStockTap,
    required this.onUpcomingTap,
  });

  final _LayoutConfig config;
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
        Row(
          children: [
            Expanded(
              child: _GlanceCard(
                config: config,
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
                config: config,
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
                config: config,
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
      ],
    );
  }
}

class _GlanceCard extends StatelessWidget {
  const _GlanceCard({
    required this.config,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.value,
    required this.label,
    required this.sublabel,
    required this.onTap,
    this.valueColor,
  });

  final _LayoutConfig config;
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
    return TappableScale(
      onTap: onTap,
      child: Container(
        height: config.glanceCardHeight,
        padding: EdgeInsets.all(config.glancePadding),
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
          children: [
            // Icon
            Container(
              width: config.glanceIconSize,
              height: config.glanceIconSize,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: config.glanceIconSize * 0.55,
              ),
            ),

            const Spacer(),

            // Information group
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 12 / 2 / 1
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: valueColor ?? AppColors.textPrimary,
                      fontSize: config.glanceValueSize,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.inter,
                      height: 0.95,
                      letterSpacing: -0.7,
                    ),
                  ),
                ),

                const SizedBox(height: 3),

                // Medicines / Low Stock / Upcoming
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: config.glanceLabelSize,
                      fontWeight: FontWeight.w700,
                      fontFamily: AppFonts.inter,
                      height: 1.0,
                      letterSpacing: -0.1,
                    ),
                  ),
                ),

                const SizedBox(height: 2),

                // In Stock / Need Refill / Appointment
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    sublabel,
                    style: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.78),
                      fontSize: config.glanceSublabelSize,
                      fontWeight: FontWeight.w400,
                      fontFamily: AppFonts.inter,
                      height: 1.0,
                    ),
                  ),
                ),
              ],
            ),

            // Keeps bottom text above the rounded-corner zone
            const SizedBox(height: 7),
          ],
        ),
      ),
    );
  }
}

class _HealthTipCard extends StatelessWidget {
  const _HealthTipCard({required this.config});

  final _LayoutConfig config;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: config.healthTipHeight,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(12, 7, 12, 7),
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
            // SHARK DOC
            SizedBox(
              width: 78,
              height: double.infinity,
              child: Transform.scale(
                scale: 1.12,
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/mascot/shark_doc_tip.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
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
                  SizedBox(height: 3),
                  Text(
                    'Drink a glass of water with your morning '
                    'medicines to stay hydrated.',
                    maxLines: 2,
                    overflow: TextOverflow.visible,
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
      height: navHeight + 18,
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
                  const SizedBox(width: 68),
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
        width: 60,
        height: 60,
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
          size: 34,
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
