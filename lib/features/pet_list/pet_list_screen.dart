import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/pet_provider.dart';
import '../../core/models/pet.dart';
import '../pet_detail/pet_detail_screen.dart';
import '../add_pet/add_pet_screen.dart';

class PetListScreen extends ConsumerWidget {
  const PetListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pets = ref.watch(petsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pets'),
        centerTitle: true,
      ),
      body: pets.isEmpty
          ? _EmptyState(
              onAdd: () => _openAddPet(context),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: pets.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) => _PetCard(
                pet: pets[i],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PetDetailScreen(petId: pets[i].id),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddPet(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Pet'),
      ),
    );
  }

  void _openAddPet(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddPetScreen()),
    );
  }
}

class _PetCard extends StatelessWidget {
  final Pet pet;
  final VoidCallback onTap;

  const _PetCard({required this.pet, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            pet.species.isNotEmpty ? pet.species[0].toUpperCase() : '?',
            style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
          ),
        ),
        title: Text(pet.name, style: theme.textTheme.titleMedium),
        subtitle: Text('${pet.breed} - ${pet.ageLabel} - ${pet.weightKg} kg'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.pets, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('No pets yet', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          const Text('Add your first pet to start tracking their health'),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add Pet'),
          ),
        ],
      ),
    );
  }
}
