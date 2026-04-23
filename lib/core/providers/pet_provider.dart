import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/pet.dart';

final _uuid = const Uuid();

final petBoxProvider = Provider<Box<Pet>>((ref) => Hive.box<Pet>('pets'));

final petsProvider = StateNotifierProvider<PetsNotifier, List<Pet>>((ref) {
  final box = ref.watch(petBoxProvider);
  return PetsNotifier(box);
});

class PetsNotifier extends StateNotifier<List<Pet>> {
  final Box<Pet> _box;

  PetsNotifier(this._box) : super(_box.values.toList());

  Future<void> addPet(Pet pet) async {
    await _box.put(pet.id, pet);
    state = _box.values.toList();
  }

  Future<void> updatePet(Pet pet) async {
    await _box.put(pet.id, pet);
    state = _box.values.toList();
  }

  Future<void> deletePet(String id) async {
    await _box.delete(id);
    state = _box.values.toList();
  }

  Pet? getPet(String id) => _box.get(id);

  Pet createNew({
    required String name,
    required String species,
    required String breed,
    required DateTime birthDate,
    required double weightKg,
    String? microchipId,
  }) =>
      Pet(
        id: _uuid.v4(),
        name: name,
        species: species,
        breed: breed,
        birthDate: birthDate,
        weightKg: weightKg,
        microchipId: microchipId,
      );
}
