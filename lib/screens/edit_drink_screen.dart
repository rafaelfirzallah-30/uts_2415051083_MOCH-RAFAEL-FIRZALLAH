import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../core/app_constants.dart';
import '../core/app_theme.dart';
import '../models/drink_log.dart';
import '../providers/drink_provider.dart';

class EditDrinkScreen extends StatefulWidget {
  final DrinkLog drinkLog;

  const EditDrinkScreen({
    super.key,
    required this.drinkLog,
  });

  @override
  State<EditDrinkScreen> createState() => _EditDrinkScreenState();
}

class _EditDrinkScreenState extends State<EditDrinkScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedType;
  late TextEditingController _volumeController;
  late TextEditingController _noteController;
  late DateTime _selectedDateTime;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.drinkLog.beverageType;
    if (!AppConstants.beverageCategories.contains(_selectedType)) {
      _selectedType = AppConstants.beverageCategories.first;
    }
    _volumeController = TextEditingController(text: widget.drinkLog.volumeMl.toString());
    _noteController = TextEditingController(text: widget.drinkLog.note);
    _selectedDateTime = widget.drinkLog.loggedAt;
  }

  @override
  void dispose() {
    _volumeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final int volume = int.parse(_volumeController.text.trim());
    final updatedLog = widget.drinkLog.copyWith(
      beverageType: _selectedType,
      volumeMl: volume,
      loggedAt: _selectedDateTime,
      note: _noteController.text.trim(),
    );

    final provider = context.read<DrinkProvider>();
    final success = await provider.updateDrinkLogInDatabase(updatedLog);

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text('Perubahan data $_selectedType ($volume ml) berhasil disimpan!'),
              ),
            ],
          ),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Gagal memperbarui data di database'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Catatan Minum'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Jenis Minuman
              const Text(
                'Jenis Minuman',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.category_rounded, color: AppTheme.primaryBlue),
                ),
                items: AppConstants.beverageCategories.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedType = val);
                },
              ),
              const SizedBox(height: 20),

              // 2. Volume Cairan (Validation: Required, Numeric, > 0, <= 5000)
              const Text(
                'Volume Cairan (ml)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _volumeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.water_drop_rounded, color: AppTheme.primaryBlue),
                  suffixText: 'ml',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Volume wajib diisi';
                  final num = int.tryParse(val.trim());
                  if (num == null || num <= 0) return 'Masukkan angka volume valid';
                  if (num > 5000) return 'Volume maksimal 5.000 ml per catatan';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Preset Quick Chips
              Wrap(
                spacing: 8,
                children: AppConstants.quickIntakePresets.map((ml) {
                  final isCurrent = _volumeController.text == ml.toString();
                  return ChoiceChip(
                    label: Text('+$ml ml'),
                    selected: isCurrent,
                    onSelected: (_) {
                      setState(() {
                        _volumeController.text = ml.toString();
                      });
                    },
                    selectedColor: AppTheme.accentLight,
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // 3. Waktu Minum (Interactive TimePicker)
              const Text(
                'Waktu Minum',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickTime,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time_rounded, color: AppTheme.primaryBlue),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat('HH:mm - dd MMM yyyy').format(_selectedDateTime),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      const Text(
                        'Ubah',
                        style: TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 4. Catatan Tambahan
              const Text(
                'Catatan Tambahan',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  hintText: 'Misal: Setelah sarapan, air dingin, dll.',
                ),
              ),
              const SizedBox(height: 32),

              // Tombol Simpan Perubahan dengan Indikator Loading
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _saveChanges,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.save_rounded),
                  label: Text(_isSubmitting ? 'Menyimpan...' : 'Simpan Perubahan Data'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
