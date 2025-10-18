import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../modelos/personagem.dart';
import '../telas/detalhe_personagem_tela.dart';

class ItemListaPersonagem extends StatelessWidget {
  final Personagem personagem;
  const ItemListaPersonagem({super.key, required this.personagem});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Hero(
        tag: 'personagem-imagem-${personagem.id}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            width: 56,
            height: 56,
            child: CachedNetworkImage(
              imageUrl: personagem.imagemUrl.isNotEmpty
                  ? personagem.imagemUrl
                  : 'https://via.placeholder.com/150',
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      ),
      title: Text(personagem.nome),
      subtitle: Text(
        personagem.descricao.length > 50 
            ? '${personagem.descricao.substring(0, 50)}...'
            : personagem.descricao,
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DetalhePersonagemTela(
              personagemId: personagem.id,
              heroTag: 'personagem-imagem-${personagem.id}',
            ),
          ),
        );
      },
    );
  }
}
