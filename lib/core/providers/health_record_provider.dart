import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/health_record.dart';

final _uuid = const Uuid();

final healthRecordBoxProvider =
    Provider<Box<HealthRecord>>((ref) => Hive.box<HealthRecord>('health_records'));

final healthRecordsForPetProvider =
    StateNotifierProvider.family<HealthRecordsNotifier, List<HealthRecord>, String>(
  (ref, petId) {
    final box = ref.watch(healthRecordBoxProvider);
    return HealthRecordsNotifier(box, petId);
  },
);

class HealthRecordsNotifier extends StateNotifier<List<HealthRecord>> {
  final Box<HealthRecord> _box;
  final String petId;

  HealthRecordsNotifier(this._box, this.petId)
      : super(_box.values.where((r) => r.petId == petId).toList()
          ..sort((a, b) => b.date.compareTo(a.date)));

  void _reload() {
    state = _box.values.where((r) => r.petId == petId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> addRecord(HealthRecord record) async {
    await _box.put(record.id, record);
    _reload();
  }

  Future<void> deleteRecord(String id) async {
    await _box.delete(id);
    _reload();
  }

  HealthRecord create({
    required HealthRecordType type,
    required String title,
    required DateTime date,
    String? notes,
    double? value,
    String? unit,
    DateTime? nextDueDate,
  }) =>
      HealthRecord(
        id: _uuid.v4(),
        petId: petId,
        recordTypeIndex: type.index,
        date: date,
        title: title,
        notes: notes,
        value: value,
        unit: unit,
        nextDueDate: nextDueDate,
      );
}
