import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/models/pet.dart';
import 'core/models/health_record.dart';
import 'core/models/routine.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PetAdapter());
  Hive.registerAdapter(HealthRecordAdapter());
  Hive.registerAdapter(RoutineAdapter());
  await Hive.openBox<Pet>('pets');
  await Hive.openBox<HealthRecord>('health_records');
  await Hive.openBox<Routine>('routines');
  runApp(const ProviderScope(child: PetCareApp()));
}
