import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/pokemon_entry.dart';
import '../controllers/pokemon_controller.dart';

class PokemonFormPage extends StatefulWidget {
  const PokemonFormPage({super.key, this.pokemon});

  final PokemonEntry? pokemon;

  @override
  State<PokemonFormPage> createState() => _PokemonFormPageState();
}

class _PokemonFormPageState extends State<PokemonFormPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _urlController;
  late final bool _isEditing;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.pokemon != null;
    _nameController = TextEditingController(text: widget.pokemon?.name ?? '');
    _urlController = TextEditingController(text: widget.pokemon?.url ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PokemonController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Pokémon' : 'Nuevo Pokémon'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _FormHeader(isEditing: _isEditing),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Pikachu',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'URL',
                  hintText: 'https://pokeapi.co/api/v2/pokemon/25/',
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () async {
                  final name = _nameController.text.trim();
                  final url = _urlController.text.trim();

                  if (name.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ingresa un nombre para continuar.'),
                      ),
                    );
                    return;
                  }

                  try {
                    if (_isEditing) {
                      final current = widget.pokemon!;
                      await controller.updatePokemon(
                        current.copyWith(
                          name: name,
                          url: url.isEmpty ? current.url : url,
                          updatedAt: DateTime.now(),
                        ),
                      );
                    } else {
                      await controller.createPokemon(
                        name: name,
                        url: url,
                      );
                    }

                    if (context.mounted) {
                      Get.back();
                    }
                  } catch (error) {
                    if (!context.mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('No se pudo guardar el Pokémon: $error'),
                      ),
                    );
                  }
                },
                child: Text(_isEditing ? 'Actualizar' : 'Crear'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormHeader extends StatelessWidget {
  const _FormHeader({required this.isEditing});

  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isEditing
              ? [Colors.teal.shade700, Colors.teal.shade300]
              : [Colors.indigo.shade700, Colors.indigo.shade300],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEditing ? 'Editar registro en memoria' : 'Crear nuevo registro',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Los cambios se guardan solo durante la ejecución de la app.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
          ),
        ],
      ),
    );
  }
}
