import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_constants.dart';
import '../core/app_feedback.dart';
import '../core/app_theme.dart';
import '../models/drink_log.dart';
import '../providers/drink_provider.dart';

class QuickAddSheet extends StatefulWidget {
  const QuickAddSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const QuickAddSheet(),
    );
  }

  @override
  State<QuickAddSheet> createState() => _QuickAddSheetState();
}

class _QuickAddSheetState extends State<QuickAddSheet> {
  String _selectedCategory = AppConstants.beverageCategories.first;
  double _volumeMl = 250;
  bool _isSaving = false;

  Future<void> _submit() async {
    setState(() => _isSaving = true);

    final newLog = DrinkLog(
      id: 'log-${DateTime.now().millisecondsSinceEpoch}',
      beverageType: _selectedCategory,
      volumeMl: _volumeMl.toInt(),
      loggedAt: DateTime.now(),
      note: 'Dicatat via Quick Sheet',
    );

    final provider = context.read<DrinkProvider>();
    final success = await provider.createDrinkLog(newLog);

    if (mounted) {
      setState(() => _isSaving = false);
      Navigator.pop(context); // Tutup bottom sheet
      if (success) {
        AppFeedback.showSuccess(
          context,
          'Berhasil mencatat $_selectedCategory (${_volumeMl.toInt()} ml)!',
        );
      } else {
        AppFeedback.showError(
          context,
          provider.errorMessage ?? 'Gagal menyimpan catatan.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Catat Minum Cepat',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 1. Interactive Beverage Category ChoiceChips
          const Text(
            'Pilih Jenis Minuman:',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.darkText),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: AppConstants.beverageCategories.map((type) {
                final isSelected = _selectedCategory == type;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) setState(() => _selectedCategory = type);
                    },
                    selectedColor: AppTheme.accentLight,
                    checkmarkColor: AppTheme.primaryBlue,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // 2. Interactive Volume Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Volume Air:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.darkText),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_volumeMl.toInt()} ml',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlue,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          Slider(
            value: _volumeMl,
            min: 50,
            max: 1000,
            divisions: 19, // step 50 ml
            label: '${_volumeMl.toInt()} ml',
            activeColor: AppTheme.primaryBlue,
            onChanged: (val) => setState(() => _volumeMl = val),
          ),
          const SizedBox(height: 16),

          // 3. Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isSaving ? null : _submit,
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.check_circle_outline),
              label: Text(_isSaving ? 'Menyimpan...' : 'Catat Minum Sekarang'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
