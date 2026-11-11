import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../core/app_constants.dart';
import '../core/app_theme.dart';
import '../models/drink_log.dart';
import '../providers/drink_provider.dart';

class AddDrinkScreen extends StatefulWidget {
  const AddDrinkScreen({super.key});

  @override
  State<AddDrinkScreen> createState() => _AddDrinkScreenState();
}

class _AddDrinkScreenState extends State<AddDrinkScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedType = AppConstants.beverageCategories.first;
  final TextEditingController _volumeController = TextEditingController(text: '250');
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();
  bool _isSubmitting = false;

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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final int volume = int.parse(_volumeController.text.trim());
    final newLog = DrinkLog(
      id: 'log-${DateTime.now().millisecondsSinceEpoch}',
      beverageType: _selectedType,
      volumeMl: volume,
      loggedAt: _selectedDateTime,
      note: _noteController.text.trim(),
    );

    final provider = context.read<DrinkProvider>();
    final success = await provider.createDrinkLog(newLog);

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
                child: Text('Berhasil menyimpan $_selectedType ($volume ml) ke database!'),
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
          content: Text(provider.errorMessage ?? 'Gagal menyimpan ke database'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Catatan Minum'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Jenis Minuman Dropdown
              const Text(
                'Pilih Minuman',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.local_drink_rounded, color: AppTheme.primaryBlue),
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
                'Volume (ml)',
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
                  hintText: 'Contoh: 250',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Volume air tidak boleh kosong';
                  }
                  final num = int.tryParse(val.trim());
                  if (num == null || num <= 0) {
                    return 'Volume harus berupa angka positif';
                  }
                  if (num > 5000) {
                    return 'Volume maksimal 5.000 ml per catatan';
                  }
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

              // 4. Catatan Tambahan (Opsional)
              const Text(
                'Catatan (Opsional)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  hintText: 'Misal: Bangun tidur, setelah olahraga lari pagi...',
                ),
              ),
              const SizedBox(height: 32),

              // Tombol Submit dengan Indikator Loading
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _submit,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.add_task_rounded),
                  label: Text(_isSubmitting ? 'Menyimpan...' : 'Simpan ke Database'),
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
