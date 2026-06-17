import 'package:flutter/material.dart';
import '../theme/colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: Icons.check_box_outlined, index: 0, currentIndex: currentIndex, onTap: onTap),
          _NavItem(icon: Icons.bolt_outlined, index: 1, currentIndex: currentIndex, onTap: onTap),
          _NavItem(icon: Icons.nights_stay_outlined, index: 2, currentIndex: currentIndex, onTap: onTap),
          _NavItem(icon: Icons.person_outline, index: 3, currentIndex: currentIndex, onTap: onTap),
          _NavItem(icon: Icons.people_outline, index: 4, currentIndex: currentIndex, onTap: onTap),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool selected = index == currentIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Icon(
        icon,
        size: 26,
        color: selected ? kTodoTitle : kTodoIcon,
      ),
    );
  }
}
