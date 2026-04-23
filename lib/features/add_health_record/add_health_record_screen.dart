import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/health_record_provider.dart';
import '../../core/models/health_record.dart';

class AddHealthRecordScreen extends ConsumerStatefulWidget {
  final String petId;
  const AddHealthRecordScreen({super.key, required this.petId});

  @override
  ConsumerState<AddHealthRecordScreen> createState() =>
      _AddHealthRecordScreenState();
}

class _AddHealthRecordScreenState
    extends ConsumerState<AddHealthRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _valueCtrl = TextEditingController();
  final _unitCtrl = TextEditingController();
  HealthRecordType _type = HealthRecordType.vetVisit;
  DateTime _date = DateTime.now();
  DateTime? _nextDueDate;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _notesCtrl.dispose();
    _valueCtrl.dispose();
    _unitCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate({bool isNextDue = false}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isNextDue ? (_nextDueDate ?? DateTime.now()) : _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null) {
      setState(() {
        if (isNextDue) {
          _nextDueDate = picked;
        } else {
          _date = picked;
        }
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final notifier =
        ref.read(healthRecordsForPetProvider(widget.petId).notifier);
    final record = notifier.create(
      type: _type,
      title: _titleCtrl.text.trim(),
      date: _date,
      notes:
          _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      value: _valueCtrl.text.trim().isEmpty
          ? null
          : double.tryParse(_valueCtrl.text.trim()),
      unit: _unitCtrl.text.trim().isEmpty ? null : _unitCtrl.text.trim(),
      nextDueDate: _nextDueDate,
    );
    notifier.addRecord(record);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Health Record')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<HealthRecordType>(
              value: _type,
              decoration: const InputDecoration(labelText: 'Record Type'),
              items: HealthRecordType.values
                  .map((t) => DropdownMenuItem(
                        value: t,
                        child: Text(t.name
                            .replaceAllMapped(
                              RegExp(r'[A-Z]'),
                              (m) => ' ${m.group(0)}',
                            )
                            .trim()
                            .capitalize()),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _type = v!),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date'),
              subtitle: Text(_date.toString().substring(0, 10)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _pickDate(),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _valueCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Value (optional)'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _unitCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Unit (optional)'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesCtrl,
              decoration: const InputDecoration(labelText: 'Notes (optional)'),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Next Due Date (optional)'),
              subtitle: Text(_nextDueDate?.toString().substring(0, 10) ??
                  'Not set'),
              trailing: const Icon(Icons.event),
              onTap: () => _pickDate(isNextDue: true),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _save,
              child: const Text('Save Record'),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringCapitalize on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
