import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    _volumeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final int volume = int.parse(_volumeController.text.trim());
      final newLog = DrinkLog(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        beverageType: _selectedType,
        volumeMl: volume,
        loggedAt: DateTime.now(),
        note: _noteController.text.trim(),
      );

      // Save via Provider
      context.read<DrinkProvider>().addDrinkLog(newLog);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil mencatat $_selectedType ($volume ml)'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
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
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Volume tidak boleh kosong';
                  final num = int.tryParse(val);
                  if (num == null || num <= 0) return 'Masukkan angka volume valid';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                children: AppConstants.quickIntakePresets.map((ml) {
                  return ActionChip(
                    label: Text('+$ml ml'),
                    onPressed: () {
                      _volumeController.text = ml.toString();
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

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
                  hintText: 'Misal: Bangun tidur, setelah olahraga...',
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.add_task_rounded),
                  label: const Text('Simpan Catatan Minum'),
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
