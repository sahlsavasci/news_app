import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected 
                ? Theme.of(context).primaryColor 
                : (Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black).withValues(alpha: 0.6),
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
