import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_pet_health/core/models/pet.dart';
import 'package:flutter_pet_health/core/models/health_record.dart';
import 'package:flutter_pet_health/core/models/routine.dart';
import 'package:flutter_pet_health/features/pet_list/pet_list_screen.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> shoot(WidgetTester tester, String name) async {
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();
    await binding.takeScreenshot(name);
  }

  setUpAll(() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(PetAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(HealthRecordAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(RoutineAdapter());

    final pets = await Hive.openBox<Pet>('pets');
    final records = await Hive.openBox<HealthRecord>('health_records');
    await Hive.openBox<Routine>('routines');

    await pets.clear();
    await records.clear();

    final now = DateTime.now();

    final luna = Pet(
      id: 'pet-luna',
      name: 'Luna',
      species: 'Dog',
      breed: 'Golden Retriever',
      birthDate: DateTime(now.year - 3, 4, 12),
      weightKg: 28.4,
      microchipId: '985141000123456',
      caregiverEmails: const ['vet@petcare.io', 'sitter@petcare.io'],
    );
    final milo = Pet(
      id: 'pet-milo',
      name: 'Milo',
      species: 'Cat',
      breed: 'British Shorthair',
      birthDate: DateTime(now.year - 2, 9, 2),
      weightKg: 5.1,
      microchipId: '985141000987654',
    );
    final kiwi = Pet(
      id: 'pet-kiwi',
      name: 'Kiwi',
      species: 'Bird',
      breed: 'Cockatiel',
      birthDate: DateTime(now.year - 1, 1, 20),
      weightKg: 0.09,
    );

    await pets.put(luna.id, luna);
    await pets.put(milo.id, milo);
    await pets.put(kiwi.id, kiwi);

    final lunaRecords = <HealthRecord>[
      HealthRecord(
        id: 'r1',
        petId: luna.id,
        recordTypeIndex: HealthRecordType.vaccination.index,
        date: DateTime(now.year, now.month - 1, 8),
        title: 'Rabies Booster',
        notes: 'Administered by Dr. Patel at Greenfield Vet',
        nextDueDate: DateTime(now.year + 1, now.month - 1, 8),
      ),
      HealthRecord(
        id: 'r2',
        petId: luna.id,
        recordTypeIndex: HealthRecordType.weight.index,
        date: DateTime(now.year, now.month, 2),
        title: 'Weight Check',
        value: 28.4,
        unit: 'kg',
        notes: 'Healthy range, slight gain since spring',
      ),
      HealthRecord(
        id: 'r3',
        petId: luna.id,
        recordTypeIndex: HealthRecordType.vetVisit.index,
        date: DateTime(now.year, now.month, 5),
        title: 'Annual Wellness Exam',
        notes: 'Teeth cleaning recommended next visit',
      ),
      HealthRecord(
        id: 'r4',
        petId: luna.id,
        recordTypeIndex: HealthRecordType.medication.index,
        date: DateTime(now.year, now.month, 6),
        title: 'Flea & Tick - NexGard',
        notes: 'Monthly chewable',
        nextDueDate: DateTime(now.year, now.month + 1, 6),
      ),
    ];
    for (final r in lunaRecords) {
      await records.put(r.id, r);
    }
  });

  testWidgets('capture pet health flow', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: PetListScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await shoot(tester, '01-pet-list');

    // Open Luna's detail screen (profile header + health records timeline).
    await tester.tap(find.text('Luna'));
    await tester.pumpAndSettle();
    await shoot(tester, '02-pet-profile');

    // Add a new health record to show the logging form, pre-filled.
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Title'), 'Heartworm Test');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Notes (optional)'),
        'Negative result, next test in 12 months');
    await tester.pumpAndSettle();
    await shoot(tester, '03-add-health-record');
  });
}
