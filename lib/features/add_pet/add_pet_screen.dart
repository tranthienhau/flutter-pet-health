import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/pet_provider.dart';

class AddPetScreen extends ConsumerStatefulWidget {
  const AddPetScreen({super.key});

  @override
  ConsumerState<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends ConsumerState<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _breedCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _chipCtrl = TextEditingController();
  String _species = 'Dog';
  DateTime _birthDate = DateTime.now().subtract(const Duration(days: 365));

  static const _species = ['Dog', 'Cat', 'Bird', 'Rabbit', 'Other'];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _breedCtrl.dispose();
    _weightCtrl.dispose();
    _chipCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(petsProvider.notifier);
    final pet = notifier.createNew(
      name: _nameCtrl.text.trim(),
      species: _species,
      breed: _breedCtrl.text.trim(),
      birthDate: _birthDate,
      weightKg: double.parse(_weightCtrl.text.trim()),
      microchipId: _chipCtrl.text.trim().isEmpty ? null : _chipCtrl.text.trim(),
    );
    notifier.addPet(pet);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Pet')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Pet Name',
                prefixIcon: Icon(Icons.pets),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _species,
              decoration: const InputDecoration(labelText: 'Species'),
              items: _AddPetScreenState._species
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _species = v!),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _breedCtrl,
              decoration: const InputDecoration(labelText: 'Breed'),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date of Birth'),
              subtitle: Text(
                '${_birthDate.year}-${_birthDate.month.toString().padLeft(2, '0')}-${_birthDate.day.toString().padLeft(2, '0')}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _weightCtrl,
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                prefixIcon: Icon(Icons.monitor_weight),
              ),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Required';
                if (double.tryParse(v) == null) return 'Enter a valid number';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _chipCtrl,
              decoration: const InputDecoration(
                labelText: 'Microchip ID (optional)',
                prefixIcon: Icon(Icons.qr_code),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _save,
              child: const Text('Save Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
