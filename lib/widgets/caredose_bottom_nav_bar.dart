import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class CareDoseBottomNavBar extends StatelessWidget {
  const CareDoseBottomNavBar({
    required this.selectedIndex,
    required this.onTabSelected,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  static const List<_CareDoseNavItem> _items = [
    _CareDoseNavItem(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    _CareDoseNavItem(
      label: 'Inventory',
      icon: Icons.inventory_2_outlined,
      activeIcon: Icons.inventory_2_rounded,
    ),
    _CareDoseNavItem(
      label: 'Add Medicine',
      icon: Icons.add_rounded,
      activeIcon: Icons.add_rounded,
      isPrimaryAction: true,
    ),
    _CareDoseNavItem(
      label: 'History',
      icon: Icons.history_rounded,
      activeIcon: Icons.history_rounded,
    ),
    _CareDoseNavItem(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.card.withValues(alpha: 0.98),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.black.withValues(alpha: 0.02), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: SizedBox(
          height: 82,
          child: Row(
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isSelected = selectedIndex == index;

              return Expanded(
                child: item.isPrimaryAction
                    ? _PrimaryNavButton(
                        item: item,
                        isSelected: isSelected,
                        onPressed: () => onTabSelected(index),
                      )
                    : _NavIconButton(
                        item: item,
                        isSelected: isSelected,
                        onPressed: () => onTabSelected(index),
                      ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavIconButton extends StatefulWidget {
  const _NavIconButton({
    required this.item,
    required this.isSelected,
    required this.onPressed,
  });

  final _CareDoseNavItem item;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  State<_NavIconButton> createState() => _NavIconButtonState();
}

class _NavIconButtonState extends State<_NavIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final iconColor = widget.isSelected ? AppColors.primary : AppColors.textSecondary;

    return Tooltip(
      message: widget.item.label,
      child: Semantics(
        button: true,
        selected: widget.isSelected,
        label: widget.item.label,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapCancel: () => setState(() => _isPressed = false),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTap: widget.onPressed,
          child: AnimatedScale(
            scale: _isPressed ? 0.92 : 1.0,
            duration: const Duration(milliseconds: 80),
            curve: Curves.easeOut,
            child: Container(
              color: Colors.transparent, // Expand tap area
              height: 64,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.isSelected ? widget.item.activeIcon : widget.item.icon,
                    color: iconColor,
                    size: 28,
                  ),
                  const SizedBox(height: 6),
                  _SelectionDot(isVisible: widget.isSelected),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimaryNavButton extends StatefulWidget {
  const _PrimaryNavButton({
    required this.item,
    required this.isSelected,
    required this.onPressed,
  });

  final _CareDoseNavItem item;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  State<_PrimaryNavButton> createState() => _PrimaryNavButtonState();
}

class _PrimaryNavButtonState extends State<_PrimaryNavButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.item.label,
      child: Semantics(
        button: true,
        selected: widget.isSelected,
        label: widget.item.label,
        child: Center(
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapCancel: () => setState(() => _isPressed = false),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTap: widget.onPressed,
            child: AnimatedScale(
              scale: _isPressed ? 0.94 : 1.0,
              duration: const Duration(milliseconds: 80),
              curve: Curves.easeOut,
              child: Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: AppColors.textPrimary, // Dominant circular black button
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.isSelected
                        ? AppColors.warning
                        : Colors.white.withValues(alpha: 0.1),
                    width: widget.isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                    if (widget.isSelected)
                      BoxShadow(
                        color: AppColors.warning.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 0),
                      ),
                  ],
                ),
                child: Icon(
                  Icons.add_rounded,
                  color: widget.isSelected ? AppColors.warning : AppColors.card,
                  size: 36,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectionDot extends StatelessWidget {
  const _SelectionDot({required this.isVisible});

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: isVisible ? 6 : 0,
      height: isVisible ? 6 : 0,
      decoration: const BoxDecoration(
        color: AppColors.primary, // Matches primary green theme
        shape: BoxShape.circle,
      ),
    );
  }
}

class _CareDoseNavItem {
  const _CareDoseNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    this.isPrimaryAction = false,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final bool isPrimaryAction;
}
