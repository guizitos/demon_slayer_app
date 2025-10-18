import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provedores/personagens_provedor.dart';
import 'lista_personagens_tela.dart';

class SplashTela extends StatefulWidget {
  const SplashTela({super.key});

  @override
  State<SplashTela> createState() => _SplashTelaState();
}

class _SplashTelaState extends State<SplashTela> {
  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provedor = Provider.of<PersonagensProvedor>(context, listen: false);
      await provedor.carregarInicial(); 
      
      if (!mounted) return;
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ListaPersonagensTela()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            FlutterLogo(size: 96),
            SizedBox(height: 12),
            Text('Demon Slayer App',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
