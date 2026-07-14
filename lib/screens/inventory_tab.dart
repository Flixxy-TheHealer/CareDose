import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/medicine_model.dart';

class InventoryTab extends StatefulWidget {
  const InventoryTab({super.key});
  @override
  State<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab> {
  @override
  Widget build(BuildContext context) {
    final items = AppData.inventory;
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
            Text('My Inventory', style: AppTextStyles.heading2),
            const SizedBox(height: 4),
            Text('Check your current medication supplies.',
                style: AppTextStyles.body),
            const SizedBox(height: 20),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) => _buildInventoryCard(items[i]),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'inventory-add-refill',
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildInventoryCard(InventoryItem item) {
    final isLow = item.stockLevel == StockLevel.low;
    final borderColor = isLow ? AppColors.dangerBorder : AppColors.border;
    final bgColor = isLow ? AppColors.dangerLight : AppColors.white;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: isLow ? 1.5 : 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: item.iconBgColor.withValues(alpha: isLow ? 0.15 : 1.0),
                  shape: BoxShape.circle,
                  border: isLow
                      ? Border.all(color: AppColors.danger, width: 1.5)
                      : null,
                ),
                child: Icon(
                  isLow ? Icons.medical_services : Icons.medication,
                  color: isLow ? AppColors.danger : Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          item.name,
                          style: AppTextStyles.heading3.copyWith(
                            color: isLow
                                ? AppColors.danger
                                : AppColors.textPrimary,
                          ),
                        ),
                        if (isLow) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.warning_amber_rounded,
                              color: AppColors.danger, size: 16),
                        ],
                      ],
                    ),
                    Text('${item.dosage} • ${item.description}',
                        style: AppTextStyles.body),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Stock level row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${item.tabletsLeft} tablets left',
                style: AppTextStyles.label.copyWith(
                  color: isLow ? AppColors.danger : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                item.stockLabel,
                style: AppTextStyles.label.copyWith(
                  color: item.stockColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: item.stockPercentage,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(item.progressColor),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Empty', style: AppTextStyles.bodySmall),
              Text('${item.totalTablets} total',
                  style: AppTextStyles.bodySmall),
            ],
          ),
          const SizedBox(height: 14),
          // Action button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: isLow
                ? ElevatedButton.icon(
                    onPressed: () => _showRefillDialog(item),
                    icon: const Icon(Icons.shopping_cart_outlined,
                        color: Colors.white, size: 18),
                    label: const Text('Order Refill',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  )
                : OutlinedButton.icon(
                    onPressed: () => _showRefillDialog(item),
                    icon: const Icon(Icons.refresh,
                        color: AppColors.primary, size: 18),
                    label: const Text('Refill',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showRefillDialog(InventoryItem item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Refill ${item.name}'),
        content: Text(
            'Would you like to order a refill for ${item.name} ${item.dosage}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Refill order placed for ${item.name}')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
