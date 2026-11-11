import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class DrinkItemTile extends StatelessWidget {
  final String beverageType;
  final int volumeMl;
  final String time;
  final String? note;
  final VoidCallback? onTap;

  const DrinkItemTile({
    super.key,
    required this.beverageType,
    required this.volumeMl,
    required this.time,
    this.note,
    this.onTap,
  });

  IconData _getIconForBeverage(String type) {
    switch (type.toLowerCase()) {
      case 'teh':
        return Icons.emoji_food_beverage_rounded;
      case 'kopi':
        return Icons.coffee_rounded;
      case 'jus buah':
        return Icons.blender_rounded;
      case 'susu':
        return Icons.egg_outlined;
      default:
        return Icons.water_drop_rounded;
    }
  }

  Color _getColorForBeverage(String type) {
    switch (type.toLowerCase()) {
      case 'teh':
        return Colors.green;
      case 'kopi':
        return Colors.brown;
      case 'jus buah':
        return Colors.orange;
      case 'susu':
        return Colors.deepPurple;
      default:
        return AppTheme.primaryBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColorForBeverage(beverageType);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        onTap: onTap,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _getIconForBeverage(beverageType),
            color: color,
            size: 20,
          ),
        ),
        title: Text(
          beverageType,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppTheme.darkText,
          ),
        ),
        subtitle: Text(
          note != null && note!.isNotEmpty ? '$time • $note' : time,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.lightText,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.accentLight,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '$volumeMl ml',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlue,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
