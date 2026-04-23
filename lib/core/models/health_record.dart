import 'package:hive/hive.dart';

part 'health_record.g.dart';

enum HealthRecordType { weight, vaccination, vetVisit, medication, symptom, note }

@HiveType(typeId: 1)
class HealthRecord extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String petId;

  @HiveField(2)
  final int recordTypeIndex;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String title;

  @HiveField(5)
  final String? notes;

  @HiveField(6)
  final double? value; // weight in kg, temperature, etc.

  @HiveField(7)
  final String? unit;

  @HiveField(8)
  DateTime? nextDueDate; // e.g. next booster date

  HealthRecord({
    required this.id,
    required this.petId,
    required this.recordTypeIndex,
    required this.date,
    required this.title,
    this.notes,
    this.value,
    this.unit,
    this.nextDueDate,
  });

  HealthRecordType get recordType => HealthRecordType.values[recordTypeIndex];
}
