import 'package:flutter/material.dart';
import 'dart:math';
import '../theme/app_theme.dart';
import '../models/medicine_model.dart';

class ReportsTab extends StatelessWidget {
  const ReportsTab({super.key});
  @override
  Widget build(BuildContext context) {
    final recentDoses = AppData.recentDoses;
    final weeklyData = AppData.weeklyData;
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text('CareDose',
            style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: AppColors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Adherence Report', style: AppTextStyles.heading2),
            const SizedBox(height: 4),
            Text('Review your medication history and track your progress.',
                style: AppTextStyles.body),
            const SizedBox(height: 20),
            // Circular adherence card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: 130,
                    height: 130,
                    child: CustomPaint(
                      painter: _CircularProgressPainter(
                        percentage: 0.92,
                        color: AppColors.successGreen,
                        bgColor: Colors.grey.shade200,
                        strokeWidth: 12,
                      ),
                      child: const Center(
                        child: Text(
                          '92%',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.successGreen,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Monthly Adherence',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  const Text("Excellent progress! You're on track.",
                      style: TextStyle(
                          fontSize: 13, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Share Progress Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.people_outline,
                        color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Share Progress',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        const SizedBox(height: 2),
                        const Text(
                          'Keep your loved ones informed\nabout your health journey.',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.send,
                              color: Colors.white, size: 14),
                          label: const Text('Share with Guardian',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Past 7 Days bar chart
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Past 7 Days',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 120,
                    child: _SimpleBarChart(data: weeklyData, days: days),
                  ),
                  const SizedBox(height: 12),
                  // Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegend(AppColors.successGreen, 'Taken'),
                      const SizedBox(width: 16),
                      _buildLegend(AppColors.danger, 'Missed'),
                      const SizedBox(width: 16),
                      _buildLegend(AppColors.skipped, 'Skipped'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Recent Doses
            const Text('Recent Doses',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentDoses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _buildDoseItem(recentDoses[i]),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(label,
            style:
                const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildDoseItem(DoseRecord record) {
    Color iconColor;
    Color bgColor;
    IconData icon;
    switch (record.status) {
      case MedicineStatus.taken:
        iconColor = AppColors.successGreen;
        bgColor = AppColors.successLight;
        icon = Icons.check_circle;
        break;
      case MedicineStatus.missed:
        iconColor = AppColors.danger;
        bgColor = AppColors.dangerLight;
        icon = Icons.cancel;
        break;
      case MedicineStatus.skipped:
        iconColor = AppColors.skipped;
        bgColor = Colors.grey.shade100;
        icon = Icons.remove_circle_outline;
        break;
      default:
        iconColor = AppColors.textSecondary;
        bgColor = Colors.grey.shade100;
        icon = Icons.help_outline;
    }
    String statusLabel;
    switch (record.status) {
      case MedicineStatus.taken:
        statusLabel = 'Taken';
        break;
      case MedicineStatus.missed:
        statusLabel = 'Missed';
        break;
      case MedicineStatus.skipped:
        statusLabel = 'Skipped';
        break;
      default:
        statusLabel = '';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(record.medicineName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.textPrimary)),
                Text(record.dosage, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Text(statusLabel,
              style: TextStyle(
                  color: iconColor, fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}

// ── Custom painters ────────────────────────────────────────────────────────────
class _CircularProgressPainter extends CustomPainter {
  final double percentage;
  final Color color;
  final Color bgColor;
  final double strokeWidth;
  _CircularProgressPainter({
    required this.percentage,
    required this.color,
    required this.bgColor,
    required this.strokeWidth,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    // Background arc
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = bgColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
    // Progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * percentage,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _SimpleBarChart extends StatelessWidget {
  final List<Map<String, int>> data;
  final List<String> days;
  const _SimpleBarChart({required this.data, required this.days});
  @override
  Widget build(BuildContext context) {
    const maxVal = 4.0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(data.length, (i) {
        final taken = data[i]['taken']!.toDouble();
        final missed = data[i]['missed']!.toDouble();
        final skipped = data[i]['skipped']!.toDouble();
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Y-axis values
            Text('${(taken + missed + skipped).toInt()}',
                style: const TextStyle(
                    fontSize: 10, color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            // Stacked bar
            SizedBox(
              width: 22,
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (skipped > 0)
                    Container(
                      height: (skipped / maxVal) * 80,
                      decoration: BoxDecoration(
                        color: AppColors.skipped,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  if (missed > 0)
                    Container(
                      height: (missed / maxVal) * 80,
                      color: AppColors.danger,
                    ),
                  if (taken > 0)
                    Container(
                      height: (taken / maxVal) * 80,
                      decoration: BoxDecoration(
                        color: AppColors.successGreen,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                              skipped > 0 || missed > 0 ? 0 : 4),
                          topRight: Radius.circular(
                              skipped > 0 || missed > 0 ? 0 : 4),
                          bottomLeft: const Radius.circular(3),
                          bottomRight: const Radius.circular(3),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(days[i],
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary)),
          ],
        );
      }),
    );
  }
}
