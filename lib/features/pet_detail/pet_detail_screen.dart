import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/providers/pet_provider.dart';
import '../../core/providers/health_record_provider.dart';
import '../../core/models/health_record.dart';
import '../add_health_record/add_health_record_screen.dart';

class PetDetailScreen extends ConsumerWidget {
  final String petId;
  const PetDetailScreen({super.key, required this.petId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pet = ref.watch(petsProvider).where((p) => p.id == petId).firstOrNull;
    final records = ref.watch(healthRecordsForPetProvider(petId));

    if (pet == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pet')),
        body: const Center(child: Text('Pet not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {/* TODO: edit pet */},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _PetHeader(pet: pet),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Health Records',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  TextButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddHealthRecordScreen(petId: petId),
                      ),
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add'),
                  ),
                ],
              ),
            ),
          ),
          records.isEmpty
              ? const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('No health records yet'),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => _HealthRecordTile(record: records[i]),
                    childCount: records.length,
                  ),
                ),
        ],
      ),
    );
  }
}

class _PetHeader extends StatelessWidget {
  final dynamic pet;
  const _PetHeader({required this.pet});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Text(
              pet.species[0].toUpperCase(),
              style: TextStyle(
                fontSize: 32,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pet.name, style: theme.textTheme.headlineSmall),
                Text('${pet.breed} - ${pet.species}'),
                Text('${pet.ageLabel} old - ${pet.weightKg} kg'),
                if (pet.microchipId != null)
                  Text('Chip: ${pet.microchipId}',
                      style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthRecordTile extends StatelessWidget {
  final HealthRecord record;
  const _HealthRecordTile({required this.record});

  IconData get _icon => switch (record.recordType) {
        HealthRecordType.weight => Icons.monitor_weight,
        HealthRecordType.vaccination => Icons.vaccines,
        HealthRecordType.vetVisit => Icons.local_hospital,
        HealthRecordType.medication => Icons.medication,
        HealthRecordType.symptom => Icons.warning_amber,
        HealthRecordType.note => Icons.note,
      };

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('MMM d, yyyy');
    return ListTile(
      leading: Icon(_icon),
      title: Text(record.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(fmt.format(record.date)),
          if (record.value != null)
            Text('${record.value} ${record.unit ?? ''}'),
          if (record.notes != null) Text(record.notes!),
          if (record.nextDueDate != null)
            Text('Next due: ${fmt.format(record.nextDueDate!)}',
                style: const TextStyle(color: Colors.orange)),
        ],
      ),
      isThreeLine: record.notes != null || record.nextDueDate != null,
    );
  }
}
