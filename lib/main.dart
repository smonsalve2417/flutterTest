import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'core/app_theme.dart';
import 'features/pokemon/data/datasources/pokemon_memory_data_source.dart';
import 'features/pokemon/data/datasources/pokemon_remote_data_source.dart';
import 'features/pokemon/data/repositories/pokemon_repository_impl.dart';
import 'features/pokemon/domain/repositories/pokemon_repository.dart';
import 'features/pokemon/presentation/controllers/pokemon_controller.dart';
import 'features/pokemon/presentation/pages/pokemon_list_page.dart';

final messengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final httpClient = http.Client();
  final remoteDataSource = PokemonRemoteDataSource(httpClient);
  final memoryDataSource = PokemonMemoryDataSource();

  Get.put<PokemonRepository>(
    PokemonRepositoryImpl(
      remoteDataSource: remoteDataSource,
      memoryDataSource: memoryDataSource,
    ),
    permanent: true,
  );
  Get.put<PokemonController>(
    PokemonController(Get.find<PokemonRepository>()),
    permanent: true,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scaffoldMessengerKey: messengerKey,
      title: 'Pokémon Dex',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const PokemonListPage(),
    );
  }
}
