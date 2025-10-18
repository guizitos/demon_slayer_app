import 'package:flutter/material.dart';

class ErroView extends StatelessWidget {
  final String mensagem;
  final VoidCallback aoTentarNovamente;
  const ErroView({super.key, required this.mensagem, required this.aoTentarNovamente});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                size: 48, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: aoTentarNovamente,
              icon: const Icon(Icons.refresh),
              label: const Text("Tentar novamente"),
            ),
          ],
        ),
      ),
    );
  }
}
