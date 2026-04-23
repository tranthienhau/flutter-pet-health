import 'package:hive/hive.dart';

part 'pet.g.dart';

@HiveType(typeId: 0)
class Pet extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String species; // dog, cat, bird, etc.

  @HiveField(3)
  String breed;

  @HiveField(4)
  DateTime birthDate;

  @HiveField(5)
  String? photoPath;

  @HiveField(6)
  double weightKg;

  @HiveField(7)
  String? microchipId;

  @HiveField(8)
  List<String> caregiverEmails;

  Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.birthDate,
    this.photoPath,
    required this.weightKg,
    this.microchipId,
    List<String>? caregiverEmails,
  }) : caregiverEmails = caregiverEmails ?? [];

  int get ageMonths {
    final now = DateTime.now();
    return (now.year - birthDate.year) * 12 + now.month - birthDate.month;
  }

  String get ageLabel {
    final months = ageMonths;
    if (months < 12) return '$months mo';
    final years = months ~/ 12;
    final rem = months % 12;
    return rem == 0 ? '${years}y' : '${years}y ${rem}mo';
  }
}
