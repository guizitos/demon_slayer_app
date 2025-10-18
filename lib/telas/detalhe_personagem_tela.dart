import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../modelos/personagem.dart';
import '../servicos/personagens_repositorio.dart';
import '../widgets/erro_view.dart';

class DetalhePersonagemTela extends StatelessWidget {
  final int personagemId;
  final String heroTag;
  const DetalhePersonagemTela({super.key, required this.personagemId, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    final repo = PersonagensRepositorio();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Personagem'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: FutureBuilder<Personagem>(
        future: repo.buscarPersonagemPorId(personagemId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Carregando personagem...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return ErroView(
              mensagem: snapshot.error.toString(),
              aoTentarNovamente: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => DetalhePersonagemTela(
                      personagemId: personagemId, heroTag: heroTag),
                ),
              ),
            );
          }

          final personagem = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container da imagem - Altura flexível para imagem completa
                Center(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxHeight: 500, // Altura máxima aumentada
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.shadow.withAlpha(50),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Hero(
                        tag: heroTag,
                        child: CachedNetworkImage(
                          imageUrl: personagem.imagemUrl.isNotEmpty
                              ? personagem.imagemUrl
                              : 'https://via.placeholder.com/400x500/6D28D9/FFFFFF?text=Imagem+Não+Disponível',
                          fit: BoxFit.contain, // Mude para contain para imagem completa
                          width: double.infinity,
                          placeholder: (context, url) => Container(
                            height: 400,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Theme.of(context).colorScheme.surfaceContainerLow,
                                  Theme.of(context).colorScheme.surfaceContainerHigh,
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 12),
                                  Text(
                                    'Carregando imagem...',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 400,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Theme.of(context).colorScheme.surfaceContainerLow,
                                  Theme.of(context).colorScheme.surfaceContainerHigh,
                                ],
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    size: 80,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Imagem não disponível',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    personagem.nome,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurface,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Nome do personagem
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    personagem.nome,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 20),

                // Seção de descrição
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: 0.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.description,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Sobre o Personagem',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        personagem.descricao.isNotEmpty
                            ? personagem.descricao
                            : 'Nenhuma descrição disponível para este personagem no momento.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.6,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Informações adicionais
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoItem(
                        context,
                        Icons.photo_library,
                        'Imagem',
                        'Demon Slayer',
                      ),
                      _buildInfoItem(
                        context,
                        Icons.api,
                        'Fonte',
                        'API Oficial',
                      ),
                      _buildInfoItem(
                        context,
                        Icons.code,
                        'ID',
                        '#${personagem.id}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
