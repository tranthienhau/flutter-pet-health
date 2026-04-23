import 'package:hive/hive.dart';

part 'routine.g.dart';

enum RoutineFrequency { daily, weekly, monthly, custom }

@HiveType(typeId: 2)
class Routine extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String petId;

  @HiveField(2)
  String title;

  @HiveField(3)
  String? description;

  @HiveField(4)
  final int frequencyIndex;

  @HiveField(5)
  TimeOfDay? reminderTime;

  @HiveField(6)
  List<int> weekdays; // 1=Mon, 7=Sun

  @HiveField(7)
  bool isActive;

  @HiveField(8)
  DateTime? lastCompleted;

  Routine({
    required this.id,
    required this.petId,
    required this.title,
    this.description,
    required this.frequencyIndex,
    this.reminderTime,
    List<int>? weekdays,
    this.isActive = true,
    this.lastCompleted,
  }) : weekdays = weekdays ?? [];

  RoutineFrequency get frequency => RoutineFrequency.values[frequencyIndex];
}

// TimeOfDay is not directly Hive-serializable; store as two ints
extension TimeOfDayHive on TimeOfDay {
  int toMinutes() => hour * 60 + minute;
  static TimeOfDay fromMinutes(int m) => TimeOfDay(hour: m ~/ 60, minute: m % 60);
}
