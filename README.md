# Pokémon Dex

Aplicación Flutter basada en clean architecture que consume la API pública de PokeAPI, mantiene los datos en memoria durante la ejecución y expone CRUD local sobre la lista cargada.

## Qué incluye

- Consumo REST desde `https://pokeapi.co/api/v2/pokemon`
- Lista dinámica con scroll fluido y carga incremental
- Navegación entre pantalla principal, detalle y formulario de creación/edición
- Manejo de estado con GetX
- Operaciones CRUD simuladas únicamente en RAM

## Estructura

- `lib/features/pokemon/domain` para entidades y contratos
- `lib/features/pokemon/data` para API REST y almacenamiento en memoria
- `lib/features/pokemon/presentation` para controlador y pantallas

## Ejecutar

```bash
flutter pub get
flutter run
```

## Validación

```bash
flutter analyze
```
