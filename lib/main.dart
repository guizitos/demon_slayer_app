import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provedores/personagens_provedor.dart';
import 'servicos/personagens_repositorio.dart';
import 'telas/splash_tela.dart';
import 'provedores/tema_provedor.dart'; // novo

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PersonagensProvedor(
            repositorio: PersonagensRepositorio(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => TemaProvedor(), // adicionando o tema
        ),
      ],
      child: Consumer<TemaProvedor>(
        builder: (context, tema, _) {
          return MaterialApp(
            title: 'Demon Slayer App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: tema.modo,
            home: const SplashTela(),
          );
        },
      ),
    );
  }
}
