import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class QuickDrinkButton extends StatelessWidget {
  final int volumeMl;
  final VoidCallback onTap;

  const QuickDrinkButton({
    super.key,
    required this.volumeMl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.accentLight, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppTheme.accentLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_drink_rounded,
                  color: AppTheme.primaryBlue,
                  size: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '+$volumeMl ml',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: AppTheme.darkText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
