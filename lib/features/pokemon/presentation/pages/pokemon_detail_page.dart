import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/pokemon_entry.dart';
import '../controllers/pokemon_controller.dart';
import 'pokemon_form_page.dart';

class PokemonDetailPage extends StatelessWidget {
  const PokemonDetailPage({super.key, required this.pokemon});

  final PokemonEntry pokemon;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PokemonController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name),
        actions: [
          IconButton(
            tooltip: 'Editar',
            onPressed: () {
              Get.to(() => PokemonFormPage(pokemon: pokemon));
            },
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: 'Eliminar',
            onPressed: () async {
              await controller.deletePokemon(pokemon.id);
              if (context.mounted) {
                Get.back();
              }
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeroCard(pokemon: pokemon),
              const SizedBox(height: 20),
              _DetailTile(label: 'ID', value: pokemon.id),
              _DetailTile(label: 'Origen', value: pokemon.originLabel),
              _DetailTile(label: 'URL', value: pokemon.url),
              _DetailTile(
                label: 'Creado',
                value: pokemon.createdAt.toLocal().toString(),
              ),
              _DetailTile(
                label: 'Actualizado',
                value: pokemon.updatedAt.toLocal().toString(),
              ),
              const Spacer(),
              FilledButton.tonalIcon(
                onPressed: () {
                  Get.to(() => PokemonFormPage(pokemon: pokemon));
                },
                icon: const Icon(Icons.edit),
                label: const Text('Editar registro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.pokemon});

  final PokemonEntry pokemon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: pokemon.isLocal
              ? [Colors.orange.shade700, Colors.deepOrange.shade300]
              : [Colors.amber.shade800, Colors.orange.shade300],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pokemon.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Registro ${pokemon.originLabel.toLowerCase()} en memoria',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.92),
                ),
          ),
        ],
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 6),
            Text(value),
          ],
        ),
      ),
    );
  }
}
