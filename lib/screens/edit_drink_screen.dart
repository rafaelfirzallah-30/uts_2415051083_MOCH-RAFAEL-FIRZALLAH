import 'package:flutter/material.dart';
import '../core/app_constants.dart';
import '../core/app_theme.dart';

class EditDrinkScreen extends StatefulWidget {
  final Map<String, dynamic> drinkData;

  const EditDrinkScreen({
    super.key,
    required this.drinkData,
  });

  @override
  State<EditDrinkScreen> createState() => _EditDrinkScreenState();
}

class _EditDrinkScreenState extends State<EditDrinkScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedType;
  late TextEditingController _volumeController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.drinkData['type'] as String? ?? 'Air Mineral';
    if (!AppConstants.beverageCategories.contains(_selectedType)) {
      _selectedType = AppConstants.beverageCategories.first;
    }
    final int volume = widget.drinkData['volume'] as int? ?? 250;
    _volumeController = TextEditingController(text: volume.toString());
    _noteController = TextEditingController(
      text: widget.drinkData['note'] as String? ?? '',
    );
  }

  @override
  void dispose() {
    _volumeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perubahan data berhasil disimpan')),
      );
      Navigator.pop(context);
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
                  if (val == null || val.isEmpty) return 'Volume wajib diisi';
                  final num = int.tryParse(val);
                  if (num == null || num <= 0) return 'Masukkan angka volume valid';
                  return null;
                },
              ),
              const SizedBox(height: 20),

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

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveChanges,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('Simpan Perubahan'),
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
