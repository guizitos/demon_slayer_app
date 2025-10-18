import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modelos/personagem.dart';

class PersonagensRepositorio {
  static const _base = 'https://www.demonslayer-api.com/api/v1';
  final http.Client client;

  PersonagensRepositorio({http.Client? client})
      : client = client ?? http.Client();

  Future<List<Personagem>> buscarPersonagens(
      {int pagina = 1, int limite = 5, String? nome}) async {
    final uri = Uri.parse('$_base/characters')
        .replace(queryParameters: _montarQuery(pagina, limite, nome));
    
    final resp = await client.get(uri).timeout(const Duration(seconds: 10));

    if (resp.statusCode != 200) {
      throw HttpException('Falha ao carregar personagens (${resp.statusCode})');
    }

    final data = json.decode(resp.body);
    
    // Para lista: { "content": [array de personagens] }
    if (data is Map && data['content'] is List) {
      return (data['content'] as List)
          .map((e) => Personagem.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw FormatException('Formato inesperado da API para lista');
  }

  Future<Personagem> buscarPersonagemPorId(int id) async {
    // Busca todos os personagens e filtra pelo ID
    final todosPersonagens = await buscarPersonagens(limite: 50);
    
    try {
      return todosPersonagens.firstWhere((p) => p.id == id);
    } catch (e) {
      // Fallback simples se não encontrar
      return Personagem(
        id: id,
        nome: 'Personagem $id',
        descricao: 'Informações não disponíveis.',
        imagemUrl: 'https://via.placeholder.com/300',
      );
    }
  }

  Map<String, String> _montarQuery(int pagina, int limite, String? nome) {
    final map = <String, String>{
      'page': pagina.toString(),
      'limit': limite.toString()
    };
    if (nome != null && nome.trim().isNotEmpty) map['name'] = nome.trim();
    
    return map;
  }
}

class HttpException implements Exception {
  final String mensagem;
  HttpException(this.mensagem);
  @override
  String toString() => mensagem;
}
